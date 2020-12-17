import 'package:flutter/cupertino.dart';
import 'package:umeng_analytics_sdk/umeng_analytics_sdk.dart';

class AppAnalyticsObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute?.settings?.name != null) {
      UmengAnalytics.onPageEnd(previousRoute.settings.name);
    }

    if (route.settings.name != null) {
      UmengAnalytics.onPageStart(route.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route.settings.name != null) {
      UmengAnalytics.onPageEnd(route.settings.name);
    }

    if (previousRoute.settings.name != null) {
      UmengAnalytics.onPageStart(previousRoute.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if (oldRoute.settings.name != null) {
      UmengAnalytics.onPageEnd(oldRoute.settings.name);
    }

    if (newRoute.settings.name != null) {
      UmengAnalytics.onPageStart(newRoute.settings.name);
    }
  }
}
