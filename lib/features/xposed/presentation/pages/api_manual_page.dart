import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ApiManualPage extends HookWidget {
  const ApiManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isZh = context.isZh;
    final chaptersFuture = useMemoized(
      () => rootBundle
          .loadString(
            isZh
                ? 'assets/raws/JsxposedX_API.md'
                : 'assets/raws/JsxposedX_API_en.md',
          )
          .then(_parseChapters),
      [isZh],
    );
    final snapshot = useFuture(chaptersFuture);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JsxposedX API'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/aiApiManual/xposed'),
            icon: const Icon(Icons.auto_awesome),
            label: Text("AI"),
          ),
        ],
      ),
      body: switch (snapshot) {
        AsyncSnapshot(hasError: true) => Center(
          child: Text('${snapshot.error}'),
        ),
        AsyncSnapshot(hasData: true) => _ChapterListView(
          chapters: snapshot.data!,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

// ── Model ──

class _Chapter {
  final String title;
  final String subtitle;
  final String content;
  final IconData icon;

  const _Chapter({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.icon,
  });
}

// ── Parser ──

const _chapterIcons = [
  Icons.menu_book_rounded,
  Icons.api_rounded,
  Icons.auto_awesome_rounded,
  Icons.code_rounded,
];

List<_Chapter> _parseChapters(String md) {
  final h1Re = RegExp(r'^# (.+)$', multiLine: true);
  final matches = h1Re.allMatches(md).toList();
  if (matches.isEmpty) {
    return [
      _Chapter(
        title: 'JsXposed API',
        subtitle: '',
        content: md.trim(),
        icon: Icons.menu_book_rounded,
      ),
    ];
  }

  final chapters = <_Chapter>[];
  for (var i = 0; i < matches.length; i++) {
    final title = matches[i].group(1)!.trim();
    final start = matches[i].end;
    final end = i + 1 < matches.length ? matches[i + 1].start : md.length;
    final body = md.substring(start, end).trim();
    final lines = body.split('\n');
    final subtitle = lines
        .firstWhere(
          (l) => l.trim().isNotEmpty && !l.startsWith('---'),
          orElse: () => '',
        )
        .trim();

    chapters.add(
      _Chapter(
        title: title,
        subtitle: subtitle,
        content: body,
        icon: _chapterIcons[i % _chapterIcons.length],
      ),
    );
  }
  return chapters;
}

// ── Chapter List ──

class _ChapterListView extends StatelessWidget {
  final List<_Chapter> chapters;

  const _ChapterListView({required this.chapters});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: chapters.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, i) => _ChapterCard(chapter: chapters[i]),
    );
  }
}

// ── Chapter Card ──

class _ChapterCard extends StatelessWidget {
  final _Chapter chapter;

  const _ChapterCard({required this.chapter});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _ChapterDetailPage(chapter: chapter),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(chapter.icon, size: 28.sp, color: cs.primary),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chapter.title, style: context.textTheme.titleSmall),
                    if (chapter.subtitle.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        chapter.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Chapter Detail Page ──

class _ChapterDetailPage extends HookWidget {
  final _Chapter chapter;

  const _ChapterDetailPage({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chapter.title)),
      body: Markdown(
        data: chapter.content,
        selectable: true,
        padding: EdgeInsets.all(16.w),
        styleSheet: _mdStyle(context),
      ),
    );
  }
}

// ── Markdown Style ──

MarkdownStyleSheet _mdStyle(BuildContext context) {
  final cs = context.colorScheme;
  final tt = context.textTheme;
  return MarkdownStyleSheet.fromTheme(context.theme).copyWith(
    h2: tt.titleMedium?.copyWith(color: cs.primary),
    h3: tt.titleSmall?.copyWith(color: cs.secondary),
    p: tt.bodyMedium?.copyWith(height: 1.6),
    strong: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    code: TextStyle(
      fontSize: 12.sp,
      fontFamily: 'monospace',
      color: cs.tertiary,
      backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
    ),
    codeblockDecoration: BoxDecoration(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: cs.outlineVariant),
    ),
    codeblockPadding: EdgeInsets.all(12.w),
    listBullet: tt.bodyMedium,
    tableBorder: TableBorder.all(color: cs.outlineVariant, width: 0.5),
    tableHead: tt.bodySmall?.copyWith(fontWeight: FontWeight.bold),
    tableBody: tt.bodySmall,
    tableCellsPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(top: BorderSide(color: cs.outlineVariant)),
    ),
  );
}
