import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/pages/home/home_page.dart';
import 'package:modi/pages/login/login_page.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/widgets/visual/spinner.dart';

class InitialLoadingPage extends StatelessWidget {
  final NavigationService navigatorSvc = GetIt.I.get<NavigationService>();

  final Future<void> futureToAwait;
  final String nextRoute;

  InitialLoadingPage({
    required this.futureToAwait,
    required this.nextRoute,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    futureToAwait.then((value) {
      Navigator.of(context).pushReplacement(_createRoute());
    });

    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: TileMode.clamp,
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              theme.colorScheme.secondary,
              theme.colorScheme.primary
            ]
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SvgPicture.asset(
                "assets/svg/modi_logo.svg",
                height: 120,
              ),
            ),
            Spinner(color: theme.colorScheme.onPrimary)
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => (nextRoute == HomePage.routePath) ? const HomePage() : const LoginPage(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
