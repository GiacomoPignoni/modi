import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/error_dialog.dart';
import 'package:modi/dialogs/loading_dialog.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/widgets/visual/snack_bar.dart';

enum MessageType {
  info,
  success,
  error
}

class MessageService { 
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessangerKey = GlobalKey<ScaffoldMessengerState>();
  GlobalKey<ScaffoldMessengerState> get scaffoldMessangerKey => _scaffoldMessangerKey;

  bool _loaderVisible = false;

  void showErrorDialog(String text) {
    if(_navigationSvc.currentContext != null) {
      ErrorDialog.show(_navigationSvc.currentContext, text: text);
    }
  }

  void showSnackBar({
    required MessageType type,
    required String text
  }) {
    _scaffoldMessangerKey.currentState!.showSnackBar(SnackBarContent.snackBar(
      success: type == MessageType.success,
      text: text
    ));
  }

  Future<void> showLoader() async {
    if(_loaderVisible == false) {
      await LoadingDialog.show(_navigationSvc.currentContext);
      _loaderVisible = true;
    }
  }

  void hideLoader() {
    if(_loaderVisible) {
      _navigationSvc.pop();
      _loaderVisible = false;
    }
  }
}
