import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_passwordless/ui/utils/app_loader.dart';
import 'package:get/get.dart';

import 'data/services/auth/auth_service.dart';
import 'firebase_options.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Add services
  Get.put(AuthService());

  // Init services
  await AppLoader.init();
}
