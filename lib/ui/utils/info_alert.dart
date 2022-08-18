import 'package:flutter/material.dart';
import 'package:get/get.dart';

infoDialog({
  required String title,
  required String message,
  Function()? onPressed,
  bool isLightTheme = false,
}) {
  return Get.dialog(
    AlertDialog(
      title: Text(
        title,
        style: isLightTheme
            ? Get.theme.textTheme.headline5
            : Get.theme.primaryTextTheme.headline5,
      ),
      content: Text(
        message,
        style: isLightTheme
            ? Get.theme.textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w400,
              )
            : Get.theme.primaryTextTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w400,
              ),
      ),
      actions: [
        TextButton(
          onPressed: onPressed ?? Get.back,
          child: const Text('OK'),
        ),
      ],
      backgroundColor:
          isLightTheme ? Get.theme.highlightColor : Get.theme.backgroundColor,
    ),
  );
}

errorDialog(String message) {
  infoDialog(
    title: 'ERROR',
    message: message,
  );
}
