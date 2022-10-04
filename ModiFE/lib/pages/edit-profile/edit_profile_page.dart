import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/edit-profile/edit_profile_page_input.dart';
import 'package:modi/pages/edit-profile/edit_profile_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/visual/page_title.dart';

class EditProfilePage extends StatelessWidget {
  static const String routePath = "edit-profile";

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<EditProfilePageController>(
      create: (_) => EditProfilePageController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () => controller.closeKeyboard(context),
          child: Scaffold(
            appBar: AppBar(
              leading: ButtonIcon(
                icon: Icons.chevron_left_rounded, 
                iconSize: 40,
                onPressed: controller.goBack,
              ),
            ),
            body: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultVerticalPadding),
              children: [
                PageTitle(
                  icon: Icons.person_outline_rounded,
                  title: tr("editProfilePage.title")
                ),
                EditProfilePageInput(
                  hint: tr("email"),
                  editionController: controller.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  disabled: controller.isFromSocial
                ),
                EditProfilePageInput(
                  hint: tr("nickname"),
                  editionController: controller.nicknameCtrl,
                ),
                Visibility(
                  visible: controller.isFromSocial == false,
                  child: EditProfilePageInput(
                    hint: tr("password"),
                    editionController: controller.passwordCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true
                  ),
                ),
                Visibility(
                  visible: controller.isFromSocial == false,
                  child: EditProfilePageInput(
                    hint: tr("confirmPassword"),
                    editionController: controller.confirmPasswordCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    marginBottom: 0,
                  ),
                ),
                // Password error text
                ValueListenableBuilder<bool>(
                  valueListenable: controller.showPasswordError,
                  builder: (context, showPasswordError, child) {
                    return Visibility(
                      visible: showPasswordError,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          tr("editProfilePage.passwordsMustMatch"),
                          style: theme.textTheme.subtitle2,
                        ),
                      )
                    );
                  }
                ),
                Visibility(
                  visible: controller.isFromSocial,
                  child: Text(
                    tr("editProfilePage.youCantChange"),
                    style: theme.textTheme.subtitle2,
                    textAlign: TextAlign.center
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Button(
                    text: tr("editProfilePage.saveChanges"),
                    onPressed: controller.save,
                    loading: controller.loading,
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
