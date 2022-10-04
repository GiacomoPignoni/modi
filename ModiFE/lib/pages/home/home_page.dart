import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/home/home_page_controller.dart';
import 'package:modi/pages/home/home_page_drawer.dart';
import 'package:modi/pages/home/home_page_header.dart';
import 'package:modi/pages/home/home_page_mood_card.dart';
import 'package:modi/pages/home/home_page_text_input.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/animated/shake_widget.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';

class HomePage extends StatelessWidget {
  static const String routePath = "homePage";
  
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<HomePageController>(
      create: (_) => HomePageController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: controller.closeKeyboard,
          onPanStart: controller.onPanStart,
          onPanUpdate: controller.onPanUpdate,
          onPanEnd: controller.onPanEnd,
          child: Scaffold(
            key: controller.scaffoldKey,
            appBar: AppBar(toolbarHeight: 0),
            drawer: const HomePageDrawer(),
            body: SafeArea(
              child: Column(
                children: [
                  const HomePageHeader(),
                  Expanded(
                    child: Center(
                      child: ListView(
                        shrinkWrap: true,
                        padding: defaultScaffoldPadding,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: HomePageMoodCard(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: HomePageTextInput(),
                          ),
                          ShakeWidget(
                            shakeOffset: 2,
                            shakeCount: 2,
                            key: controller.buttonShakeKey,
                            child: ValueListenableBuilder<HomeOperation>(
                              valueListenable: controller.currentOperation,
                              builder: (context, operation, child) {
                                return Button(
                                  text: (operation == HomeOperation.editing) ? tr("homePage.update") : tr("homePage.submit"),
                                  onPressed: controller.doOperation,
                                  loading: controller.operationLoading,
                                );
                              }
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: ValueListenableBuilder<HomeOperation>(
                              valueListenable: controller.currentOperation,
                              builder: (context, currentOperation, child) {
                                return Visibility(
                                  visible: currentOperation == HomeOperation.editing,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: theme.colorScheme.secondary,
                                        size: 18,
                                      ),
                                      Flexible(
                                        child: Text(
                                          tr("homePage.todayWarning"),
                                          style: theme.textTheme.subtitle1!.copyWith(fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        );
      }
    );
  }
}
