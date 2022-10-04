import 'package:modi/app.dart';
import 'package:modi/models/config.dart';

void main() {
  startApp(
    LocalConfig(
      env: Env.prod,
      fullPageAdIdiOS: "",
      fullPageAdIdAndroid: "",
      bannerAdIdiOS: "",
      bannerAdIdAndroid: ""
    )
  );
}
