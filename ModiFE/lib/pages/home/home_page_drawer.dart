import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/pages/edit-profile/edit_profile_page.dart';
import 'package:modi/pages/home/home_page_controller.dart';
import 'package:modi/pages/info/info_page.dart';
import 'package:modi/pages/partner/partner_page.dart';
import 'package:modi/pages/read-notes/read_notes_page.dart';
import 'package:modi/pages/shop/shop_page.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:provider/provider.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);
    final theme = Theme.of(context);
    
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: defaultRadius,
        bottomRight: defaultRadius
      ),
      child: Drawer(
        child: Column(
          children: [
            const HomeDrawerHeader(),
            Expanded(
              child: Container(
                color: theme.colorScheme.background,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    HomeDrawerTile(
                      icon: Icons.list_alt_rounded,
                      text: tr("homePage.drawer.readNotes"),
                      onPressed: () => controller.drawerGoTo(ReadNotesPage.routePath)
                    ),
                    const Divider(color: Colors.transparent),
                    HomeDrawerTile(
                      icon: Icons.store_outlined,
                      text: tr("homePage.drawer.shop"),
                      onPressed: () => controller.drawerGoTo(ShopPage.routePath)
                    ),   
                    const Divider(color: Colors.transparent),    
                    HomeDrawerTile(
                      icon: Icons.people_outline_rounded,
                      text: tr("homePage.drawer.partner"),
                      onPressed: () => controller.drawerGoTo(PartnerPage.routePath)
                    ),
                    const Divider(color: Colors.transparent),
                    HomeDrawerTile(
                      icon: Icons.manage_accounts_outlined,
                      text: tr("homePage.drawer.editProfile"),
                      onPressed: () => controller.drawerGoTo(EditProfilePage.routePath)
                    ),
                    const Divider(color: Colors.transparent),
                    HomeDrawerTile(
                      icon: Icons.info_outline_rounded,
                      text: tr("homePage.drawer.info"),
                      onPressed: () => controller.drawerGoTo(InfoPage.routePath)
                    ),
                    const Divider(color: Colors.transparent),
                    HomeDrawerTile(
                      icon: Icons.logout_rounded,
                      text: tr("homePage.logout"),
                        onPressed: controller.logout
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class HomeDrawerHeader extends StatelessWidget{
  const HomeDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: 250,
      child: DrawerHeader(
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
        margin: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: controller.showShopInfoDialog,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.monetization_on_outlined,
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                        ValueListenableBuilder<ModiUser?>(
                          valueListenable: controller.modiUser,
                          builder: (context, modiUser, child) {
                            return Text(
                              modiUser?.tokens.toString() ?? "-",
                              style: theme.textTheme.bodyText1
                            );
                          },
                        )
                      ]
                    ),
                  ),
                  ButtonIcon(
                    icon: Icons.close_rounded,
                    onPressed: controller.closeDrawer,
                    color: theme.colorScheme.onPrimary
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ValueListenableBuilder<ModiUser?>(
                valueListenable: controller.modiUser,
                builder: (context, modiUser, child) {
                  return FittedBox(
                    child: Text(
                      tr("homePage.hi", args: [modiUser?.nickname ?? ""]),
                      style: theme.textTheme.headline1,
                    ),
                  );
                }
              ),
            ),
            ValueListenableBuilder<ModiUser?>(
                valueListenable: controller.modiUser,
                builder: (context, modiUser, child) {
                  return RichText(
                    text: TextSpan(
                      text: tr("homePage.combo"),
                      style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: modiUser?.combo.toString(),
                          style: theme.textTheme.bodyText1
                        )
                      ]
                    )
                  );
                }
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.email_outlined,
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                ValueListenableBuilder<ModiUser?>(
                  valueListenable: controller.modiUser,
                  builder: (context, modiUser, child) {
                    return Text(modiUser?.email ?? "");
                  }
                ),
              ],
            ),
            ValueListenableBuilder<ModiUser?>(
              valueListenable: controller.modiUser,
              builder: (context, modiUser, child) {
                return Visibility(
                  visible: modiUser?.patnerNickname != null,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.people_outline_rounded,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                      Text(modiUser?.patnerNickname ?? "-")
                    ],
                  ),
                );
              }
            )
          ]
        )
      ),
    );
  }
}

class HomeDrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;

  const HomeDrawerTile({
    required this.text,
    required this.icon,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary,
              borderRadius: defaultBorderRadius,
              boxShadow: const [ defaultShadow ]
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(text),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: ButtonIcon(
                icon: Icons.chevron_right_rounded,
                onPressed: onPressed
              ),
            )
          )
        ],
      ),
    );
  }
}
