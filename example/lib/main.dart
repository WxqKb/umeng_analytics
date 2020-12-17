import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umeng_analytics_sdk/umeng_analytics_sdk.dart';

import 'app_analytics_observer.dart';
import 'get_device_info_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    UmengAnalytics.init(
      iOSKey: 'your iOS app key',
      androidKey: 'your Android app key',
      logEnable: kDebugMode,
      autoPageEnable: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [AppAnalyticsObserver()],
      routes: {
        '/': (_) => HomePage(),
        '/get_device_info': (_) => GetDeviceInfoPage(),
      },
    );
  }
}
