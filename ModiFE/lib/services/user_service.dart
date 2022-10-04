// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modi/dialogs/ask_nickname/ask_nickname_dialog.dart';
import 'package:modi/dialogs/ask_password/ask_password_dialog.dart';
import 'package:modi/models/req/user_reqs.dart';
import 'package:modi/models/res/base_res.dart';
import 'package:modi/models/res/user_res.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/pages/home/home_page.dart';
import 'package:modi/pages/login/login_page.dart';
import 'package:modi/pages/tutorial/tutorial_page.dart';
import 'package:modi/services/analytics_service.dart';
import 'package:modi/services/http_service.dart';
import 'package:modi/services/message_service.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/notes_service.dart';
import 'package:modi/services/notification_service.dart';
import 'package:modi/utils/security.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserService {
  final HttpService _httpSvc = GetIt.I.get<HttpService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final MessageService _messageSvc = GetIt.I.get<MessageService>();
  final NotificationService _notificationSvc = GetIt.I.get<NotificationService>();
  final AnalyticsService _analyticsSvc = GetIt.I.get<AnalyticsService>();

  User? _user;

  bool get isLogged => _user != null;

  String? get userFirebaseEmail => _user?.email;
  bool get isFromSocial => _user?.providerData.first.providerId != "password";

  final ValueNotifier<ModiUser?> modiUser = ValueNotifier(null);

  Future<void> init() async {
    _user = FirebaseAuth.instance.currentUser;
    _httpSvc.setToken(await _user?.getIdToken());

    _registerForTokenChanges();
    if (_user != null) {
      await _loadModiUser();
    }
  }

  Future<bool> checkNickname(String nickname) async {
    final res = await _httpSvc.post<CheckNicknameRes?>(
      "/user/check-nickname", 
      CheckNicknameReq(nickname: nickname),
      serializer: (json) => CheckNicknameRes.fromJson(json)
    );

    if (res != null && res.isNotError) {
      return res.available;
    }

    return false;
  }

  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredetial = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _user = userCredetial.user;
      _httpSvc.setToken(await _user?.getIdToken());
      await _loadModiUser();
      _navigationSvc.pushReplacementNamed(HomePage.routePath);
      _analyticsSvc.I.logLogin(loginMethod: "EmailAndPassword");
      _notificationSvc.checkPermission();
    } on FirebaseAuthException catch (ex) {
      return tr("errors.${ex.code}");
    }
    return null;
  }

  Future<String?> signInAgainForEdit(String password) async {
    try {
      final userCredetial = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _user!.email!, password: password);
      _user = userCredetial.user;
      _httpSvc.setToken(await _user?.getIdToken());
    } on FirebaseAuthException catch (ex) {
      return tr("errors.${ex.code}");
    }
    return null;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  
      // Check user accept to login with Google
      if(googleUser == null || googleAuth == null) {
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await _handleUserCredential(userCredential);
      _analyticsSvc.I.logLogin(loginMethod: "Google");    
    } on FirebaseAuthException catch (ex) {
      return _messageSvc.showErrorDialog(tr("errors.${ex.code}"));
    } catch(error) {
      return _messageSvc.showErrorDialog(error.toString());
    }
  }

  Future<void> signInWithApple() async {
    try {
      final rawNonce = SecurityUtils.generateNonce();
      final nonce = SecurityUtils.sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      await _handleUserCredential(userCredential);
      _analyticsSvc.I.logLogin(loginMethod: "Apple");
    } on FirebaseAuthException catch (ex) {
      return _messageSvc.showErrorDialog(tr("errors.${ex.code}"));
    } on SignInWithAppleAuthorizationException  catch (ex) {
      if(ex.code != AuthorizationErrorCode.canceled) {
        return _messageSvc.showErrorDialog(ex.toString());
      }
    } catch(error) {
      return _messageSvc.showErrorDialog(error.toString());
    }
  }

  Future<String?> signUp(String nickname, String email, String password) async {
    try {
      final userCredetial = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredetial.user;
      _httpSvc.setToken(await _user?.getIdToken());

      final registerNicknameResult = await registerNickname(nickname);

      if (registerNicknameResult == null) {
        await _loadModiUser();
        _navigationSvc.pushReplacementNamed(TutorialPage.routePath);
        _analyticsSvc.I.logSignUp(signUpMethod: "EmailAndPassword");
      } else {
        return registerNicknameResult;
      }
    } on FirebaseAuthException catch (ex) {
      return tr("errors.${ex.code}");
    }
    return null;
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (ex) {
      return tr("errors.${ex.code}");
    }
    return null;
  }

  Future<void> logout() async {
    _messageSvc.showLoader();
    await _notificationSvc.removeCurrentToken();
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> updateNickname(String newNickname) async {
    final input = UpdateNicknameReq(
      nickname: newNickname
    );

    final BaseRes? res = await _httpSvc.put(
      "/user/update-nickname",
      input,
      serializer: (json) => BaseRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        _messageSvc.showSnackBar(type: MessageType.info, text: tr("editProfilePage.nicknameUpdated"));
        modiUser.value!.nickname = newNickname;
        modiUser.notifyListeners();
        return true;
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: res.message);
      }
    }

    return false;
  }

  Future<bool> updateEmail(String newEmail) async {
    try {
      await _user!.updateEmail(newEmail);
      modiUser.value!.email = newEmail;
      modiUser.notifyListeners();
      _messageSvc.showSnackBar(type: MessageType.info, text: tr("editProfilePage.emailUpdated"));
      return true;
    } on FirebaseAuthException catch (ex) {
      if(ex.code == "requires-recent-login") {
        final done = await AskPasswordDialog.show(_navigationSvc.currentContext);
        if(done == true) {
          return await updateEmail(newEmail);
        }
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: tr("errors.${ex.code}"));
      }
    }

    return false;
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      await _user!.updatePassword(newPassword);
      _messageSvc.showSnackBar(type: MessageType.info, text: tr("editProfilePage.passwordUpdated"));
      return true;
    } on FirebaseAuthException catch (ex) {
      if(ex.code == "requires-recent-login") {
        final done = await AskPasswordDialog.show(_navigationSvc.currentContext);
        if(done == true) {
          return await updatePassword(newPassword);
        }
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: tr("errors.${ex.code}"));
      }
    }

    return false;
  }

  Future<String?> registerNickname(String nickname) async {
    final res = await _httpSvc.post<BaseRes>(
      "/user/register", 
      RegisterUserReq(nickname: nickname),
      serializer: (json) => BaseRes.fromJson(json), 
      showError: false
    );

    if (res != null) {
      if (res.isError) {
        return res.message;
      }
    } else {
      return tr("errors.generic");
    }
    return null;
  }

  Future<List<PartnerRequestDetails>> getPartnerRequestNicknames() async {
    final res = await _httpSvc.get<GetPartnerRequestsRes>(
      "/user/get-partner-requests",
      serializer: (json) => GetPartnerRequestsRes.fromJson(json),
    );

    if(res != null) {
      if(res.isNotError) {
        return res.requests;
      } else {
        _messageSvc.showErrorDialog(tr("errors.${res.message}"));
      }
    }

    return [];
  }

  Future<String?> sendPartnerRequest(String partnerNickname) async {
    final res = await _httpSvc.post<BaseRes>(
      "/user/send-partner-request", 
      SendPartnerRequestReq(partnerNickname: partnerNickname),
      serializer: (json) => BaseRes.fromJson(json),
      showError: false
    );

    if (res != null) {
      if (res.isNotError) {
        _messageSvc.showSnackBar(
          type: MessageType.info,
          text: tr("userService.partnerRequestSent", args: [partnerNickname])
        );
      } else {
        return tr("errors.${res.message}", args: [partnerNickname]);
      }
    } else {
      return tr("errors.generic");
    }
    return null;
  }

  Future<void> acceptPartnerRequest(String partnerId) async {
    final res = await _httpSvc.post<BaseRes>(
      "/user/accept-partner-request", 
      AcceptPartnerRequestReq(partnerId: partnerId),
      serializer: (json) => BaseRes.fromJson(json),
    );

    if(res != null) {
      if(res.isNotError) {
        await _loadModiUser();
      } else {
        _messageSvc.showSnackBar(
          type: MessageType.error,
          text: tr("erros.${res.message}")
        );
      }
    }
  }

  Future<bool> rejectPartnerRequest(String partnerId) async {
    final res = await _httpSvc.post<BaseRes>(
      "/user/reject-partner-request", 
      RejectPartnerRequestReq(partnerId: partnerId),
      serializer: (json) => BaseRes.fromJson(json),
    );

    if(res != null) {
      if(res.isNotError) {
        return true;
      } else {
        _messageSvc.showSnackBar(
          type: MessageType.error,
          text: tr("erros.${res.message}")
        );
      }
    }

    return false;
  }

  Future<void> removePartner() async {
    final res = await _httpSvc.delete<BaseRes>(
      "/user/remove-partner",
      serializer: (json) => BaseRes.fromJson(json)
    );

    if (res != null) {
      if (res.isNotError) {
        final removedPartnerNickname = modiUser.value?.patnerNickname;
        await _loadModiUser();
        _messageSvc.showSnackBar(
          type: MessageType.info,
          text: tr("userService.partnerRemoved", args: [removedPartnerNickname ?? "ERROR"])
        );
      } else {
        if(res.message == "no-partner"){
          await _loadModiUser();
        } else {
          _messageSvc.showErrorDialog(res.message);
        }
      }
    }
  }

  Future<void> sendPartnerNotification() async {
    final res = await _httpSvc.get<BaseRes>(
      "/user/send-partner-notification",
      serializer: (json) => BaseRes.fromJson(json)
    );

    if(res != null) {
      if(res.isError) {
        _messageSvc.showErrorDialog(tr("errors.${res.message}"));
      } else {
        _messageSvc.showSnackBar(type: MessageType.info, text: tr("partnerPage.reminderSent"));
      }
    }
  }

  void updateTokens(int newValue) {
    modiUser.value!.tokens = newValue;
    modiUser.notifyListeners();
  }

  void updateCombo(int newValue) {
    modiUser.value!.combo = newValue;
    modiUser.notifyListeners();
  }

  Future<void> refreshToken() async {
    _httpSvc.setToken(await _user?.getIdToken());
    _loadModiUser();
  }

  Future<void> refreshModiUser() async {
    await _loadModiUser();
  }

  Future<void> _handleUserCredential(UserCredential userCredential) async {
    _user = userCredential.user;
    _httpSvc.setToken(await _user?.getIdToken());

    if(userCredential.additionalUserInfo!.isNewUser) {
      final nickname = await AskNicknameDialog.show(_navigationSvc.currentContext);
      // Check user close dimiss dialog
      if(nickname == null) {
        await userCredential.user?.delete();
        return;
      }
      final registerNicknameResult = await registerNickname(nickname);
      
      if (registerNicknameResult != null) {
        await userCredential.user?.delete();
        _messageSvc.showErrorDialog(registerNicknameResult);
      }
    }
  
    await _loadModiUser();
    if(userCredential.additionalUserInfo!.isNewUser) {
      _navigationSvc.pushReplacementNamed(TutorialPage.routePath);
    } else {
      _navigationSvc.pushReplacementNamed(HomePage.routePath);
    }
    _notificationSvc.checkPermission();
  }

  Future<void> _loadModiUser() async {
    final res = await _httpSvc.get<GetModiUserRes>(
      "/user/profile",
      serializer: (json) => GetModiUserRes.fromJson(json)
    );

    if (res != null) {
      modiUser.value = res.user;
    } else {
      logout();
    }
  }

  void _registerForTokenChanges() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
      _user = user;
      _httpSvc.setToken(await _user?.getIdToken());

      if(_user == null && modiUser.value != null) {
        _navigationSvc.pushNamedAndRemoveUntil(LoginPage.routePath);
        GetIt.I.resetLazySingleton<NotesService>();
        modiUser.value = null;
      }
    });
  }
}
