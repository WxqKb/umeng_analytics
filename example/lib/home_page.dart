import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/get_device_info');
              },
              child: Text('获取集成测试的设备信息'),
            ),
          ],
        ),
      ),
    );
  }
}
