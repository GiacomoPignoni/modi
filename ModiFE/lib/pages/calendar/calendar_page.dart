import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modi/pages/calendar/calendar_page_controller.dart';
import 'package:modi/pages/calendar/calendar_page_month_grid.dart';
import 'package:modi/pages/calendar/calendar_page_view_selector.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/visual/page_loader.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CalendarPage extends StatelessWidget {
  static const String routePath = "calendar";

  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<CalendarPageController>(
      create: (_) => CalendarPageController(),
      dispose: (_, controller) => controller.dipose(),
      builder: (context, controller, child) {
        return Scaffold(
          appBar: _getAppbar(controller, theme),
          body: PageLoader(
            loading: controller.loading,
            child: Column(
              children: [
                const CalendarPageViewSelector(),
                Expanded(
                  child: ValueListenableBuilder<CalendarPageView>(
                    valueListenable: controller.selectedView,
                    builder: (context, selectedView, child) {
                      return ScrollablePositionedList.separated(
                        itemScrollController: controller.itemsScrollController,
                        itemPositionsListener: controller.itemPositionsListener,
                        itemCount: 12,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(defaultHorizontalPadding, defaultVerticalPadding, defaultHorizontalPadding, 20),
                        itemBuilder: (context, index) {
                          return CalendarPageMonthGrid(
                            month: index + 1
                          );
                        },
                        separatorBuilder: (context, i) => const Divider(color: Colors.transparent)
                      );
                    }
                  )
                ),
                FutureBuilder<BannerAd>(
                  future: controller.bannerAd,
                  initialData: null,
                  builder: (context, snap) {
                    if(snap.data == null) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      width: 320,
                      height: 50,
                      alignment: Alignment.center,
                      child: AdWidget(ad: snap.data!)
                    );
                  },             
                )
              ],
            )
          )
        );
      }
    );
  }

  PreferredSizeWidget _getAppbar(CalendarPageController controller, ThemeData theme) {
    return AppBar(
      centerTitle: true,
      title: Text(
        DateTime.now().year.toString(),
        style: theme.textTheme.headline3
      ),
      leading: ButtonIcon(
        icon: Icons.chevron_left_rounded,
        iconSize: 40,
        onPressed: controller.goBack,
      ),
      actions: [
        ValueListenableBuilder<CalendarPageView>(
          valueListenable: controller.selectedView,
          builder: (context, selectedView, child) {
            return Visibility(
              visible: selectedView == CalendarPageView.partner,
              child: child!,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ButtonIcon(
              icon: Icons.replay_rounded,
              onPressed: controller.reloadPartnerNotes
            ),
          ),
        )
      ],
    );
  }
}
