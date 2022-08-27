import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_passwordless/ui/theme/theme.dart';
import 'package:get/get.dart';

import 'data/services/auth/auth_service.dart';
import 'init_app.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/sign_in/sign_in_screen.dart';

void main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: theme,
      home: auth.isAuthenticated ? const HomeScreen() : const SignInScreen(),
      builder: EasyLoading.init(),
    );
  }
}
