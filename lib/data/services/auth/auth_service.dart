import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_passwordless/data/services/auth/sp_service.dart';
import 'package:flutter_passwordless/ui/screens/sign_in/sign_in_screen.dart';
import 'package:flutter_passwordless/ui/utils/app_loader.dart';
import 'package:get/get.dart';

import '../../models/app_response.dart';

const noCredentialsWereFound = 'No credentials were found';

AuthService get auth => Get.find<AuthService>();

class AuthService {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  String get userName =>
      isAuthenticated ? _firebaseAuth.currentUser!.email ?? '' : '';

  Future<AppResponse> sendEmailLink({
    required String email,
  }) async {
    developer.log('sendEmailLink[$email]');
    try {
      final actionCodeSettings = firebase_auth.ActionCodeSettings(
        url: 'https://flutterpasswordles001.page.link/passwordless-001',
        handleCodeInApp: true,
        androidPackageName: 'com.nonstopio.flutter_passwordless',
        iOSBundleId: 'com.nonstopio.flutter_passwordless',
      );
      developer.log('actionCodeSettings[${actionCodeSettings.asMap()}]');
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        developer.log('onLink[${dynamicLinkData.link}]');
      }).onError((error) {
        developer.log('onLink.onError[$error]');
      });
      SPService.instance.setString('passwordLessEmail', email);
      return AppResponse.success(
        id: 'sendEmailLink',
      );
    } catch (e, s) {
      return AppResponse.error(
        id: 'sendEmailLink',
        error: e,
        stackTrace: s,
      );
    }
  }

  /// Cold state means the app was terminated.
  Future<AppResponse> retrieveDynamicLinkAndSignIn({
    required bool fromColdState,
  }) async {
    try {
      String email = SPService.instance.getString('passwordLessEmail') ?? '';
      developer.log('retrieveDynamicLinkAndSignIn[$email]');
      if (email.isEmpty) {
        developer.log('retrieveDynamicLinkAndSignIn email is empty');
        return AppResponse.notFound(
          id: 'retrieveDynamicLinkAndSignIn',
          message: noCredentialsWereFound,
        );
      }

      PendingDynamicLinkData? dynamicLinkData;

      Uri? deepLink;
      if (fromColdState) {
        dynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
        if (dynamicLinkData != null) {
          deepLink = dynamicLinkData.link;
        }
      } else {
        dynamicLinkData = await FirebaseDynamicLinks.instance.onLink.first;
        deepLink = dynamicLinkData.link;
      }

      developer.log('deepLink => $deepLink');
      if (deepLink != null) {
        bool validLink =
            _firebaseAuth.isSignInWithEmailLink(deepLink.toString());

        /// Password- less hack for IOS
        if (!validLink && Platform.isIOS) {
          developer.log('Password- less hack for IOS deepLink is not valid');
          ClipboardData? data = await Clipboard.getData('text/plain');
          if (data != null) {
            developer.log('Get link from Clipboard => ${data.text}');
            final linkData = data.text ?? '';
            final link = Uri.parse(linkData).queryParameters['link'] ?? "";
            developer.log(
              'Parsed Link => $link',
            );
            validLink = _firebaseAuth.isSignInWithEmailLink(link);
            if (validLink) {
              deepLink = Uri.parse(link);
            }
          }
        }

        /// End - Password- less hack for IOS

        SPService.instance.setString('passwordLessEmail', '');
        if (validLink) {
          final firebase_auth.UserCredential userCredential =
              await _firebaseAuth.signInWithEmailLink(
            email: email,
            emailLink: deepLink.toString(),
          );
          if (userCredential.user != null) {
            return AppResponse.success(
              id: 'retrieveDynamicLinkAndSignIn',
            );
          } else {
            developer.log('userCredential.user is [${userCredential.user}]');
          }
        } else {
          developer.log('Link is not valid');
          return AppResponse.error(
            id: 'retrieveDynamicLinkAndSignIn',
            message: noCredentialsWereFound,
          );
        }
      } else {
        developer.log('retrieveDynamicLinkAndSignIn.deepLink[$deepLink]');
      }
    } catch (e, s) {
      return AppResponse.error(
        id: 'retrieveDynamicLinkAndSignIn',
        error: e,
        stackTrace: s,
      );
    }
    return AppResponse.notFound(
      id: 'retrieveDynamicLinkAndSignIn',
      message: noCredentialsWereFound,
    );
  }

  Future<void> signOut() async {
    try {
      AppLoader.show();
      await _firebaseAuth.signOut();
      Get.offAll(() => const SignInScreen());
    } catch (error, stackTrace) {
      developer.log(
        'signOut',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      AppLoader.hide();
    }
  }
}
