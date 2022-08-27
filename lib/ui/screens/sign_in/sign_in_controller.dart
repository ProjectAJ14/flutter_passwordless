import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_passwordless/ui/screens/home/home_screen.dart';
import 'package:get/get.dart';

import '../../../data/models/app_response.dart';
import '../../../data/services/auth/auth_service.dart';
import '../../../data/utils/app_logger.dart';
import '../../../data/utils/validators.dart';
import '../../utils/app_loader.dart';
import '../../utils/info_alert.dart';

class SignInController extends GetxController with WidgetsBindingObserver {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailTEC = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void onReady() {
    super.onReady();
    retrieveDynamicLinkAndSignIn(fromColdState: true);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      logger.d('onLink[${dynamicLinkData.link}]');
    }).onError((error) {
      logger.e('onLink.onError', error);
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    focusNode.dispose();
    emailTEC.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        logger.d('SignInController: resumed');
        retrieveDynamicLinkAndSignIn(fromColdState: false);
        break;
      case AppLifecycleState.inactive:
        logger.d('SignInController: inactive');
        break;
      case AppLifecycleState.paused:
        logger.d('SignInController: paused');
        break;
      case AppLifecycleState.detached:
        logger.d('SignInController: detached');
        break;
    }
  }

  Future<void> signInWithEmailLink() async {
    try {
      AppLoader.show();
      if (ValidatorUtil.isFormValid(formKey)) {
        AppResponse appResponse = await auth.sendEmailLink(
          email: emailTEC.text.trim(),
        );
        if (appResponse.isSuccess) {
          infoDialog(
            title: 'Email Link Sent',
            message: 'Passwordless sign-in link sent!\n'
                'Please check your inbox to complete sign in',
          );
        } else {
          errorDialog(appResponse.message);
        }
      } else {
        errorDialog('Please enter required details');
      }
    } catch (e, s) {
      logger.d('signInWithEmailLink', e, s);
    } finally {
      AppLoader.hide();
    }
  }

  Future<void> retrieveDynamicLinkAndSignIn({
    required bool fromColdState,
  }) async {
    try {
      logger.d('retrieveDynamicLinkAndSignIn');
      AppResponse appResponse = await auth.retrieveDynamicLinkAndSignIn(
        fromColdState: fromColdState,
      );
      if (appResponse.isNotFound) {
        logger.d('retrieveDynamicLinkAndSignIn: not found');
      } else if (appResponse.isSuccess) {
        Get.off(() => const HomeScreen());
      } else {
        errorDialog(appResponse.message);
      }
    } catch (e, s) {
      logger.d('retrieveDynamicLinkAndSignIn', e, s);
    }
  }
}
