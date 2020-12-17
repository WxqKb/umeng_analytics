package com.xiamijun.umeng_analytics_sdk;

import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** UmengAnalyticsSdkPlugin */
public class UmengAnalyticsSdkPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "xiamijun.com/umeng_analytics_sdk");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
      init(call, result);
    } else if (call.method.equals("deviceIDForIntegration")) {
      deviceIDForIntegration(call, result);
    } else if (call.method.equals("onPageStart")) {
      onPageStart(call, result);
    } else if (call.method.equals("onPageEnd")) {
      onPageEnd(call, result);
    } else if (call.method.equals("logPage")) {
      logPage(call, result);
    } else if (call.method.equals("event")) {
      event(call, result);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void init(MethodCall call, Result result) {
    String appKey = call.argument("androidKey");
    String channel = call.argument("channel");
    boolean logEnable = call.argument("logEnable");
    boolean encryptEnable = call.argument("encryptEnable");
//    boolean autoPageEnable = call.argument("autoPageEnable");

    UMConfigure.setEncryptEnabled(encryptEnable);

    UMConfigure.setLogEnabled(logEnable);
    UMConfigure.init(context, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE, null);

    // 在Android 4.0以上设备中，推荐使用系统自动监控机制
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);
    } else {
      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.MANUAL);
    }
    result.success(null);
  }

  private void onPageStart(MethodCall call, Result result) {
    MobclickAgent.onPageStart((String) call.arguments);
    result.success(null);
  }

  private void onPageEnd(MethodCall call, Result result) {
    MobclickAgent.onPageEnd((String) call.arguments);

    result.success(null);
  }

  private void logPage(MethodCall call, Result result) {
    // Android平台SDK暂未提供此接口
    result.success(null);
  }

  private void event(MethodCall call, Result result) {
    MobclickAgent.onEventObject(context, (String) call.argument("eventId"), (Map) call.argument("attributes"));
    result.success(null);
  }

  private void deviceIDForIntegration(MethodCall call, Result result) {
    String[] deviceInfo = UMConfigure.getTestDeviceInfo(context);
    String str = "{\"device_id\":" + "\"" + deviceInfo[0] + "\"" + "," + "\"mac\":" + "\"" + deviceInfo[1] + "\"" + "}";

    result.success(str);
  }
}
