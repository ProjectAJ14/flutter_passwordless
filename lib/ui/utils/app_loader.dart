import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AppLoader {
  static Future<void> init() async {
    developer.log('AppLoader: init');
    EasyLoading.instance
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..dismissOnTap = false
      ..userInteractions = false
      ..maskType = EasyLoadingMaskType.clear
      ..backgroundColor = Colors.black54
      ..indicatorColor = Colors.white38
      ..textColor = Colors.white
      ..maskColor = Colors.white.withOpacity(0.5);

    EasyLoading.addStatusCallback((status) {
      developer.log('EasyLoading status[$status]');
    });
  }

  static Future<void> show({context, String? status}) async {
    developer.log('show[$context]');
    await EasyLoading.show(status: status ?? "");
  }

  static Future<void> hide({context}) async {
    developer.log('hide[$context]');
    await EasyLoading.dismiss();
  }
}
