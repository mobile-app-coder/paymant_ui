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
    _loadCards();
  }

  _loadCards() async {
    var memoryList = await Shared.loadCardList();

    if (memoryList == null) {
      return;
    }

    if (memoryList.isEmpty) {
      return;
    }
    setState(() {
      cards = memoryList;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadCards();
    });
  }

  Widget noCards() {
    return Container(
      height: 100,
      width: 100,
      color: Colors.blue,
    );
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
              child: cards.isEmpty
                  ? Center(
                      child: Text(
                        "No cards",
                        style: TextStyle(fontSize: 40),
                      ),
                    )
                  : ListView.builder(
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

  //delete card
  deleteCard(CreditCard creditCard) async {
    cards.remove(creditCard);
    Shared.removeCardList();
    Shared.storeCardList(cards);
  }

  void openDialog(CreditCard card) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text("Delete card"),
            content: Text("Are you sure"),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    deleteCard(card);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Confirm"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  Widget _itemCardList(CreditCard card) {
    return GestureDetector(
      onLongPress: () {
        openDialog(card);
      },
      child: Container(
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
      ),
    );
  }
}
