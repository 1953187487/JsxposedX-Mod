import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends HookWidget {
  final dynamic error;

  const ErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(context.l10n.error, style: context.textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(
                error is String
                    ? context.l10n.pageNotFound(error)
                    : error.toString(),
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => context.go(HomeRoute.home),
                icon: const Icon(Icons.home),
                label: Text(context.l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
