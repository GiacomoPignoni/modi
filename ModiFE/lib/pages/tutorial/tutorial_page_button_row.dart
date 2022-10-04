import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/tutorial/tutorial_page_controller.dart';
import 'package:modi/widgets/inputs/button_text.dart';
import 'package:provider/provider.dart';

class TutorialPageButtonRow extends StatelessWidget {
  const TutorialPageButtonRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TutorialPageController>(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: StreamBuilder<int>(
        stream: controller.pageChange,
        builder: (context, snapshot) {
          final currentPage = controller.pageController.page ?? 0;
  
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  4, 
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 10,
                      height: 10,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: theme.shadowColor,),
                      alignment: ((currentPage) > index) ? Alignment.centerRight : Alignment.centerLeft,
                      child: Visibility(
                        visible: _fillCircleVisible(currentPage, index),
                        child: Container(
                          width: _calculateWidth(currentPage, index),
                          height: 10,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle
                          ),
                        ),
                      ),
                    ),
                  )
                ),
              ),
              ButtonText(
                text: (currentPage < 3) ? tr("tutorialPage.next") : tr("tutorialPage.finish"),
                onPressed: (currentPage < 3) ? controller.nextPage : controller.goToHome,
              )
            ],
          );
        }
      ),
    );
  }

  double _calculateWidth(double page, int index) {    
    final firstDecimal = ((page - page.toInt()) * 10).toInt().toDouble();
    return (page.toInt() == index) ? 10 - firstDecimal : firstDecimal;
  }

  bool _fillCircleVisible(double page, int index) {
    return page > index - 1 && page < index + 1;
  }
}
