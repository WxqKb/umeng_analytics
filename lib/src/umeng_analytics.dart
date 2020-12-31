import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UmengAnalytics {
  static const MethodChannel _channel =
      const MethodChannel('xiamijun.com/umeng_analytics_sdk');

  /// 初始化组件
  ///
  /// [channel] 渠道标识，可设置为null表示'App Store'。
  /// [logEnable] 设置是否在console输出SDK的log信息。默认false，不输出log；设置为true，输出可供调试参考的log信息。发布产品时必须设置为false。
  /// [encryptEnable] 设置是否对统计信息进行加密传输。默认为false，设置为true，SDK会将日志信息做加密处理。
  /// [autoPageEnable] 设置页面统计采集方式。默认为false（手动模式）。
  static Future<void> init({
    @required String iOSKey,
    @required String androidKey,
    String channel,
    bool logEnable = false,
    bool encryptEnable = false,
    bool autoPageEnable = false,
  }) async {
    assert(iOSKey != null);
    assert(androidKey != null);
    assert(logEnable != null);
    assert(encryptEnable != null);
    assert(autoPageEnable != null);

    final Map<String, dynamic> params = {
      'iOSKey': iOSKey,
      'androidKey': androidKey,
      'channel': channel,
      'logEnable': logEnable,
      'encryptEnable': encryptEnable,
      'autoPageEnable': autoPageEnable,
    };

    return _channel.invokeMethod<void>('init', params);
  }

  /// 获取集成测试需要的device_id
  static Future<String> deviceIDForIntegration() async {
    return _channel.invokeMethod<String>('deviceIDForIntegration');
  }

  /// 页面统计
  ///
  /// 在页面展示时调用该方法
  static Future<void> onPageStart(String pageName) async {
    assert(pageName != null);
    return _channel.invokeMethod<void>('onPageStart', pageName);
  }

  /// 页面统计
  ///
  /// 在页面退出时调用该方法
  static Future<void> onPageEnd(String pageName) async {
    assert(pageName != null);
    return _channel.invokeMethod<void>('onPageEnd', pageName);
  }

  /// 页面统计
  ///
  /// [pageName] 统计的页面名称
  /// [seconds] 时长，单位为秒
  static Future<void> logPage(String pageName, int seconds) async {
    assert(pageName != null);
    assert(seconds != null);

    final params = <String, dynamic>{
      'pageName': pageName,
      'seconds': seconds ?? 0,
    };
    return _channel.invokeMethod<void>('logPage', params);
  }

  /// 事件统计功能
  ///
  /// [eventId] 网站上注册的事件id
  /// [label] 分类标签
  /// [attributes] 自定义属性
  /// [counter] 自定义数值
  static Future<void> event(
    String eventId, {
    String label,
    Map attributes,
    int counter = 0,
  }) async {
    assert(eventId != null);
    final params = <String, dynamic>{
      'eventId': eventId,
      'label': label,
      'attributes': attributes,
      'counter': counter,
    };
    return _channel.invokeMethod<void>('event', params);
  }
}
