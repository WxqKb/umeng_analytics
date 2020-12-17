import 'package:flutter/material.dart';
import 'package:umeng_analytics_sdk/umeng_analytics_sdk.dart';

class GetDeviceInfoPage extends StatefulWidget {
  @override
  _GetDeviceInfoPageState createState() => _GetDeviceInfoPageState();
}

class _GetDeviceInfoPageState extends State<GetDeviceInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('获取集成测试的设备信息')),
      body: Center(
        child: FutureBuilder(
          future: UmengAnalytics.deviceIDForIntegration(),
          builder: (context, snapshot) {
            String info = '';
            if (snapshot.hasData) {
              info = snapshot.data;
              print('======device info:${snapshot.data}');
            }
            return Text(info);
          },
        ),
      ),
    );
  }
}
