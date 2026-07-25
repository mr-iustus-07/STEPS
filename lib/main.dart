import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/database_service.dart';
import 'core/services/notification_service.dart';

void main() {
  runZonedGuarded(() async {
    // 1. Initialize Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Boot Core Services (Database & Notifications)
    await DatabaseService.init();
    await NotificationService.init();

    // 3. Catch Flutter UI errors
    FlutterError.onError = (FlutterErrorDetails details) {
      log('Flutter UI Error: ${details.exceptionAsString()}', stackTrace: details.stack);
      if (!kReleaseMode) FlutterError.presentError(details);
    };

    // 4. Catch asynchronous Dart errors
    PlatformDispatcher.instance.onError = (error, stack) {
      log('Dart Async Error: $error', stackTrace: stack);
      return true;
    };

    // 5. Run the App
    runApp(
      const ProviderScope(
        child: StepsApp(),
      ),
    );
  }, (error, stack) {
    log('Fatal Boot Error: $error', stackTrace: stack);
  });
}