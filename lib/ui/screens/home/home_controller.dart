import 'package:flutter_passwordless/data/utils/methods.dart';
import 'package:flutter_passwordless/ui/utils/info_alert.dart';
import 'package:get/get.dart';

import '../../../data/services/auth/auth_service.dart';
import '../../../data/utils/app_logger.dart';
import '../../utils/app_loader.dart';
import '../sign_in/sign_in_screen.dart';

class HomeController extends GetxController {
  Future<void> signOut() async {
    try {
      AppLoader.show();
      await auth.signOut();
      Get.off(() => const SignInScreen());
    } catch (e, s) {
      logger.e('signOut', e, s);
      errorDialog(getExceptionMessage('Not able to Sign Out!', e, s));
    } finally {
      AppLoader.hide();
    }
  }
}
