import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';

import 'app_logger.dart';

String getExceptionMessage(
  String? message, [
  dynamic error,
  StackTrace? stackTrace,
]) {
  String finalMessage = message ?? 'Something went wrong!';

  if (error != null) {
    ///LOG THE ERROR
    logger.e(
      'ERROR [${error?.runtimeType}]',
      error,
      stackTrace,
    );
    if (error is PlatformException) {
      if (error.message != null) {
        finalMessage = error.message!;
      }
    } else if (error is firebase_auth.FirebaseAuthException) {
      if (error.code != 'unknown' && error.message != null) {
        finalMessage = error.message!;
      }
    } else if (error is firebase_auth.FirebaseException) {
      if (error.code != 'unknown' && error.message != null) {
        finalMessage = error.message!;
      }
    }
  }

  return finalMessage;
}
