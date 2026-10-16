import 'dart:math' as math;
import 'dart:ui';

import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_text_input_context_menu.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/themes/ai_activation_theme.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_session_init_state.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/plan/ai_plan_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/runtime/ai_chat_environment_initializer.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_runtime_state.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_session_view.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_view_message.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_ask_mode_switch.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_input.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_list.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_plan_menu.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_plan_mode_switch.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_quick_settings_menu.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/ai_overlay_ui_state_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_ai_overlay_environment_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_ai_overlay_selection_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_browse_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_saved_items_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_search_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_ai_conversation_export_util.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/ai_overlay_assistant_glyph.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/ai_overlay_collapsed_ball.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_conversation_drawer.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_message_bubble.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_selection_tag_bar.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_host_runtime_provider.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AiOverlay extends HookConsumerWidget {
  const AiOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProcess = ref.watch(memoryToolSelectedProcessProvider);
    final isPanelVisible = ref.watch(
      overlayWindowHostRuntimeProvider.select(
        (state) => state.payload.isPanel && !state.isTransitioningToPanel,
      ),
    );

    if (selectedProcess == null) {
      return const SizedBox.shrink();
    }

    final mediaQuery = MediaQuery.of(context);
    final portraitTopInset = mediaQuery.orientation == Orientation.portrait
        ? mediaQuery.padding.top
        : 0.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(
          constraints.hasBoundedWidth
              ? constraints.maxWidth
              : mediaQuery.size.width,
          constraints.hasBoundedHeight
              ? constraints.maxHeight
              : mediaQuery.size.height,
        );
        return _AiOverlayViewport(
          selectedProcess: selectedProcess,
          viewportSize: viewportSize,
          portraitTopInset: portraitTopInset,
          isPanelVisible: isPanelVisible,
        );
      },
    );
  }
}

class _AiOverlayViewport extends HookConsumerWidget {
  const _AiOverlayViewport({
    required this.selectedProcess,
    required this.viewportSize,
    required this.portraitTopInset,
    required this.isPanelVisible,
  });

