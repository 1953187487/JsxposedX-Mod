import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_chat_context_budget_estimator.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';

class AiChatHistoryRetriever {
  AiChatHistoryRetriever({
    AiChatContextBudgetEstimator? estimator,
  }) : _estimator = estimator ?? const AiChatContextBudgetEstimator();

  static const int _maxBundles = 3;
  static const int _maxSnippets = 6;
  static const int _maxSnippetChars = 220;
  static const String _responsesReasoningItemPrefix = '[responses_reasoning_item]';

  final AiChatContextBudgetEstimator _estimator;

  AiChatHistoryRetrieval retrieve({
    required List<AiMessage> olderMessages,
    required List<AiMessage> recentMessages,
    required AiChatTaskState taskState,
    required List<AiPinnedContextItem> pinnedContext,
    required AiToolExecutionTrace toolTrace,
    required int tokenBudget,
  }) {
    if (olderMessages.isEmpty) {
      return const AiChatHistoryRetrieval();
    }

    final queryTexts = _buildQueryTexts(
      recentMessages: recentMessages,
      taskState: taskState,
      pinnedContext: pinnedContext,
    );
    if (queryTexts.isEmpty) {
      return const AiChatHistoryRetrieval();
    }

    final bundles = _buildTurnBundles(olderMessages);
    if (bundles.isEmpty) {
      return const AiChatHistoryRetrieval();
    }

    final queryTerms = _extractSearchTerms(queryTexts);
    final toolTraceTerms = _extractSearchTerms([
      ...toolTrace.argumentSummaries.values,
      ...toolTrace.resultSummaries.values,
      ...toolTrace.toolCallIds,
    ]);

    final scoredBundles = bundles
        .map(
          (bundle) => _ScoredBundle(
            bundle: bundle,
            score: _scoreBundle(
              bundle,
              queryTexts: queryTexts,
              queryTerms: queryTerms,
              toolTrace: toolTrace,
              toolTraceTerms: toolTraceTerms,
            ),
          ),
        )
        .where((entry) => entry.score > 0)
        .toList(growable: false);

    if (scoredBundles.isEmpty) {
      return const AiChatHistoryRetrieval();
    }

    scoredBundles.sort((left, right) => right.score.compareTo(left.score));

    final maxTokenBudget = tokenBudget <= 0
        ? 0
        : ((tokenBudget * 0.25).floor() < 1600
              ? (tokenBudget * 0.25).floor()
              : 1600);
    final selectedBundles = <AiRetrievedHistoryBundle>[];
    var snippetCount = 0;
    var estimatedTokens = 0;

    for (final entry in scoredBundles) {
      if (selectedBundles.length >= _maxBundles || snippetCount >= _maxSnippets) {
        break;
      }

      final remainingSnippets = _maxSnippets - snippetCount;
      final snippets = _buildSnippets(
        entry.bundle,
        maxSnippets: remainingSnippets,
      );
      if (snippets.isEmpty) {
        continue;
      }

      final bundleTokens = _estimateBundleTokens(
        snippets: snippets,
        bundleIndex: selectedBundles.length + 1,
      );
      if (maxTokenBudget > 0 &&
          estimatedTokens + bundleTokens > maxTokenBudget &&
          selectedBundles.isNotEmpty) {
        continue;
      }

      selectedBundles.add(
        AiRetrievedHistoryBundle(
          score: entry.score,
          snippets: snippets,
        ),
      );
      snippetCount += snippets.length;
      estimatedTokens += bundleTokens;
    }

    if (selectedBundles.isEmpty) {
      return const AiChatHistoryRetrieval();
    }

    return AiChatHistoryRetrieval(
      bundles: List<AiRetrievedHistoryBundle>.unmodifiable(selectedBundles),
    );
  }

  List<String> _buildQueryTexts({
    required List<AiMessage> recentMessages,
    required AiChatTaskState taskState,
    required List<AiPinnedContextItem> pinnedContext,
  }) {
    final texts = <String>[];
    for (var index = recentMessages.length - 1; index >= 0; index--) {
      final message = recentMessages[index];
      if (message.role == 'user') {
        final semantic = _semanticContent(message).trim();
        if (semantic.isNotEmpty) {
          texts.add(semantic);
        }
        break;
      }
    }
    if (taskState.lastUserGoal?.trim().isNotEmpty ?? false) {
      texts.add(taskState.lastUserGoal!.trim());
    }
    if (taskState.currentStep?.trim().isNotEmpty ?? false) {
      texts.add(taskState.currentStep!.trim());
    }
    if (taskState.lastError?.trim().isNotEmpty ?? false) {
      texts.add(taskState.lastError!.trim());
    }
    for (final item in pinnedContext) {
      if (item.content.trim().isNotEmpty) {
        texts.add(item.content.trim());
      }
    }
    return texts;
  }

  List<_TurnBundle> _buildTurnBundles(List<AiMessage> messages) {
    final bundles = <_TurnBundle>[];
    final currentMessages = <AiMessage>[];

    void flush() {
      if (currentMessages.isEmpty) {
        return;
      }
      bundles.add(_TurnBundle(messages: List<AiMessage>.from(currentMessages)));
      currentMessages.clear();
    }

    for (final message in messages) {
      if (message.role == 'user') {
        flush();
        currentMessages.add(message);
        continue;
      }
      if (currentMessages.isEmpty) {
        continue;
      }
      currentMessages.add(message);
    }
    flush();
    return bundles;
  }

