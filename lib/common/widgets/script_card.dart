import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:JsxposedX/features/home/domain/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScriptCard extends StatelessWidget {
  final Post post;

  const ScriptCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => context.push(HomeRoute.toScriptDetail(id: post.id)),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 8.5,
                  child: CacheImage(
                    imageUrl: post.cover,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.06),
                          Colors.black.withValues(alpha: 0.42),
                        ],
                      ),
                    ),
                  ),
                ),
                if (post.badges.isNotEmpty)
                  Positioned(
                    right: 14.w,
                    top: 14.h,
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      alignment: WrapAlignment.end,
                      children: post.badges
                          .take(3)
                          .map(
                            (badge) => _MetaChip(
                              icon: Icons.auto_awesome_rounded,
                              label: '#$badge',
                              backgroundColor: Colors.black.withValues(
                                alpha: 0.42,
                              ),
                              foregroundColor: Colors.white,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                Positioned(
                  left: 14.w,
                  right: 14.w,
                  bottom: 14.h,
                  child: Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.description.trim().isNotEmpty)
                    Text(
                      post.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  if (post.description.trim().isNotEmpty)
                    SizedBox(height: 14.h),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999.r),
                        child: CacheImage.profile(
                          imageUrl: post.uploader.avatarUrl,
                          size: 38.w,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    post.uploader.nickname,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (post.uploader.isVip) ...[
                                  SizedBox(width: 6.w),
                                  Icon(
                                    Icons.workspace_premium_rounded,
                                    size: 16.sp,
                                    color: Colors.amber[700],
                                  ),
                                ],
                                if (post.uploader.isCert) ...[
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 16.sp,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _formatPublishTime(post.publishTime),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Wrap(
                    spacing: 14.w,
                    runSpacing: 8.h,
                    children: [
                      _StatItem(
                        icon: Icons.thumb_up_alt_rounded,
                        value: _formatCount(post.postStats.likeCount),
                      ),
                      _StatItem(
                        icon: Icons.mode_comment_rounded,
                        value: _formatCount(post.postStats.commentCount),
                      ),
                      _StatItem(
                        icon: Icons.bookmark_rounded,
                        value: _formatCount(post.postStats.favoriteCount),
                      ),
                      _StatItem(
                        icon: Icons.share_rounded,
                        value: _formatCount(post.postStats.shareCount),
                      ),
                      _StatItem(
                        icon: Icons.redeem_rounded,
                        value: _formatCount(post.postStats.rewardCount),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPublishTime(int publishTime) {
    if (publishTime <= 0) return '--';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(publishTime);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  String _formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    }
    return value.toString();
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: foregroundColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;

  const _StatItem({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: colorScheme.onSurfaceVariant),
        SizedBox(width: 4.w),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
