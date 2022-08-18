import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';

String getExceptionMessage(
  String id, {
  String? message,
  dynamic error,
  StackTrace? stackTrace,
}) {
  String finalMessage = message ?? 'Something went wrong!';

  if (error != null) {
    ///LOG THE ERROR
    developer.log(
      'ERROR[$id][${error?.runtimeType}]',
      error: error,
      stackTrace: stackTrace,
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