  final ProcessInfo selectedProcess;
  final Size viewportSize;
  final double portraitTopInset;
  final bool isPanelVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overlayState = ref.watch(aiOverlayUiStateControllerProvider);
    final overlayStateNotifier = ref.read(
      aiOverlayUiStateControllerProvider.notifier,
    );
    final isExpanded = overlayState.isExpanded;
    final hasSelectedValue = ref.watch(memoryAiOverlayHasSelectedValueProvider);
    final selectionTags = ref.watch(memoryAiOverlaySelectionTagsProvider);
    final offset = overlayState.offset;
    final persistedPanelSize = overlayState.panelSize;
    final dragStartGlobal = useRef<Offset?>(null);
    final dragStartOffset = useRef<Offset?>(null);
    final resizeStartGlobal = useRef<Offset?>(null);
    final resizeStartSize = useRef<Size?>(null);
    final isResizing = useRef(false);
    final isCreateSessionDialogOpen = useState(false);
    final isQuickSettingsOpen = useState(false);
    final sessionPendingDelete = useState<AiChatSessionView?>(null);
    final quotedMessage = useState<AiChatViewMessage?>(null);
    // 会话抽屉只在 AI 悬浮窗面板内部展开，不影响其它悬浮窗的触摸。
    final isDrawerOpen = useState(false);
    final drawerTicker = useSingleTickerProvider();
    final drawerController = useMemoized(
      () => AnimationController(
        vsync: drawerTicker,
        duration: const Duration(milliseconds: 240),
        reverseDuration: const Duration(milliseconds: 200),
      ),
    );
    useEffect(() => drawerController.dispose, [drawerController]);
    final pendingBoundPid = useRef<int?>(null);
    final pendingLayoutKey = useRef<String?>(null);
    final expansionController = useAnimationController(
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 220),
      initialValue: isExpanded ? 1 : 0,
    );
    final environment = ref.watch(
      memoryAiOverlayEnvironmentProvider(
        MemoryAiOverlayEnvironmentArgs(
          processInfo: selectedProcess,
          isZh: context.isZh,
        ),
      ),
    );
    final chatScopeId = environment.scopeId;
    final chatNotifier = ref.read(
      aiChatRuntimeProvider(packageName: chatScopeId).notifier,
    );
    final chatState = ref.watch(
      aiChatRuntimeProvider(packageName: chatScopeId),
    );
    // 计划模式：AI 每推进一个步骤都会重新输出完整清单，需要把最新消息同步进
    // 计划菜单（与宿主 AI 逆向界面同一套逻辑），否则 AiPlanMenu 永远是空的。
    final planEnabled = ref.watch(
      aiPlanProvider(chatScopeId).select((state) => state.enabled),
    );

    void syncPlan(AiChatRuntimeState snapshot) {
      ref
          .read(aiPlanProvider(chatScopeId).notifier)
          .syncFromMessages(
            snapshot.viewMessages,
            isStreaming: snapshot.isStreaming,
            sessionId: snapshot.currentSessionId,
          );
    }

    // 首帧渲染完成后再做一次初始同步；build 期间直接改 provider 会抛
    // "Tried to modify a provider while the widget tree was building"。
    useEffect(() {
      if (!planEnabled) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        syncPlan(ref.read(aiChatRuntimeProvider(packageName: chatScopeId)));
      });
      return null;
    }, [planEnabled, chatScopeId]);

    // 后续每次会话状态变化都在 build 之外同步一次。
    ref.listen(aiChatRuntimeProvider(packageName: chatScopeId), (_, next) {
      if (!planEnabled) return;
      syncPlan(next);
    });
    final sessions = chatState.sessions;
    final AiChatSessionView? currentSession = () {
      for (final session in sessions) {
        if (session.id == chatState.currentSessionId) {
          return session;
        }
      }
      return sessions.isNotEmpty ? sessions.first : null;
    }();
    final scrollController = useScrollController();
    final collapsedDiameter = 44.0;
    final collapsedSize = const Size(44.0, 44.0);
    final defaultExpandedSize = const Size(320.0, 420.0);
    final minExpandedSize = const Size(260.0, 280.0);
    final safePadding = 12.0;
    final expandedBorderRadius = 20.0;
    final collapsedBorderRadius = 14.0;
    final resizeHandleHighlightExtent = 40.0;
    final resizeHandleHitExtent = 52.0;
    final displayTitle = selectedProcess.name.trim().isEmpty
        ? selectedProcess.packageName
        : selectedProcess.name;
    final displaySubtitle =
        '${selectedProcess.packageName} · PID ${selectedProcess.pid}';
    final isUsingBuiltinConfig =
        ref.watch(activeAiConfigMetaProvider) is AsyncData<ActiveAiConfigMeta>
        ? (ref.watch(activeAiConfigMetaProvider) as AsyncData<ActiveAiConfigMeta>)
              .value
              .isBuiltin
        : false;
    final expansionProgress = useAnimation(
      CurvedAnimation(
        parent: expansionController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInOutCubic,
      ),
    );

    Future<void> initializeOverlayChat() async {
      await initializeAiChatEnvironment(
        notifier: chatNotifier,
        environment: environment,
        initErrorPrefix: context.isZh
            ? '内存会话初始化失败'
            : 'Memory session init failed',
      );
    }

    final hasEnvironmentSnapshot =
        (chatState.systemPrompt?.trim().isNotEmpty ?? false) &&
        chatState.toolsSpec != null &&
        chatState.toolExecutor != null;
    final hasMatchingEnvironmentSnapshot =
        hasEnvironmentSnapshot &&
        chatState.environmentVersion == environment.environmentVersion;
    final shouldAutoInitializeChat =
        !hasMatchingEnvironmentSnapshot &&
        chatState.sessionInitState == AiSessionInitState.ready;

    final availableExpandedWidth = math.max(
      viewportSize.width - (safePadding * 2),
      collapsedDiameter,
    );
    final availableExpandedHeight = math.max(
      viewportSize.height - portraitTopInset - (safePadding * 2),
      collapsedDiameter,
    );
    final effectiveMinExpandedWidth = math.min(
      minExpandedSize.width,
      availableExpandedWidth,
    );
    final effectiveMinExpandedHeight = math.min(
      minExpandedSize.height,
      availableExpandedHeight,
    );

    Size clampExpandedSize(Size size) {
      return Size(
        size.width
            .clamp(effectiveMinExpandedWidth, availableExpandedWidth)
            .toDouble(),
        size.height
            .clamp(effectiveMinExpandedHeight, availableExpandedHeight)
            .toDouble(),
      );
    }

    final expandedSize = clampExpandedSize(
      persistedPanelSize ?? defaultExpandedSize,
    );
    // 抽屉占据面板宽度的比例，滑出位移据此计算。
    final drawerWidth = expandedSize.width * 0.82;

    Offset defaultOffset(Size size) =>
        Offset(viewportSize.width - size.width - 20.0, portraitTopInset + 88.0);

    Offset clampOffset(Offset value, Size size) {
      final minX = safePadding;
      final maxX = math.max(
        minX,
        viewportSize.width - size.width - safePadding,
      );
      final minY = portraitTopInset + safePadding;
      final maxY = math.max(
        minY,
        viewportSize.height - size.height - safePadding,
      );
      return Offset(
        value.dx.clamp(minX, maxX).toDouble(),
        value.dy.clamp(minY, maxY).toDouble(),
      );
    }

    useEffect(() {
      final size = Size(collapsedDiameter, collapsedDiameter);
      final nextOffset = clampOffset(defaultOffset(size), size);
      if (pendingBoundPid.value == selectedProcess.pid) {
        return null;
      }
      pendingBoundPid.value = selectedProcess.pid;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pendingBoundPid.value = null;
        if (!context.mounted) {
          return;
        }
        overlayStateNotifier.bindProcess(
          pid: selectedProcess.pid,
          initialOffset: nextOffset,
          initialPanelSize: clampExpandedSize(defaultExpandedSize),
        );
      });
      return null;
    }, [selectedProcess.pid]);

    useEffect(() {
      if (isExpanded) {
        expansionController.forward();
      } else {
        expansionController.reverse();
      }
      return null;
    }, [isExpanded]);

    useEffect(() {
      if (!shouldAutoInitializeChat) {
        return null;
      }
      Future.microtask(() async {
        await initializeOverlayChat();
      });
      return null;
    }, [chatScopeId, shouldAutoInitializeChat]);

    useEffect(
      () {
        final nextPanelSize = clampExpandedSize(
          persistedPanelSize ?? defaultExpandedSize,
        );
        final panelSizeChanged = persistedPanelSize != nextPanelSize;
        final size = isExpanded ? nextPanelSize : collapsedSize;
        final nextOffset = clampOffset(offset ?? defaultOffset(size), size);
        final layoutKey =
            '${viewportSize.width}:${viewportSize.height}:$portraitTopInset:$isExpanded:${nextPanelSize.width}:${nextPanelSize.height}:${nextOffset.dx}:${nextOffset.dy}:${panelSizeChanged ? 1 : 0}';
        if (pendingLayoutKey.value == layoutKey) {
          return null;
        }
        pendingLayoutKey.value = layoutKey;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          pendingLayoutKey.value = null;
          if (!context.mounted) {
            return;
          }
          if (panelSizeChanged) {
            overlayStateNotifier.setPanelSize(nextPanelSize);
          }
          overlayStateNotifier.setOffset(nextOffset);
        });
        return null;
      },
      [
        viewportSize.width,
        viewportSize.height,
        portraitTopInset,
        isExpanded,
        persistedPanelSize?.width,
        persistedPanelSize?.height,
      ],
    );

    final lastMessageId = useRef<String?>(null);
    useEffect(() {
      final visibleMessages = chatState.visibleViewMessages;
      if (visibleMessages.isEmpty) {
        return null;
      }

      final currentLastId = visibleMessages.last.id;
      final isNewMessage = lastMessageId.value != currentLastId;
      lastMessageId.value = currentLastId;
      if (!scrollController.hasClients || !isNewMessage) {
        return null;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) {
          return;
        }
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      });
      return null;
    }, [chatState.visibleViewMessages.length]);

    final followScheduled = useRef(false);
    useEffect(() {
      const followThreshold = 80.0;
      final subscription = chatNotifier.streamingContentStream.listen((
        content,
      ) {
        if (content.isEmpty || !scrollController.hasClients) {
          return;
        }
        if (scrollController.offset > followThreshold) {
          return;
        }
        if (followScheduled.value) return;
        followScheduled.value = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          followScheduled.value = false;
          if (!scrollController.hasClients) {
            return;
          }
          if (scrollController.offset > followThreshold) {
            return;
          }
          scrollController.jumpTo(0);
        });
      });
      return subscription.cancel;
    }, [chatNotifier, scrollController]);

    final collapsedOffset = clampOffset(
      offset ?? defaultOffset(collapsedSize),
      collapsedSize,
    );
    final expandedOffset = clampOffset(
      offset ?? defaultOffset(expandedSize),
      expandedSize,
    );
    final resolvedSize =
        Size.lerp(collapsedSize, expandedSize, expansionProgress) ??
        collapsedSize;
    final resolvedOffset =
        Offset.lerp(collapsedOffset, expandedOffset, expansionProgress) ??
        collapsedOffset;
    final showExpandedPanel = expansionProgress > 0.02;
    final collapsedBallOpacity =
        1.0 -
        Curves.easeIn.transform((expansionProgress / 0.4).clamp(0.0, 1.0));
    final shouldBuildPanelContent = expansionProgress > 0.9;
    final panelContentOpacity = Curves.easeOutCubic.transform(
      ((expansionProgress - 0.9) / 0.1).clamp(0.0, 1.0),
    );
    final panelContentTranslateY = lerpDouble(6.0, 0.0, panelContentOpacity)!;
    final showPanelInteractions = panelContentOpacity > 0.98;
    final isLandscapePanel = resolvedSize.width > resolvedSize.height * 1.08;
    final panelBaseSize = isLandscapePanel
        ? const Size(420.0, 300.0)
        : const Size(320.0, 420.0);
    final contentScale = math
        .min(
          resolvedSize.width / panelBaseSize.width,
          resolvedSize.height / panelBaseSize.height,
        )
        .clamp(isLandscapePanel ? 0.58 : 0.54, 1.0)
        .toDouble();
    final isCompactPanel =
        isLandscapePanel ||
        contentScale < 0.96 ||
        resolvedSize.width < 340.0 ||
        resolvedSize.height < 420.0;
    final headerLeftPadding = (isCompactPanel ? 10.0 : 14.0) * contentScale;
    final headerTopPadding = (isCompactPanel ? 8.0 : 12.0) * contentScale;
    final headerRightPadding = (isCompactPanel ? 8.0 : 12.0) * contentScale;
    final headerClosePadding = (isCompactPanel ? 3.0 : 4.0) * contentScale;
    final headerCloseIconSize = (isCompactPanel ? 14.0 : 16.0) * contentScale;
    final headerGap = (isCompactPanel ? 8.0 : 10.0) * contentScale;
    final headerTitleFontSize = (isCompactPanel ? 11.5 : 13.0) * contentScale;
    final headerSubtitleFontSize = (isCompactPanel ? 9.5 : 11.0) * contentScale;
    final headerSubtitleGap = (isCompactPanel ? 1.0 : 2.0) * contentScale;
    final contentLeftPadding = (isCompactPanel ? 8.0 : 10.0) * contentScale;
    final contentTopPadding = (isCompactPanel ? 42.0 : 56.0) * contentScale;
    final contentRightPadding = (isCompactPanel ? 8.0 : 12.0) * contentScale;
    final contentBottomPadding = (isCompactPanel ? 8.0 : 12.0) * contentScale;

    void clearSelectionTags() {
      ref.read(memoryToolResultSelectionProvider.notifier).clear();
      ref.read(memoryToolBrowseControllerProvider.notifier).clearSelection();
      ref.read(memoryToolSavedItemSelectionProvider.notifier).clearSelection();
    }

    void removeSelectionTag(MemoryAiOverlaySelectionTag tag) {
      switch (tag.source) {
        case MemoryAiOverlaySelectionSource.search:
          ref
              .read(memoryToolResultSelectionProvider.notifier)
              .removeAddress(tag.address);
          break;
        case MemoryAiOverlaySelectionSource.browse:
          ref
              .read(memoryToolBrowseControllerProvider.notifier)
              .removeSelectionAddress(tag.address);
          break;
        case MemoryAiOverlaySelectionSource.saved:
          ref
              .read(memoryToolSavedItemSelectionProvider.notifier)
              .removeAddress(tag.address);
          break;
      }
    }

    String composeSelectionTagMessage(String rawText) {
      if (selectionTags.isEmpty) {
        return rawText.trim();
      }

      final lines = <String>[
        context.isZh
            ? '以下是当前内存工具里我选中的值，请结合它们理解本次提问：'
            : 'These are the values currently selected in the memory tool. Use them as context for this request:',
        for (final tag in selectionTags)
          '- ${switch (tag.source) {
            MemoryAiOverlaySelectionSource.search => context.isZh ? '搜索' : 'Search',
            MemoryAiOverlaySelectionSource.browse => context.isZh ? '浏览' : 'Browse',
            MemoryAiOverlaySelectionSource.saved => context.isZh ? '暂存' : 'Saved',
          }} | ${tag.addressLabel} | ${tag.typeLabel} | ${tag.valueLabel}',
      ];

      final trimmed = rawText.trim();
      if (trimmed.isNotEmpty) {
        lines
          ..add('')
          ..add(trimmed);
      }

      return lines.join('\n').trim();
    }

    void startDragging(Offset globalPosition) {
      if (isResizing.value) {
        return;
      }
      dragStartGlobal.value = globalPosition;
      dragStartOffset.value = resolvedOffset;
    }

    void updateDragging(Offset globalPosition, Size size) {
      if (isResizing.value) {
        return;
      }
      final startGlobal = dragStartGlobal.value;
      final startOffset = dragStartOffset.value;
      if (startGlobal == null || startOffset == null) {
        return;
      }
      final delta = globalPosition - startGlobal;
      overlayStateNotifier.setOffset(clampOffset(startOffset + delta, size));
    }

    void stopDragging() {
      dragStartGlobal.value = null;
      dragStartOffset.value = null;
    }

    void closeDrawer() {
      isDrawerOpen.value = false;
    }

    useEffect(() {
      if (isDrawerOpen.value) {
        drawerController.forward();
      } else {
        drawerController.reverse();
      }
      return null;
    }, [isDrawerOpen.value, drawerController]);

    return Offstage(
      offstage: !isPanelVisible,
      child: TickerMode(
        enabled: isPanelVisible,
        child: IgnorePointer(
          ignoring: !isPanelVisible,
          child: Stack(
            children: [
              Positioned(
                left: resolvedOffset.dx,
                top: resolvedOffset.dy,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: showExpandedPanel
                      ? null
                      : (details) => startDragging(details.globalPosition),
                  onPanUpdate: showExpandedPanel
                      ? null
                      : (details) => updateDragging(
                          details.globalPosition,
                          resolvedSize,
                        ),
                  onPanEnd: showExpandedPanel ? null : (_) => stopDragging(),
                  onPanCancel: showExpandedPanel ? null : stopDragging,
                  child: CustomPaint(
                    foregroundPainter: showPanelInteractions
                        ? _AiOverlayResizeBorderHighlightPainter(
                            color: context.colorScheme.primary.withValues(
                              alpha: 0.94,
                            ),
                            borderRadius: expandedBorderRadius,
                            clipExtent: resizeHandleHighlightExtent,
                          )
                        : null,
                    child: Container(
                      width: resolvedSize.width,
                      height: resolvedSize.height,
                      decoration: BoxDecoration(
                        color: showExpandedPanel
                            ? context.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.76 * expansionProgress)
                            : null,
                        gradient: null,
                        borderRadius: BorderRadius.circular(
                          lerpDouble(
                            collapsedBorderRadius,
                            expandedBorderRadius,
                            expansionProgress,
                          )!,
                        ),
                        boxShadow: showExpandedPanel
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.1 * expansionProgress,
                                  ),
                                  blurRadius: lerpDouble(
                                    8.0,
                                    16.0,
                                    expansionProgress,
                                  )!,
                                  offset: Offset(
                                    0,
                                    lerpDouble(2.0, 6.0, expansionProgress)!,
                                  ),
                                ),
                              ]
                            : null,
                        border: showExpandedPanel
                            ? Border.all(
                                color: context.colorScheme.outlineVariant
                                    .withValues(
                                      alpha: 0.34 * expansionProgress,
                                    ),
                                width: 1,
                              )
                            : null,
                      ),
                      clipBehavior: showExpandedPanel
                          ? Clip.antiAlias
                          : Clip.none,
                      child: Stack(
                        children: <Widget>[
                          if (showExpandedPanel && shouldBuildPanelContent)
                            Positioned.fill(
                              child: IgnorePointer(
                                ignoring: !showPanelInteractions,
                                child: Opacity(
                                  opacity: panelContentOpacity,
                                  child: Transform.translate(
                                    offset: Offset(0, panelContentTranslateY),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: expansionProgress > 0.98
                                              ? BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 8,
                                                    sigmaY: 8,
                                                  ),
                                                  child: ColoredBox(
                                                    color: context
                                                        .colorScheme
                                                        .surface
                                                        .withValues(
                                                          alpha: 0.08,
                                                        ),
                                                  ),
                                                )
                                              : ColoredBox(
                                                  color: context
                                                      .colorScheme
                                                      .surface
                                                      .withValues(alpha: 0.04),
                                                ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onPanStart: showPanelInteractions
                                                ? (details) => startDragging(
                                                    details.globalPosition,
                                                  )
                                                : null,
                                            onPanUpdate: showPanelInteractions
                                                ? (details) => updateDragging(
                                                    details.globalPosition,
                                                    expandedSize,
                                                  )
                                                : null,
                                            onPanEnd: showPanelInteractions
                                                ? (_) => stopDragging()
                                                : null,
                                            onPanCancel: showPanelInteractions
                                                ? stopDragging
                                                : null,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                headerLeftPadding,
                                                headerTopPadding,
                                                headerRightPadding,
                                                0,
                                              ),
                                              child: Row(
                                                children: [
                                                  _AiOverlaySessionActions(
                                                    sessionCount:
                                                        sessions.length,
                                                    isCompact: isCompactPanel,
                                                    contentScale: contentScale,
                                                    onToggleDrawer: () {
                                                      isDrawerOpen.value =
                                                          !isDrawerOpen.value;
                                                    },
                                                    isDrawerOpen:
                                                        isDrawerOpen.value,
                                                  ),
                                                  SizedBox(width: headerGap),
                                                  Expanded(
                                                    child: _AiOverlayHeaderIdentity(
                                                      displayTitle:
                                                          displayTitle,
                                                      displaySubtitle:
                                                          displaySubtitle,
                                                      contentScale:
                                                          contentScale,
                                                      isCompact: isCompactPanel,
                                                      titleFontSize:
                                                          headerTitleFontSize,
                                                      subtitleFontSize:
                                                          headerSubtitleFontSize,
                                                      subtitleGap:
                                                          headerSubtitleGap,
                                                    ),
                                                  ),
                                                  SizedBox(width: headerGap),
                                                  Material(
                                                    color: context
                                                        .colorScheme
                                                        .surface
                                                        .withValues(
                                                          alpha: 0.28,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.0 * contentScale,
                                                        ),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0 * contentScale,
                                                          ),
                                                      onTap: () {
                                                        overlayStateNotifier
                                                            .setExpanded(false);
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                          headerClosePadding,
                                                        ),
                                                        child: Icon(
                                                          Icons.remove_rounded,
                                                          size:
                                                              headerCloseIconSize,
                                                          color: context
                                                              .colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                alpha: 0.82,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            contentLeftPadding,
                                            contentTopPadding,
                                            contentRightPadding,
                                            contentBottomPadding,
                                          ),
                                          child: AiChatCompactScope(
                                            enabled: isCompactPanel,
                                            scale: contentScale,
                                            child: Column(
                                              children: [
                                                _AiOverlayInitBanner(
                                                  chatState: chatState,
                                                  onRetry:
                                                      initializeOverlayChat,
                                                  isCompact: isCompactPanel,
                                                ),
                                                Expanded(
                                                  child: AiChatList(
                                                    messages: chatState
                                                        .visibleViewMessages,
                                                    scrollController:
                                                        scrollController,
                                                    packageName: chatScopeId,
                                                    isCompact: isCompactPanel,
                                                    customTitle: context.isZh
                                                        ? '内存调试助手'
                                                        : 'Memory Assistant',
                                                    customSubtitle:
                                                        displaySubtitle,
                                                    onQuote: (message) =>
                                                        quotedMessage.value =
                                                            message,
                                                    bubbleBuilder:
                                                        ({
                                                          required message,
                                                          required retryLabel,
                                                          required onRetry,
                                                          required packageName,
                                                          onEdit,
                                                          onRegenerate,
                                                          onDelete,
                                                          onQuote,
                                                          rawDetails,
                                                          toolInvocations =
                                                              const [],
                                                          onToolApprove,
                                                          onToolReject,
                                                          imageSources =
                                                              const [],
                                                          pendingQuestion,
                                                          onAnswer,
                                                        }) => MemoryAiChatBubble(
                                                          key: ValueKey(
                                                            message.id,
                                                          ),
                                                          content:
                                                              message.content,
                                                          role: message.role,
                                                          isError:
                                                              message.isError,
                                                          errorHint:
                                                              message.errorHint,
                                                          isToolResultBubble:
                                                              message
                                                                  .isToolResultBubble,
                                                          retryLabel:
                                                              retryLabel,
                                                          onRetry: onRetry,
                                                          packageName:
                                                              packageName,
                                                          onEdit: onEdit,
                                                          onRegenerate:
                                                              onRegenerate,
                                                          onDelete: onDelete,
                                                          onQuote: onQuote,
                                                          rawDetails:
                                                              rawDetails
                                                                  as String?,
                                                          toolInvocations:
                                                              toolInvocations,
                                                          onToolApprove:
                                                              onToolApprove,
                                                          onToolReject:
                                                              onToolReject,
                                                          imageSources:
                                                              imageSources,
                                                          pendingQuestion:
                                                              pendingQuestion,
                                                          onAnswer: onAnswer,
                                                        ),
                                                    streamingBubbleBuilder:
                                                        ({
                                                          required message,
                                                          required retryLabel,
                                                          required onRetry,
                                                          required packageName,
                                                          required streamingContentStream,
                                                          required streamingThinkingStream,
                                                          onQuote,
                                                          toolInvocations =
                                                              const [],
                                                          onToolApprove,
                                                          onToolReject,
                                                          pendingQuestion,
                                                          onAnswer,
                                                        }) => MemoryAiStreamingChatBubble(
                                                          key: ValueKey(
                                                            message.id,
                                                          ),
                                                          initialContent:
                                                              message.content,
                                                          role: message.role,
                                                          isError:
                                                              message.isError,
                                                          errorHint:
                                                              message.errorHint,
                                                          isToolResultBubble:
                                                              message
                                                                  .isToolResultBubble,
                                                          retryLabel:
                                                              retryLabel,
                                                          onRetry: onRetry,
                                                          packageName:
                                                              packageName,
                                                          streamingContentStream:
                                                              streamingContentStream,
                                                          streamingThinkingStream:
                                                              streamingThinkingStream,
                                                          onQuote: onQuote,
                                                          toolInvocations:
                                                              toolInvocations,
                                                          onToolApprove:
                                                              onToolApprove,
                                                          onToolReject:
                                                              onToolReject,
                                                          pendingQuestion:
                                                              pendingQuestion,
                                                          onAnswer: onAnswer,
                                                        ),
                                                  ),
                                                ),
                                                if (selectionTags
                                                    .isNotEmpty) ...[
                                                  SizedBox(
                                                    height:
                                                        (isCompactPanel
                                                            ? 4.0
                                                            : 6.0) *
                                                        contentScale,
                                                  ),
                                                  MemoryAiSelectionTagBar(
                                                    tags: selectionTags,
                                                    onRemoveTag:
                                                        removeSelectionTag,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        (isCompactPanel
                                                            ? 4.0
                                                            : 6.0) *
                                                        contentScale,
                                                  ),
                                                ],
                                                AiChatInput(
                                                  packageName: chatScopeId,
                                                  useOverlayFilePicker: true,
                                                  isEmbedded: true,
                                                  isCompact: isCompactPanel,
                                                  onRetryInitialization:
                                                      initializeOverlayChat,
                                                  inputTopContent: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      if (quotedMessage.value !=
                                                          null)
                                                        _AiOverlayQuoteBar(
                                                          excerpt: _quoteExcerpt(
                                                            quotedMessage
                                                                .value!
                                                                .content,
                                                          ),
                                                          onDismiss: () =>
                                                              quotedMessage
                                                                      .value =
                                                                  null,
                                                        ),
                                                      // 执行计划面板与宿主逆向界面同源，计划模式开启且已
                                                      // 生成计划时渲染；无计划时自身收起为 0 尺寸。
                                                      AiPlanMenu(
                                                        packageName:
                                                            chatScopeId,
                                                      ),
                                                    ],
                                                  ),
                                                  // 与宿主 AI 逆向界面一致：计划模式与问答模式
                                                  // 开关就放在输入框上方的快捷操作行，而不是藏进
                                                  // 额外弹窗。
                                                  quickActionsTrailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      AiPlanModeSwitch(
                                                        packageName:
                                                            chatScopeId,
                                                      ),
                                                      AiAskModeSwitch(
                                                        packageName:
                                                            chatScopeId,
                                                      ),
                                                    ],
                                                  ),
                                                  hasComposedContent:
                                                      selectionTags.isNotEmpty ||
                                                      quotedMessage.value !=
                                                          null,
                                                  composeOutgoingText: (rawText) =>
                                                      _composeQuotedText(
                                                        rawText:
                                                            composeSelectionTagMessage(
                                                              rawText,
                                                            ),
                                                        quoted:
                                                            quotedMessage.value,
                                                      ),
                                                  onSendCommitted: () {
                                                    clearSelectionTags();
                                                    quotedMessage.value = null;
                                                  },
                                                  // 悬浮窗为独立引擎，宿主 AppBottomSheet 无法
                                                  // 正确呈现，改用覆盖层面板承载引用上下文等面板。
                                                  presentSheet:
                                                      showOverlayPanelSheet,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 2,
                                          bottom: 2,
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onPanStart: showPanelInteractions
                                                ? (details) {
                                                    isResizing.value = true;
                                                    resizeStartGlobal.value =
                                                        details.globalPosition;
                                                    resizeStartSize.value =
                                                        expandedSize;
                                                  }
                                                : null,
                                            onPanUpdate: showPanelInteractions
                                                ? (details) {
                                                    final startGlobal =
                                                        resizeStartGlobal.value;
                                                    final startSize =
                                                        resizeStartSize.value;
                                                    if (startGlobal == null ||
                                                        startSize == null) {
                                                      return;
                                                    }
                                                    final delta =
                                                        details.globalPosition -
                                                        startGlobal;
                                                    final nextSize =
                                                        clampExpandedSize(
                                                          Size(
                                                            startSize.width +
                                                                delta.dx,
                                                            startSize.height +
                                                                delta.dy,
                                                          ),
                                                        );
                                                    overlayStateNotifier
                                                        .setPanelSize(nextSize);
                                                    overlayStateNotifier
                                                        .setOffset(
                                                          clampOffset(
                                                            expandedOffset,
                                                            nextSize,
                                                          ),
                                                        );
                                                  }
                                                : null,
                                            onPanEnd: showPanelInteractions
                                                ? (_) {
                                                    resizeStartGlobal.value =
                                                        null;
                                                    resizeStartSize.value =
                                                        null;
                                                    isResizing.value = false;
                                                  }
                                                : null,
                                            onPanCancel: showPanelInteractions
                                                ? () {
                                                    resizeStartGlobal.value =
                                                        null;
                                                    resizeStartSize.value =
                                                        null;
                                                    isResizing.value = false;
                                                  }
                                                : null,
                                            child: SizedBox(
                                              width: resizeHandleHitExtent,
                                              height: resizeHandleHitExtent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: collapsedBallOpacity <= 0.01,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Opacity(
                                  opacity: collapsedBallOpacity,
                                  child: Transform.scale(
                                    scale: lerpDouble(
                                      1.0,
                                      0.9,
                                      expansionProgress,
                                    )!,
                                    child: AiOverlayCollapsedBall(
                                      isHighlighted: hasSelectedValue,
                                      onTap: () {
                                        overlayStateNotifier.setExpanded(true);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 会话抽屉：只在面板区域内滑出，不占用面板外的触摸区域，
              // 因此不会影响其它悬浮窗的点击。
              if (showExpandedPanel)
                Positioned(
                  left: resolvedOffset.dx,
                  top: resolvedOffset.dy,
                  child: SizedBox(
                    width: expandedSize.width,
                    height: expandedSize.height,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        expandedBorderRadius,
                      ),
                      child: Stack(
                        children: [
                          // 左边缘右滑拉出抽屉：只覆盖面板左侧一条窄边，
                          // 不拦截面板其余区域的点击与滚动。
                          if (!isDrawerOpen.value)
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              width: 22.0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragEnd: (details) {
                                  if ((details.primaryVelocity ?? 0) > 120) {
                                    isDrawerOpen.value = true;
                                  }
                                },
                                onHorizontalDragUpdate: (details) {
                                  if (details.delta.dx > 3) {
                                    isDrawerOpen.value = true;
                                  }
                                },
                              ),
                            ),
                          // 遮罩：点击面板空白处收起抽屉，同时吃住面板内的
                          // 触摸，避免误触到下方的输入框。
                          Positioned.fill(
                            child: ValueListenableBuilder<double>(
                              valueListenable: drawerController,
                              builder: (context, progress, _) {
                                if (progress <= 0.01) {
                                  return const SizedBox.shrink();
                                }
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: closeDrawer,
                                  onHorizontalDragEnd: (details) {
                                    if ((details.primaryVelocity ?? 0) < -120) {
                                      closeDrawer();
                                    }
                                  },
                                  child: ColoredBox(
                                    color: Colors.black.withValues(
                                      alpha: 0.28 * progress,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            child: ValueListenableBuilder<double>(
                              valueListenable: drawerController,
                              builder: (context, progress, child) {
                                if (progress <= 0.001) {
                                  return const SizedBox.shrink();
                                }
                                return Transform.translate(
                                  offset: Offset(
                                    -drawerWidth * (1 - progress),
                                    0,
                                  ),
                                  child: child,
                                );
                              },
                              child: Material(
                                color: Colors.transparent,
                                child: MemoryAiConversationDrawer(
                                  processName: displayTitle,
                                  packageName: selectedProcess.packageName,
                                  pid: selectedProcess.pid,
                                  appIcon: selectedProcess.icon,
                                  isBuiltinConfig: isUsingBuiltinConfig,
                                  sessions: sessions,
                                  currentSessionId: currentSession?.id,
                                  onClose: closeDrawer,
                                  onOpenQuickSettings: () {
                                    closeDrawer();
                                    isQuickSettingsOpen.value = true;
                                  },
                                  onCreateSession: () {
                                    closeDrawer();
                                    isCreateSessionDialogOpen.value = true;
                                  },
                                  onSessionSelected: (sessionId) {
                                    closeDrawer();
                                    chatNotifier.switchSession(sessionId);
                                  },
                                  onRequestDelete: (session) {
                                    closeDrawer();
                                    sessionPendingDelete.value = session;
                                  },
                                  onRequestExport: (session, isMarkdown) {
                                    closeDrawer();
                                    exportOverlayAiConversation(
                                      context: context,
                                      ref: ref,
                                      conversationId: session.id,
                                      conversationTitle: session.name,
                                      isMarkdown: isMarkdown,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (isCreateSessionDialogOpen.value)
                Positioned.fill(
                  child: _AiOverlayCreateSessionDialog(
                    chatScopeId: chatScopeId,
                    initialName:
                        '${context.l10n.aiNewSession} ${DateFormat('MM-dd HH:mm').format(DateTime.now())}',
                    onClose: () {
                      isCreateSessionDialogOpen.value = false;
                    },
                  ),
                ),
              if (sessionPendingDelete.value != null)
                Positioned.fill(
                  child: _AiOverlayDeleteSessionDialog(
                    sessionName: sessionPendingDelete.value!.name,
                    onClose: () {
                      sessionPendingDelete.value = null;
                    },
                    onConfirm: () async {
                      final target = sessionPendingDelete.value;
                      sessionPendingDelete.value = null;
                      if (target == null) {
                        return;
                      }
                      await chatNotifier.deleteSession(target.id);
                    },
                  ),
                ),
              if (isQuickSettingsOpen.value)
                Positioned.fill(
                  child: _AiOverlayQuickSettingsDialog(
                    chatScopeId: chatScopeId,
                    onClose: () {
                      isQuickSettingsOpen.value = false;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _AiOverlayHeaderIdentity extends StatelessWidget {
  const _AiOverlayHeaderIdentity({
    required this.displayTitle,
    required this.displaySubtitle,
    required this.contentScale,
    required this.isCompact,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.subtitleGap,
  });

  final String displayTitle;
  final String displaySubtitle;
  final double contentScale;
  final bool isCompact;
  final double titleFontSize;
  final double subtitleFontSize;
  final double subtitleGap;

  @override
  Widget build(BuildContext context) {
    final iconExtent = (isCompact ? 28.0 : 32.0) * contentScale;

    return Row(
      children: [
        SizedBox(
          width: iconExtent,
          height: iconExtent,
          child: AiOverlayAssistantGlyph(size: iconExtent),
        ),
        SizedBox(width: (isCompact ? 8.0 : 10.0) * contentScale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.onSurface,
                  height: 1.05,
                ),
              ),
              SizedBox(height: subtitleGap),
              Text(
                displaySubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: context.colorScheme.onSurfaceVariant,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 悬浮窗头部的对话抽屉入口，右上角带会话数徽标。
///
/// 点击（或从面板左边缘右滑）拉出 [MemoryAiConversationDrawer]。
/// 会话切换 / 新建 / 删除等能力都收在抽屉内，窗口上不再重复显示。
class _AiOverlayDrawerButton extends StatelessWidget {
  const _AiOverlayDrawerButton({
    required this.sessionCount,
    required this.isActive,
    required this.isCompact,
    required this.contentScale,
    required this.onTap,
  });

  final int sessionCount;
  final bool isActive;
  final bool isCompact;
  final double contentScale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12.0 * contentScale);
    final surfaceColor = context.colorScheme.surface.withValues(alpha: 0.3);
    final borderColor = context.colorScheme.outlineVariant.withValues(
      alpha: 0.34,
    );
    final foregroundColor = context.colorScheme.onSurface;
    final iconSize = (isCompact ? 14.0 : 16.0) * contentScale;
    final extent = (isCompact ? 30.0 : 34.0) * contentScale;
    final hasSessions = sessionCount > 0;

    return Tooltip(
      message: context.isZh ? '对话列表' : 'Conversations',
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          width: extent,
          height: extent,
          decoration: BoxDecoration(
            color: isActive
                ? aiActivationGradientColors[1].withValues(alpha: 0.16)
                : surfaceColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: hasSessions
                  ? aiActivationGradientColors[1].withValues(
                      alpha: isActive ? 0.6 : 0.22,
                    )
                  : borderColor,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.forum_outlined,
                size: iconSize,
                color: foregroundColor.withValues(alpha: 0.82),
              ),
              if (hasSessions)
                Positioned(
                  top: 4.0 * contentScale,
                  right: 4.0 * contentScale,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.0 * contentScale,
                      vertical: 0.5 * contentScale,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12.0 * contentScale,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(7.0 * contentScale),
                    ),
                    child: Text(
                      '$sessionCount',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (isCompact ? 7.0 : 8.0) * contentScale,
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 窗口头部右侧只保留抽屉入口。
///
/// 会话列表、切换、新建、删除都已收进 [MemoryAiConversationDrawer]，
/// 窗口上不再重复渲染，避免同一功能出现两次。
class _AiOverlaySessionActions extends StatelessWidget {
  const _AiOverlaySessionActions({
    required this.sessionCount,
    required this.isCompact,
    required this.contentScale,
    required this.onToggleDrawer,
    required this.isDrawerOpen,
  });

  final int sessionCount;
  final bool isCompact;
  final double contentScale;
  final VoidCallback onToggleDrawer;
  final bool isDrawerOpen;

  @override
  Widget build(BuildContext context) {
    return _AiOverlayDrawerButton(
      sessionCount: sessionCount,
      isActive: isDrawerOpen,
      isCompact: isCompact,
      contentScale: contentScale,
      onTap: onToggleDrawer,
    );
  }
}

class _AiOverlayCreateSessionDialog extends HookConsumerWidget {
  const _AiOverlayCreateSessionDialog({
    required this.chatScopeId,
    required this.initialName,
    required this.onClose,
  });

  final String chatScopeId;
  final String initialName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: initialName);
    final isSubmitting = useState(false);
    useListenable(controller);

    final canConfirm = !isSubmitting.value && controller.text.trim().isNotEmpty;

    return OverlayPanelDialog.card(
      onClose: isSubmitting.value ? null : onClose,
      maxWidthPortrait: 360.0,
      maxWidthLandscape: 400.0,
      maxHeightPortrait: 250.0,
      maxHeightLandscape: 250.0,
      cardBorderRadius: 18.0,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.aiNewSession,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12.0),
              CustomTextField(
                controller: controller,
                labelText: context.l10n.aiSessionName,
                hintText: context.l10n.aiSessionNameHint,
                contextMenuBuilder: buildOverlayTextInputContextMenu,
                fillColor: context.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.22),
                focusedBorderColor: context.colorScheme.primary,
                enabledBorderColor: context.colorScheme.outlineVariant
                    .withValues(alpha: 0.34),
              ),
              const SizedBox(height: 14.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSubmitting.value ? null : onClose,
                      child: Text(context.l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: canConfirm
                          ? () async {
                              isSubmitting.value = true;
                              try {
                                await ref
                                    .read(
                                      aiChatRuntimeProvider(
                                        packageName: chatScopeId,
                                      ).notifier,
                                    )
                                    .createSession(controller.text.trim());
                                if (context.mounted) {
                                  onClose();
                                }
                              } finally {
                                if (context.mounted) {
                                  isSubmitting.value = false;
                                }
                              }
                            }
                          : null,
                      child: Text(context.l10n.confirm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 悬浮窗 AI 快捷设置面板。
///
/// 复用宿主同款 [AiQuickSettingsMenu]（模型选择 + 工具审批 + 工具管理），
/// 悬浮窗为独立引擎无法用 `showModalBottomSheet`，改用 [OverlayPanelDialog]
/// 以嵌入模式承载，保证与宿主行为一致。
class _AiOverlayQuickSettingsDialog extends ConsumerWidget {
  const _AiOverlayQuickSettingsDialog({
    required this.chatScopeId,
    required this.onClose,
  });

  final String chatScopeId;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OverlayPanelDialog.card(
      onClose: onClose,
      maxWidthPortrait: 380.0,
      maxWidthLandscape: 460.0,
      maxHeightPortrait: 520.0,
      maxHeightLandscape: 380.0,
      cardBorderRadius: 18.0,
      fillCardHeight: true,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          child: AiQuickSettingsMenu(
            packageName: chatScopeId,
            embedded: true,
          ),
        );
      },
    );
  }
}

class _AiOverlayInitBanner extends StatelessWidget {
  const _AiOverlayInitBanner({
    required this.chatState,
    required this.onRetry,
    this.isCompact = false,
  });

  final AiChatRuntimeState chatState;
  final Future<void> Function() onRetry;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (chatState.sessionInitState == AiSessionInitState.ready) {
      return const SizedBox.shrink();
    }

    final contentScale = AiChatCompactScope.scaleOf(context);
    final isInitializing =
        chatState.sessionInitState == AiSessionInitState.initializing;
    final backgroundColor = isInitializing
        ? context.colorScheme.primaryContainer.withValues(alpha: 0.78)
        : context.colorScheme.errorContainer.withValues(alpha: 0.84);
    final foregroundColor = isInitializing
        ? context.colorScheme.onPrimaryContainer
        : context.colorScheme.onErrorContainer;
    final message = isInitializing
        ? (context.isZh ? '正在准备当前进程的 AI 会话…' : 'Preparing AI session…')
        : (chatState.error ??
              (context.isZh ? '当前进程的 AI 会话初始化失败' : 'AI session init failed'));

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        (isCompact ? 4.0 : 6.0) * contentScale,
        0,
        (isCompact ? 4.0 : 6.0) * contentScale,
        (isCompact ? 6.0 : 8.0) * contentScale,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: (isCompact ? 10.0 : 12.0) * contentScale,
        vertical: (isCompact ? 8.0 : 10.0) * contentScale,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.0 * contentScale),
      ),
      child: Row(
        children: [
          Icon(
            isInitializing
                ? Icons.hourglass_top_rounded
                : Icons.error_outline_rounded,
            size: (isCompact ? 14.0 : 16.0) * contentScale,
            color: foregroundColor,
          ),
          SizedBox(width: (isCompact ? 6.0 : 8.0) * contentScale),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: (isCompact ? 10.0 : 11.5) * contentScale,
                color: foregroundColor,
              ),
            ),
          ),
          if (!isInitializing)
            TextButton(
              onPressed: () async {
                await onRetry();
              },
              child: Text(
                context.l10n.retry,
                style: TextStyle(color: foregroundColor),
              ),
            ),
        ],
      ),
    );
  }
}

class _AiOverlayDeleteSessionDialog extends StatelessWidget {
  const _AiOverlayDeleteSessionDialog({
    required this.sessionName,
    required this.onClose,
    required this.onConfirm,
  });

  final String sessionName;
  final VoidCallback onClose;
  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return OverlayPanelDialog.card(
      onClose: onClose,
      maxWidthPortrait: 320.0,
      maxWidthLandscape: 360.0,
      maxHeightPortrait: 220.0,
      maxHeightLandscape: 220.0,
      cardBorderRadius: 18.0,
      childBuilder: (context, viewport, layout) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.aiDeleteConfirmTitle,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                sessionName,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClose,
                      child: Text(context.l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colorScheme.error,
                        foregroundColor: context.colorScheme.onError,
                      ),
                      onPressed: onConfirm,
                      child: Text(context.l10n.delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AiOverlayQuoteBar extends StatelessWidget {
  const _AiOverlayQuoteBar({required this.excerpt, required this.onDismiss});

  final String excerpt;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    return Container(
      margin: EdgeInsets.fromLTRB(4 * scale, 4 * scale, 4 * scale, 0),
      padding: EdgeInsets.fromLTRB(10 * scale, 7 * scale, 2 * scale, 7 * scale),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 16 * scale,
            color: context.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 8 * scale),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.isZh ? '引用回复' : 'Quoting',
                  style: TextStyle(
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5 * scale,
                    height: 1.3,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            iconSize: 16 * scale,
            visualDensity: VisualDensity.compact,
            tooltip: context.isZh ? '取消引用' : 'Cancel quote',
            icon: Icon(
              Icons.close_rounded,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// 截取引用摘录：折叠空白、限制长度，避免超长消息撑爆输入框上方的卡片。
String _quoteExcerpt(String content, {int maxLength = 140}) {
  final normalized = content.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.length <= maxLength) {
    return normalized;
  }
  return '${normalized.substring(0, maxLength)}…';
}

/// 把被引用的消息以 markdown 引用块的形式拼到待发送文本前面。
String _composeQuotedText({
  required String rawText,
  required AiChatViewMessage? quoted,
}) {
  if (quoted == null) return rawText;
  final excerpt = _quoteExcerpt(quoted.content);
  final prefix = '> ${excerpt.replaceAll('\n', '\n> ')}';
  if (rawText.isEmpty) {
    return '$prefix\n\n';
  }
  return '$prefix\n\n$rawText';
}

/// 在悬浮窗 AI 面板里直接调整「当前模型是否支持图片输入」。
///
/// 能力只保存在模型目录的 [AiModelDefinition] 上；发图失败后再去别处翻设置
/// 太绕，所以这里把它摆在输入区上方，一眼可见、随手可改。
class _AiOverlayResizeBorderHighlightPainter extends CustomPainter {
  const _AiOverlayResizeBorderHighlightPainter({
    required this.color,
    required this.borderRadius,
    required this.clipExtent,
  });

  final Color color;
  final double borderRadius;
  final double clipExtent;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 2.2;
    const glowStrokeWidth = 4.2;
    final clipPadding = 6.0;
    final glowStroke = Paint()
      ..color = color.withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = glowStrokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.5);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final outerRRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    final glowRRect = outerRRect.deflate(glowStrokeWidth / 2);
    final rRect = outerRRect.deflate(strokeWidth / 2);

    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(
        size.width - clipExtent - clipPadding,
        size.height - clipExtent - clipPadding,
        clipExtent + clipPadding,
        clipExtent + clipPadding,
      ),
    );
    canvas.drawRRect(glowRRect, glowStroke);
    canvas.drawRRect(rRect, stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(
    covariant _AiOverlayResizeBorderHighlightPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.clipExtent != clipExtent;
  }
}
