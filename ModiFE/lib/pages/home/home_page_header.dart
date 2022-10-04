import 'package:flutter/material.dart';
import 'package:modi/pages/home/home_page_controller.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:provider/provider.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonIcon(
            icon: Icons.menu_rounded,
            onPressed: controller.openDrawer,
            iconSize: 35,
          ),
          ButtonIcon(
            icon: Icons.calendar_today_rounded,
            onPressed: controller.goToCalendarPage
          )
        ],
      ),
    );
  }
}
