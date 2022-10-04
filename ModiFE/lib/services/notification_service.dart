import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/base_information_dialog.dart';
import 'package:modi/dialogs/partner_request_dialog.dart';
import 'package:modi/models/remote_message_data.dart';
import 'package:modi/models/req/user_reqs.dart';
import 'package:modi/models/res/base_res.dart';
import 'package:modi/services/analytics_service.dart';
import 'package:modi/services/http_service.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

class NotificationService {
  final HttpService _httpSvc = GetIt.I.get<HttpService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final AnalyticsService _analyticsSvc = GetIt.I.get<AnalyticsService>();

  void init() {
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.onMessage.listen(_onNewFirebaseRemoteMessage);
  }

  Future<void> checkPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    final currentSettings = await messaging.getNotificationSettings();

    if(currentSettings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      debugPrint("FMC Token - $token");
      if(token != null) {
        _saveMessagingToken(token);
      }
    } else {
      _askPermission();
    }
  }

  Future<void> removeCurrentToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    final token = await messaging.getToken();
    if(token != null) {
      await _removeMessagingToken(token);
    }
  }

  Future<void> _askPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      if(token != null) {
        _saveMessagingToken(token);
      }
    }
  }

  Future<void> _saveMessagingToken(String token) async {
    final res = await _httpSvc.post(
      "/user/register-messaging-token",
      RegisterMessaginTokenReq(token: token),
      serializer: (json) => BaseRes.fromJson(json),
      showError: false,
    );

    // Only for debug
    if(res != null && res.isError) {
      debugPrint("SAVING MESSAGING TOKEN ERROR - ${res.message}");
    }
  }

  Future<void> _removeMessagingToken(String token) async {
    final res = await _httpSvc.delete(
      "/user/remove-messaging-token",
      body: RemoveMessaginTokenReq(token: token),
      serializer: (json) => BaseRes.fromJson(json),
      showError: false,
    );

    // Only for debug
    if(res != null && res.isError) {
      debugPrint("REMOVING MESSAGING TOKEN ERROR - ${res.message}");
    }
  }

  void _onNewFirebaseRemoteMessage(RemoteMessage message) {
    final messageData = RemoteMessageData.fromJson(message.data);

    switch(messageData.type) {
      case RemoteMessageType.other:
        _analyticsSvc.I.logEvent(name: AnalyticsEvent.otherMessage);
        break;
      case RemoteMessageType.partnerRequest:
        _handlePartnerRequestMessage(message.data);
        break;
      case RemoteMessageType.partnerReminder:
        _handlePartnerReminderMessage(message.data);
        break;
      case RemoteMessageType.partnerRemoved:
        _handlePartnerRemovedMessage(message.data);
        break;
      case RemoteMessageType.partnerAccepted:
        _handlePartnerAcceptedMessage(message.data);
        break;
    }
  }

  void _handlePartnerRequestMessage(Map<String, dynamic> data) {
    final partnerRequestData = PartnerRequestRemoteMessage.fromJson(data);

    _analyticsSvc.I.logEvent(name: AnalyticsEvent.partnerRequestMessage);
    PartnerRequestDialog.show(_navigationSvc.currentContext, partnerNickname: partnerRequestData.partnerNickname);
  }

  void _handlePartnerReminderMessage(Map<String, dynamic> data) {
    final partnerReminderData = PartnerRequestRemoteMessage.fromJson(data);

    _analyticsSvc.I.logEvent(name: AnalyticsEvent.partnerReminderMessage);
    BaseInformationDialog.show(
      _navigationSvc.currentContext,
      icon: Icons.people_alt_outlined,
      title: tr("partnerReminderDialog.title"),
      text: tr("partnerReminderDialog.text", args: [partnerReminderData.partnerNickname])
    );
  }

  void _handlePartnerRemovedMessage(Map<String, dynamic> data) {
    final UserService _userSvc = GetIt.I.get<UserService>();
    _analyticsSvc.I.logEvent(name: AnalyticsEvent.partnerReminderMessage);
    BaseInformationDialog.show(
      _navigationSvc.currentContext,
      icon: Icons.sentiment_dissatisfied_outlined,
      title: tr("partnerRemovedDialog.title"),
      text: tr("partnerRemovedDialog.text", args: [_userSvc.modiUser.value?.patnerNickname ?? "ERROR"])
    );
    _userSvc.refreshModiUser();
  }

  void _handlePartnerAcceptedMessage(Map<String, dynamic> data) {
    final UserService _userSvc = GetIt.I.get<UserService>();
    final partnerAcceptedData = PartnerAcceptedRemoteMessage.fromJson(data);

    _analyticsSvc.I.logEvent(name: AnalyticsEvent.partnerReminderMessage);
    _userSvc.refreshModiUser();
    BaseInformationDialog.show(
      _navigationSvc.currentContext,
      icon: Icons.mood_outlined,
      title: tr("partnerAcceptedDialog.title"),
      text: tr("partnerAcceptedDialog.text", args: [partnerAcceptedData.partnerNickname])
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // I don't know what to do here
  }
}
