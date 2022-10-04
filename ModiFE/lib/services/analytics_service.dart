import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();

  FirebaseAnalytics get I => _firebaseAnalytics;
}

class AnalyticsEvent {
  static const String otherMessage = "Other_Message";
  static const String partnerRequestMessage = "Partner_Request_Message";
  static const String partnerReminderMessage = "Partner_Reminder_Message";
  static const String partnerRemovedMessage = "Partner_Removed_Message";
  static const String partnerAcceptedMessage = "Partner_Accepted_Message";
  static const String failedToLoadAd = "Failed_To_Load_Ad";
  static const String adImpression = "Ad_Impression";
}
