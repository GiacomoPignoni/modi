enum Env {
  dev,
  prod
}

class LocalConfig {
  final Env env;
  final String fullPageAdIdiOS;
  final String fullPageAdIdAndroid;
  final String bannerAdIdiOS;
  final String bannerAdIdAndroid;

  LocalConfig({
    required this.env,
    required this.fullPageAdIdiOS,
    required this.fullPageAdIdAndroid,
    required this.bannerAdIdiOS,
    required this.bannerAdIdAndroid
  });
}
