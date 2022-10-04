import 'package:url_launcher/url_launcher.dart';

class WebUtils {
  static void openPrivacyPolicy() {
    launchUrl(Uri.dataFromString("https://modi-app.online/privacy-policy"));
  }

  static void openTermsAndConditions() {
    launchUrl(Uri.dataFromString("https://modi-app.online/terms-and-conditions"));
  }
}
