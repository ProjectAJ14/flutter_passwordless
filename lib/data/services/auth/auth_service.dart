import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

import '../../models/app_response.dart';

AuthService get auth => Get.find<AuthService>();

class AuthService {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  String get userName =>
      isAuthenticated ? _firebaseAuth.currentUser!.email ?? '' : '';

  Future<AppResponse> sendEmailLink({
    required String email,
  }) async {
    try {
      final actionCodeSettings = firebase_auth.ActionCodeSettings(
        url:
            'https://flutterpasswordles001.page.link/passwordless-001?email=$email',
        handleCodeInApp: true,
        androidPackageName: 'com.nonstopio.flutter_passwordless',
        iOSBundleId: 'com.nonstopio.flutterPasswordless',
      );
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      return AppResponse.success(
        message: 'Email link sent successfully',
      );
    } catch (e, s) {
      return AppResponse.error(
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
      PendingDynamicLinkData? dynamicLinkData;

      if (fromColdState) {
        dynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
      } else {
        dynamicLinkData = await FirebaseDynamicLinks.instance.onLink.first;
      }

      if (dynamicLinkData == null) {
        return AppResponse.notFound(
          message: 'No credentials were found',
        );
      }
      bool validLink =
          _firebaseAuth.isSignInWithEmailLink(dynamicLinkData.link.toString());
      if (validLink) {
        // Get the user's email address from the continueUrl
        final continueUrl =
            dynamicLinkData.link.queryParameters['continueUrl'] ?? "";
        final email = Uri.parse(continueUrl).queryParameters['email'] ?? "";
        final firebase_auth.UserCredential userCredential =
            await _firebaseAuth.signInWithEmailLink(
          email: email,
          emailLink: dynamicLinkData.link.toString(),
        );
        if (userCredential.user != null) {
          return AppResponse.success(
            message: 'Signed in successfully',
          );
        } else {
          return AppResponse.notFound(
            message: 'Not able to sign in',
          );
        }
      } else {
        return AppResponse.notFound(
          message: 'Link is not valid',
        );
      }
    } catch (e, s) {
      return AppResponse.error(
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
