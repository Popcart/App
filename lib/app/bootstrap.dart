import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/env/env.dart';
// ignore: depend_on_referenced_packages
import 'package:sprintf/sprintf.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(
    BlocBase<dynamic> bloc,
  ) {
    super.onCreate(bloc);
    log('${bloc.runtimeType} Created', name: 'onCreate<${bloc.runtimeType}>');
  }

  @override
  void onEvent(
    Bloc<dynamic, dynamic> bloc,
    Object? event,
  ) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType}, $event', name: 'onEvent<${bloc.runtimeType}>');
  }

  @override
  void onChange(
    BlocBase<dynamic> bloc,
    Change<dynamic> change,
  ) {
    super.onChange(bloc, change);
    log(
      sprintf('%s => %s', <String>[
        change.currentState.toString(),
        change.nextState.toString(),
      ]),
      name: 'onChange<${bloc.runtimeType}>',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log(
      sprintf('%s => %s', <String>[
        transition.currentState.toString(),
        transition.nextState.toString(),
      ]),
      name: 'onTransition<${bloc.runtimeType}>',
    );
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    super.onError(bloc, error, stackTrace);
    log(
      '${bloc.runtimeType}, $error, $stackTrace',
      name: 'onError<${bloc.runtimeType}>',
    );
  }
}

final notificationPlugin = FlutterLocalNotificationsPlugin();
const initializationSettings = InitializationSettings(
  android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  iOS: DarwinInitializationSettings(
    requestProvisionalPermission: true,
    requestCriticalPermission: true,
  ),
);
void onMessage(RemoteMessage message) {
  final id = (message.notification?.title?.length ?? 0) *
      (message.notification?.body?.length ?? 0);
  notificationPlugin.show(
    id,
    '${message.notification?.title}',
    '${message.notification?.body}',
    NotificationDetails(
      android: AndroidNotificationDetails(
        '${message.notification?.android?.channelId}',
        'Sendmonee',
      ),
      iOS: const DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.critical,
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        presentBanner: true,
      ),
    ),
  );
  log(message.toString(), name: 'onMessage');
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  final id = (message.notification?.title?.length ?? 0) *
      (message.notification?.body?.length ?? 0);
  await notificationPlugin.show(
    id,
    '${message.notification?.title}',
    '${message.notification?.body}',
    NotificationDetails(
      android: AndroidNotificationDetails(
        '${message.notification?.android?.channelId}',
        'Sendmonee',
        importance: Importance.high,
        priority: Priority.high,
        fullScreenIntent: true,
      ),
      iOS: const DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.critical,
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        presentBanner: true,
      ),
    ),
  );
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required AppEnvironment environment,
}) async {
  try {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    await setupLocator(environment: environment);
    await locator.get<SharedPrefs>().init();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    FlutterError.onError = (details) {
      log(
        details.exceptionAsString(),
        stackTrace: details.stack,
        name: details.exception.runtimeType.toString(),
      );
    };
    if (kDebugMode) {
      Bloc.observer = AppBlocObserver();
    }
    await notificationPlugin.initialize(initializationSettings);
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  
    await FirebaseMessaging.instance.requestPermission(provisional: true);
    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    // await PrivacyScreen.instance.enable(
    //   iosOptions: const PrivacyIosOptions(
    //     privacyImageName: 'LaunchImage',
    //     autoLockAfterSeconds: 5,
    //   ),
    //   androidOptions: const PrivacyAndroidOptions(
    //     autoLockAfterSeconds: 5,
    //   ),
    //   backgroundColor: Colors.white.withOpacity(0),
    // );
    final isFirstTime = locator.get<SharedPrefs>().firstTime;
    if (isFirstTime == null) {
      await downloadSplashFromServer();
      locator.get<SharedPrefs>().firstTime = false;
    }
    runApp(await builder());
  } catch (e, s) {
    
    await FirebaseCrashlytics.instance.recordError(e, s, fatal: true);
  }
  FlutterNativeSplash.remove();
}

Future<bool> downloadSplashFromServer() async {
  print('Downloading splash from server');
  final splashUrl = Env().introGifUrl;
  final savePath = await getTemporaryDirectory();
  final filePath = '${savePath.path}/splash.gif';
  final fileExists = File(filePath).existsSync();
  if (!fileExists) {
    final response = await Dio().download(splashUrl, filePath);
    if (response.statusCode == 200) {
      return true;
    }
  } else {
    return false;
  }
  return true;
}
