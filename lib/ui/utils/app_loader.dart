import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../data/utils/app_logger.dart';

class AppLoader {
  static Future<void> init() async {
    logger.d('AppLoader: init');
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
      logger.d('EasyLoading status[$status]');
    });
  }

  static Future<void> show({context, String? status}) async {
    logger.d('show[$context]');
    await EasyLoading.show(status: status ?? "");
  }

  static Future<void> hide({context}) async {
    logger.d('hide[$context]');
    await EasyLoading.dismiss();
  }
}
