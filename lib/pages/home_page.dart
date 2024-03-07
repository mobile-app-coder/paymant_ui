import 'package:flutter/material.dart';
import 'package:paymant_ui/pages/details_page.dart';
import 'package:paymant_ui/services/nosql_service.dart';
import 'package:paymant_ui/services/sql_service.dart';
import 'package:paymant_ui/services/switcher.dart';

import '../models/credit_card_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? dataBase;

  List<CreditCard> cards = [];

  getCardsHive() {
    List<CreditCard> cardList = NoSql.getCards();
    if (cardList.isNotEmpty) {
      cards = cardList;
    }
  }

  fetchCards() async {
    List<CreditCard> cardsList = await SqlDb.fetchCards();
    if (cardsList.isNotEmpty) {
      setState(() {
        cards = cardsList;
      });
    } else {
      print("db is empty");
    }
  }

  Future _openDetailsPage() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const DetailsPage();
    }));
    setState(() {
      fetchCards();
    });
  }

  Future _openEditPage(int index) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailsPage(
        index: index,
      );
    }));
    setState(() {
      getCardsHive();
    });
  }

  @override
  void initState() {
    super.initState();
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
      drawer: Drawer(
        child: Container(
          child: Container(
            margin: EdgeInsets.only(top: 30, left: 20),
            width: double.infinity,
            height: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Sql"),
                    Checkbox(
                      value: true,
                      onChanged: (choice) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("NoSql"),
                    Checkbox(
                      value: true,
                      onChanged: (choice) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("NoSql"),
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
                        return _itemCardList(i);
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
      SqlDb.deleteCard(index);
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

  Widget _itemCardList(int index) {
    return GestureDetector(
      onLongPress: () {
        openDialog(cards[index].id!);
      },
      onTap: () {
        _openEditPage(cards[index].id!);
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
                  image: AssetImage(cards[index].cardImage),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "**** **** **** ${cards[index].cardNumber.substring(cards[index].cardNumber.length - 4)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  cards[index].expiredDate,
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
