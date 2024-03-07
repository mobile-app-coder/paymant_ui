import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/credit_card_model.dart';

class NoSql {
  static var box = Hive.box("cards_db");


  static init() async {
    var appDocumentary = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentary.path)
      ..registerAdapter(CreditCardAdapter());
    await Hive.openBox("cards_db");
  }
  static saveCard(CreditCard card) async {
    box.add(card);
  }

  static CreditCard getCardByIndex(int index) {
    return box.getAt(index);
  }

  static updateCard(int index, CreditCard card) async {
    box.putAt(index, card);
  }

  static List<CreditCard> getCards() {
    List<CreditCard> cards = [];
    for (var i = 0; i < box.length; i++) {
      cards.add(box.getAt(i));
    }
    return cards;
  }

  static deleteCardByIndex(int index) async {
    box.deleteAt(index);
  }

  static deleteCard(CreditCard card) async {
    box.delete(card);
  }
}
