import 'package:flutter/material.dart';
import 'package:modi/pages/tutorial/tutorial_page_button_row.dart';
import 'package:modi/pages/tutorial/tutorial_page_controller.dart';
import 'package:modi/pages/tutorial/tutorial_page_first.dart';
import 'package:modi/pages/tutorial/tutorial_page_fourth.dart';
import 'package:modi/pages/tutorial/tutorial_page_second.dart';
import 'package:modi/pages/tutorial/tutorial_page_thirt.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/visual/logo_header.dart';

class TutorialPage extends StatelessWidget {
  static const String routePath = "tutorial";

  const TutorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<TutorialPageController>(
      create: (_) => TutorialPageController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 20,
            backgroundColor: theme.colorScheme.secondary,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const LogoHeader(),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    children: const [
                      TutorialPageFirst(),
                      TutorialPageSecond(),
                      TutorialPageThirt(),
                      TutorialPageFourth()
                    ],
                  )
                ),
                const TutorialPageButtonRow()
              ],
            ),
          )
        );
      }
    );
  }
}
