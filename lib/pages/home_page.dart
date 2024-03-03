import 'package:flutter/material.dart';
import 'package:paymant_ui/pages/details_page.dart';
import 'package:paymant_ui/services/nosql_service.dart';

import '../models/credit_card_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CreditCard> cards = [];

  getCards() {
    List<CreditCard> cardList = NoSql.getCards();
    if (cardList.isNotEmpty) {
      cards = cardList;
    }
  }

  Future _openDetailsPage() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const DetailsPage();
    }));
    setState(() {
      getCards();
    });
  }

  Future _openEditPage(CreditCard card) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailsPage(
        creditCard: card,
        index: cards.indexOf(card),
      );
    }));
    setState(() {
      getCards();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCards();
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
        title: const Text(" Card list"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: cards.isEmpty
                  ? const Center(
                      child: Text(
                        "No cards",
                        style: TextStyle(fontSize: 40),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (ctx, i) {
                        return _itemCardList(cards[i], i);
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
                child: const Text(
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
  deleteCard(int index) async {
    setState(() {
      cards.removeAt(index);
      NoSql.deleteCardByIndex(index);
    });
  }

  void openDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text("Delete card"),
            content: const Text("Are you sure"),
            actions: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    deleteCard(index);
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

  Widget _itemCardList(CreditCard card, int index) {
    return GestureDetector(
      onLongPress: () {
        openDialog(index);
      },
      onTap: () {
        _openEditPage(card);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 70,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: AspectRatio(
                aspectRatio: 400 / 260,
                child: Image(
                  image: AssetImage(card.cardImage),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  card.expiredDate,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
