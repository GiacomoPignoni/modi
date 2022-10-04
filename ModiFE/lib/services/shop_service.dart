import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/models/res/shop_reses.dart';
import 'package:modi/models/shop_prices.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/services/http_service.dart';
import 'package:modi/services/message_service.dart';
import 'package:modi/services/notes_service.dart';
import 'package:modi/services/user_service.dart';

class ShopService {
  final HttpService _httpSvc = GetIt.I.get<HttpService>();
  final MessageService _messageSvc = GetIt.I.get<MessageService>();
  final UserService _userSvc = GetIt.I.get<UserService>();
  final NotesService _notesSvc = GetIt.I.get<NotesService>();

  ShopPrices? _shopPrices;

  Future<ShopPrices?> getPrices() async {
    if(_shopPrices == null) {
      final res = await _httpSvc.get<GetPricesRes>(
        "/shop/prices",
        serializer: (json) => GetPricesRes.fromJson(json)
      );

      if(res != null) {
        if(res.isNotError) {
          _shopPrices = ShopPrices.fromHttpRes(res);
        } else {
          _messageSvc.showSnackBar(type: MessageType.error, text: tr("errors.${res.message}"));
        }
      }
    }

    return _shopPrices!;
  }

  Future<SingleNote?> buyRandomNote() async {
    final res = await _httpSvc.get<BuyNoteRes>(
      "/shop/buy-random-note",
      serializer: (json) => BuyNoteRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        _notesSvc.addNoteToCache(res.unlockedNote!);
        _userSvc.updateTokens(res.tokens);
        return res.unlockedNote;
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: tr("errors.${res.message}"));
      }
    }
    return null;
  }

  Future<SingleNote?> buyRandomMonthNote(int month) async {
    final res = await _httpSvc.get<BuyNoteRes>(
      "/shop/buy-random-month-note?month=$month",
      serializer: (json) => BuyNoteRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        _notesSvc.addNoteToCache(res.unlockedNote!);
        _userSvc.updateTokens(res.tokens);
        return res.unlockedNote;
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: tr("errors.${res.message}"));
      }
    }
    return null;
  }

  Future<SingleNote?> buyNote(DateTime date) async {
    final res = await _httpSvc.get<BuyNoteRes>(
      "/shop/buy-note?date=$date",
      serializer: (json) => BuyNoteRes.fromJson(json)
    );

    if(res != null) {
      if(res.isNotError) {
        _notesSvc.addNoteToCache(res.unlockedNote!);
        _userSvc.updateTokens(res.tokens);
        return res.unlockedNote;
      } else {
        _messageSvc.showSnackBar(type: MessageType.error, text: tr("errors.${res.message}"));
      }
    }
    return null;
  }
}
