import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/user_service.dart';

class LifeCycle extends StatefulWidget {
  final Widget child;

  const LifeCycle({
    required this.child,
    Key? key
  }) : super(key: key);

  @override
  State<LifeCycle> createState() => _LifeCycleState();
}

class _LifeCycleState extends State<LifeCycle> with WidgetsBindingObserver {
  final UserService _userSvc = GetIt.I.get<UserService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed && _userSvc.isLogged) {
      _userSvc.refreshToken();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
