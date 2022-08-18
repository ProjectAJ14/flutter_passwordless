import 'dart:developer' as developer;

import 'package:flutter/material.dart';

class ValidatorUtil {
  ValidatorUtil._();

  static bool isFormValid(GlobalKey<FormState>? formKey) {
    try {
      final FormState? form = formKey?.currentState;
      if (form != null) {
        if (form.validate()) {
          form.save();
          return true;
        }
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      developer.log(
        '$formKey isFormValid',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return false;
  }

  static String? validateEmail(
    String value, {
    String? errorMessage,
  }) {
    const String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    if (value.trim().isEmpty) return 'Enter email';

    if (hasMatch(pattern: emailPattern, value: value)) return null;

    return errorMessage ?? 'Enter valid email';
  }

  static bool hasMatch({
    required String pattern,
    required String value,
  }) =>
      RegExp(pattern).hasMatch(value);
}
