import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

enum ResetPasswordStep { 
  emailInput,
  emailSent 
}

class ResetPasswordPageController {
  final UserService _userSvc = GetIt.I.get<UserService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  final PageController pageCtrl = PageController(initialPage: 0);
  final TextEditingController emailCtrl = TextEditingController();

  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<String?> errorStr = ValueNotifier(null);

  final PictureProvider emailSvgProvider = ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, "assets/svg/mail.svg");

  ResetPasswordPageController() {
    precachePicture(
      emailSvgProvider,
      null,
    );
  }

  Future<void> sendPasswordResetEmail() async {
    if(emailCtrl.text.isNotEmpty) {
      loading.value = true;
      errorStr.value = null;

      final res = await _userSvc.sendPasswordResetEmail(emailCtrl.text);
      if (res == null) {
        pageCtrl.jumpToPage(ResetPasswordStep.emailSent.index);
      } else {
        errorStr.value = res;
      }

      loading.value = false;
    }
  }

  void goBack() {
    _navigationSvc.pop();
  }

  void goToEmailInputStep() {
    pageCtrl.jumpToPage(ResetPasswordStep.emailInput.index);
    emailCtrl.clear();
  }

  void dispose() {
    pageCtrl.dispose();
    emailCtrl.dispose();
    loading.dispose();
    errorStr.dispose();
  }
}
