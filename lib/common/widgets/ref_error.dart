import 'package:JsxposedX/core/constants/app_constants.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RefError extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;
  final Object? error; // 可选：显示具体错误
  final Widget? child;

  const RefError({
    super.key,
    required this.onRetry,
    this.child,
    this.message,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: AppConstants.spacingMD),
          Text("邮箱:muxuepro@gmail.com"),
          Text(message ?? context.l10n.loadFailedMessage),
          if (error != null) ...[
            const SizedBox(height: AppConstants.spacingSM),
            Text(
              error.toString(),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          const SizedBox(height: AppConstants.spacingMD),
          ElevatedButton(onPressed: onRetry, child: Text(context.l10n.retry)),
          if (child != null) ...[
            const SizedBox(height: AppConstants.spacingMD),
            child!,
          ],
          const SizedBox(height: AppConstants.spacingMD),
          ElevatedButton(
            onPressed: () {
              context.go(HomeRoute.home);
            },
            child: Text(context.l10n.home),
          ),
        ],
      ),
    );
  }
}
