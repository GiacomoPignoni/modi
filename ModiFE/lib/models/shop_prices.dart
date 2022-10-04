import 'package:modi/models/res/shop_reses.dart';

class ShopPrices {
  int randomNote;
  int randomMonthNote;
  int note;

  ShopPrices.fromHttpRes(GetPricesRes res) :
    randomNote = res.randomNote,
    randomMonthNote = res.randomMonthNote,
    note = res.note;
}
