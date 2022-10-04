import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:modi/models/config.dart';

class ConfigService {
  static const String _baseUrlKey = "BASE_URL";

  final LocalConfig _localConfig;

  final RemoteConfig _remoteConfig = RemoteConfig.instance;

  ConfigService(this._localConfig);

  String get baseUrl {  
    return RemoteConfig.instance.getString(_baseUrlKey);
  }

  Env get env {
    return _localConfig.env;
  }

  String get fullPageAdIdiOS {
    return _localConfig.fullPageAdIdiOS;
  }

  String get fullPageAdIdAndroid{
    return _localConfig.fullPageAdIdAndroid;
  }

  String get bannerAdIdiOS {
    return _localConfig.bannerAdIdiOS;
  }

  String get bannerAdIdAndroid{
    return _localConfig.bannerAdIdAndroid;
  }

  Future<void> init() async {
    await _remoteConfig.setDefaults(<String, dynamic>{
      _baseUrlKey: ""
    });
    await _remoteConfig.fetchAndActivate();
  }
}