  double _scoreBundle(
    _TurnBundle bundle, {
    required List<String> queryTexts,
    required Set<String> queryTerms,
    required AiToolExecutionTrace toolTrace,
    required Set<String> toolTraceTerms,
  }) {
    final bundleTexts = bundle.messages
        .map(_renderMessageContentForSearch)
        .where((text) => text.isNotEmpty)
        .toList(growable: false);
    if (bundleTexts.isEmpty) {
      return 0;
    }

    final bundleText = bundleTexts.join('\n').toLowerCase();
    final bundleTerms = _extractSearchTerms(bundleTexts);
    var score = 0.0;

    for (final term in queryTerms) {
      if (!bundleTerms.contains(term)) {
        continue;
      }
      if (_isStrongIdentifier(term)) {
        score += 4.0;
      } else {
        score += 1.0;
      }
    }

    for (final queryText in queryTexts) {
      final normalized = queryText.trim().toLowerCase();
      if (normalized.length >= 4 && bundleText.contains(normalized)) {
        score += 2.0;
      }
    }

    final hasToolMessage = bundle.messages.any(
      (message) => message.role == 'tool' || message.hasToolCalls,
    );
    if (hasToolMessage) {
      score += 2.5;
    }

    final toolTraceMatch = toolTraceTerms.any(bundleText.contains);
    if (toolTraceMatch) {
      score += 3.0;
    }

    if (toolTrace.hasPendingToolResults && !toolTraceMatch) {
      return 0;
    }

    return score;
  }

  List<AiRetrievedHistorySnippet> _buildSnippets(
    _TurnBundle bundle, {
    required int maxSnippets,
  }) {
    final snippets = <AiRetrievedHistorySnippet>[];
    for (final message in bundle.messages) {
      if (snippets.length >= maxSnippets) {
        break;
      }
      final rendered = _renderMessageContentForDisplay(message);
      if (rendered.isEmpty) {
        continue;
      }
      snippets.add(
        AiRetrievedHistorySnippet(
          role: message.role,
          content: _truncate(rendered, _maxSnippetChars),
        ),
      );
    }
    return snippets;
  }

  int _estimateBundleTokens({
    required List<AiRetrievedHistorySnippet> snippets,
    required int bundleIndex,
  }) {
    final buffer = StringBuffer('历史片段 #$bundleIndex');
    for (final snippet in snippets) {
      buffer
        ..writeln()
        ..write('- ${snippet.role}: ${snippet.content}');
    }
    return _estimator.estimateTextTokens(buffer.toString(), role: 'system');
  }

  String _renderMessageContentForSearch(AiMessage message) {
    if (message.role == 'system' &&
        message.content.startsWith(_responsesReasoningItemPrefix)) {
      return '';
    }
    return _renderMessageContentForDisplay(message);
  }

  String _renderMessageContentForDisplay(AiMessage message) {
    if (message.role == 'system') {
      return '';
    }
    if (message.role == 'user') {
      return _semanticContent(message).trim();
    }
    if (message.hasToolCalls) {
      final calls = message.toolCalls ?? const [];
      final parts = calls.map((toolCall) {
        final function = toolCall['function'] as Map<String, dynamic>? ?? const {};
        final name = function['name']?.toString() ?? 'unknown_tool';
        final arguments = function['arguments']?.toString() ?? '';
        if (arguments.trim().isEmpty) {
          return name;
        }
        return '$name($arguments)';
      }).where((item) => item.trim().isNotEmpty);
      return '调用工具：${parts.join('；')}';
    }
    return message.content.replaceAll('\r', ' ').replaceAll('\n', ' ').trim();
  }

  Set<String> _extractSearchTerms(Iterable<String> texts) {
    final terms = <String>{};
    final pattern = RegExp(
      r'0x[a-fA-F0-9]+|[A-Za-z_][A-Za-z0-9_./:\\-]*|\d+|[\u4e00-\u9fff]{2,}',
    );
    for (final text in texts) {
      for (final match in pattern.allMatches(text)) {
        final value = match.group(0)?.trim().toLowerCase() ?? '';
        if (value.isEmpty) {
          continue;
        }
        if (value.length == 1 && !_isStrongIdentifier(value)) {
          continue;
        }
        terms.add(value);
      }
    }
    return terms;
  }

  bool _isStrongIdentifier(String term) {
    return term.startsWith('0x') ||
        term.contains('/') ||
        term.contains('\\') ||
        term.contains('.') ||
        term.contains('_') ||
        RegExp(r'^\d+$').hasMatch(term);
  }

  String _semanticContent(AiMessage message) {
    if (message.role != 'user') {
      return message.content;
    }
    return AiMultimodalMessageCodec.toSemanticText(
      message.content,
      isZh: true,
    );
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}

class AiChatHistoryRetrieval {
  const AiChatHistoryRetrieval({
    this.bundles = const [],
  });

  final List<AiRetrievedHistoryBundle> bundles;

  bool get hasContent => bundles.isNotEmpty;

  int get bundleCount => bundles.length;

  int get snippetCount => bundles.fold(
    0,
    (total, bundle) => total + bundle.snippets.length,
  );
}

class AiRetrievedHistoryBundle {
  const AiRetrievedHistoryBundle({
    required this.score,
    required this.snippets,
  });

  final double score;
  final List<AiRetrievedHistorySnippet> snippets;
}

class AiRetrievedHistorySnippet {
  const AiRetrievedHistorySnippet({
    required this.role,
    required this.content,
  });

  final String role;
  final String content;
}

class _TurnBundle {
  const _TurnBundle({
    required this.messages,
  });

  final List<AiMessage> messages;
}

class _ScoredBundle {
  const _ScoredBundle({
    required this.bundle,
    required this.score,
  });

  final _TurnBundle bundle;
  final double score;
}
