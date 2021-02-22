#import "UmengAnalyticsSdkPlugin.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

@implementation UmengAnalyticsSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"xiamijun.com/umeng_analytics_sdk"
                                     binaryMessenger:[registrar messenger]];
    UmengAnalyticsSdkPlugin* instance = [[UmengAnalyticsSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        [self init:call result:result];
    } else if ([@"deviceIDForIntegration" isEqualToString:call.method]) {
        [self deviceIDForIntegration:call result:result];
    } else if ([@"onPageStart" isEqualToString:call.method]) {
        [self onPageStart:call result:result];
    } else if ([@"onPageEnd" isEqualToString:call.method]) {
        [self onPageEnd:call result:result];
    } else if ([@"logPage" isEqualToString:call.method]) {
        [self logPage:call result:result];
    } else if ([@"event" isEqualToString:call.method]) {
        [self event:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)init:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *appKey = args[@"iOSKey"];
    NSString *channel = args[@"channel"];
    BOOL logEnable = [args[@"logEnable"] boolValue];
    BOOL encryptEnable = [args[@"encryptEnable"] boolValue];
    BOOL autoPageEnable = [args[@"autoPageEnable"] boolValue];
    
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:logEnable];
    [UMConfigure setEncryptEnabled:encryptEnable];
    [MobClick setAutoPageEnabled:autoPageEnable];
    [UMConfigure initWithAppkey:appKey channel:channel];
    result(nil);
}

- (void)onPageStart:(FlutterMethodCall *)call result:(FlutterResult)result {
    [MobClick beginLogPageView:call.arguments];
    result(nil);
}

- (void)onPageEnd:(FlutterMethodCall *)call result:(FlutterResult)result {
    [MobClick endLogPageView:call.arguments];
    result(nil);
}

- (void)logPage:(FlutterMethodCall *)call result:(FlutterResult)result {
    [MobClick logPageView:call.arguments[@"pageName"] seconds:[call.arguments[@"seconds"] intValue]];
    result(nil);
}

- (void)event:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *eventId = args[@"eventId"];
    NSString *label = args[@"label"];
    NSDictionary *attributes = [args objectForKey:@"attributes"];
    int counter = 0;
    
    if ([args objectForKey:@"counter"] && ![[args objectForKey:@"counter"] isEqual:[NSNull null]]) {
        counter = [args[@"counter"] intValue];
    }
    
    if (attributes != nil && ![attributes isEqual:[NSNull null]]) {
        [MobClick event:eventId attributes:attributes counter:counter];
    } else {
        [MobClick event:eventId label:label];
    }
    result(nil);
}

- (void)deviceIDForIntegration:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *deviceId = [UMConfigure deviceIDForIntegration];
    NSString *deviceInfo = [NSString stringWithFormat:@"{\"oid\": \"%@\"}", deviceId];
    result(deviceInfo);
}

@end
