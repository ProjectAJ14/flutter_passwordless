import 'package:flutter/material.dart';
import 'package:flutter_passwordless/ui/theme/theme.dart';

import 'ui/screens/sign_in/sign_in_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const SignInScreen(),
    );
  }
}
