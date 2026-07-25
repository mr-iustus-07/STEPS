import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class StepsApp extends ConsumerWidget {
  const StepsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'STEPS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.monochromeTheme,
      routerConfig: router,
    );
  }
}