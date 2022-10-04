import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/home/home_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/visual/card.dart';
import 'package:provider/provider.dart';

class HomePageTextInput extends StatelessWidget {
  const HomePageTextInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);
    
    return Stack(
      alignment: Alignment.center,
      children: [
        const HomeDeleteButton(),
        Container(
          padding: const EdgeInsets.only(bottom: 50),
          child: MyCard(
            child: ValueListenableBuilder<HomeOperation>(
              valueListenable: controller.currentOperation,
              builder: (context, operation, child) {
                return TextField(
                  decoration: InputDecoration(
                    hintText: operation != HomeOperation.view ? tr("homePage.writeYourNote") : tr("homePage.youHaveAlreadyWritten"),
                    alignLabelWithHint: true
                  ),
                  focusNode: controller.textFocusNode,
                  textAlign: operation == HomeOperation.view ? TextAlign.center : TextAlign.start,
                  enabled: operation != HomeOperation.view,
                  controller: controller.textCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 10,
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}

class HomeDeleteButton extends StatefulWidget {
  static Matrix4 pressedMatrix = Matrix4(
    1,0,0,0,
    0,1,0,0.001,
    0,0,1,0,
    0,0,0,1,
  );

  const HomeDeleteButton({Key? key}) : super(key: key);

  @override
  State<HomeDeleteButton> createState() => _HomeDeleteButtonState();
}

class _HomeDeleteButtonState extends State<HomeDeleteButton> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);
    final theme = Theme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: controller.showDeleteButton,
      builder: (context, showDeleteButton, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: showDeleteButton ? 0 : 100,
          child: GestureDetector(
            onTapDown: (_) => setState(() => isDown = true),
            onTapCancel: () => setState(() => isDown = false),
            onTapUp: (_) => setState(() => isDown = false),
            onTap: controller.showConfirmDeleteDialog,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.fromLTRB(10, 35, 10, 5),
              transform: (isDown) ? HomeDeleteButton.pressedMatrix : null,
              transformAlignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: defaultBorderRadius,
                color: theme.primaryColorLight,
                boxShadow: const [ defaultShadow ]
              ),
              child: Icon(
                Icons.delete_outline_outlined,
                color: theme.colorScheme.error,
                size: 35,
              )
            ),
          ),
        );
      }
    );
  }
}
