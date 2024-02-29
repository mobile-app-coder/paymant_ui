import 'dart:convert';

import 'package:paymant_ui/models/credit_card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  
  static storeCardList(List<CreditCard> userList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cardListString =
        userList.map((user) => jsonEncode(user.toMap())).toList();
    await prefs.setStringList('card_list', cardListString);
  }

  static Future<List<CreditCard>?> loadCardList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cardListString = prefs.getStringList("card_list");
    if (cardListString == null || cardListString.isEmpty) return null;

    List<CreditCard> cardList = cardListString
        .map((cardString) => CreditCard.fromMap(json.decode(cardString)))
        .toList();
    return cardList;
  }

  static Future<bool> removeCardList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("card_list");
  }
}
