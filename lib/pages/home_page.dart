import 'package:flutter/material.dart';
import 'package:paymant_ui/pages/details_page.dart';
import 'package:paymant_ui/services/store_service.dart';

import '../models/credit_card_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CreditCard> cards = [];

  Future _openDetailsPage() async {
    CreditCard result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailsPage();
    }));
    cards.clear();
    _loadCards();
  }

  _loadCards() async {
    var memoryList = await Shared.loadCardList();
    if (memoryList == null) {
      print("null value returned");
      return;
    }

    if (memoryList.isEmpty) {
      print("List is empty");
      return;
    }
    setState(() {
      cards.addAll(memoryList);
    });
    print("working");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(" Card list"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (ctx, i) {
                  return _itemCardList(cards[i]);
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: MaterialButton(
                onPressed: () {
                  _openDetailsPage();
                },
                child: Text(
                  'Add card',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemCardList(CreditCard card) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: 70,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: AspectRatio(
              aspectRatio: 400 / 260,
              child: Image(
                image: AssetImage(card.cardImage!),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "**** **** **** ${card.cardNumber!.substring(card.cardNumber!.length - 4)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                card.expiredDate!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }
}
