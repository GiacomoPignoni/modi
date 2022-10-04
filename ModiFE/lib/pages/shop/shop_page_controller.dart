import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/ask_date/ask_date_dialog.dart';
import 'package:modi/dialogs/ask_month/ask_month_dialog.dart';
import 'package:modi/dialogs/shop_product_details_dialog.dart';
import 'package:modi/dialogs/unlocked_note_dialog.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/dialogs/shop_page_info_dialog.dart';
import 'package:modi/models/shop_prices.dart';
import 'package:modi/models/shop_product.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/shop_service.dart';
import 'package:modi/services/user_service.dart';

class ShopPageController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final ShopService _shopSvc = GetIt.I.get<ShopService>();
  final UserService _userSvc = GetIt.I.get<UserService>();

  ValueNotifier<ModiUser?> get modiUser => _userSvc.modiUser;

  final ValueNotifier<ShopPrices?> prices = ValueNotifier(null);
  final ValueNotifier<bool> loading = ValueNotifier(false);

  ShopPageController() {
    _loadPrices();
  }
  
  void goBack() {
    _navigationSvc.pop();
  }

  void showInfoDialog() {
    ShopPageInfoDialog.show(_navigationSvc.currentContext);
  }

  Future<void> buyRandomNote() async {
    if(prices.value == null) {
      return;
    }

    final result = await ShopProductDetailsDialog.show(
      _navigationSvc.currentContext,
      price: prices.value?.randomNote ?? 0,
      product: ShopProduct.randomNote
    );

    if(result == true) {
      loading.value = true;
      final unlockedNote = await _shopSvc.buyRandomNote();
      _handleUnlockedNote(unlockedNote);
      loading.value = false;
    }
  }

  Future<void> buyRandomMonthNote() async {
    if(prices.value == null) {
      return;
    }

    final result = await ShopProductDetailsDialog.show(
      _navigationSvc.currentContext,
      price: prices.value?.randomMonthNote ?? 0,
      product: ShopProduct.randomMonthNote
    );

    if(result == true) {
      final month = await AskMonthDialog.show(
        _navigationSvc.currentContext,
        title: tr("shopPage.askMonthDialogTitle"),
        text: tr("shopPage.askMonthDialogText"),
        hint: tr("shopPage.askMonthDialogHint")
      );

      if(month != null) {
        loading.value = true;
        final unlockedNote = await _shopSvc.buyRandomMonthNote(month);
        _handleUnlockedNote(unlockedNote);
        loading.value = false;
      }
    }
  }

  Future<void> buyNote() async {
    if(prices.value == null) {
      return;
    }

    final result = await ShopProductDetailsDialog.show(
      _navigationSvc.currentContext,
      price: prices.value?.note ?? 0,
      product: ShopProduct.note
    );

    if(result == true) {
      final date = await AskDateDialog.show(
        _navigationSvc.currentContext,
        title: tr("shopPage.askDateDialogTitle"),
        text: tr("shopPage.askDateDialogText"),
      );

      if(date != null) {
        loading.value = true;
        final unlockedNote = await _shopSvc.buyNote(date);
        _handleUnlockedNote(unlockedNote);
        loading.value = false;
      }
    }
  }

  void _handleUnlockedNote(SingleNote? unlockedNote) {
    if(unlockedNote != null) {
      UnlockedNoteDialog.show(_navigationSvc.currentContext, note: unlockedNote);
    }
  }

  Future<void> _loadPrices() async {
    prices.value = await _shopSvc.getPrices();
  }

  void dispose() {
    prices.dispose();
    loading.dispose();
  }
}
