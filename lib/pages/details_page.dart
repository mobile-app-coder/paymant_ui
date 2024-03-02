import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:paymant_ui/services/store_service.dart';

import '../models/credit_card_model.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}


//this is before commit



class _DetailsPageState extends State<DetailsPage> {
  //controllers
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiredDateController = TextEditingController();

  //card numbers and expire date
  String cardNumber = '0000 0000 0000 0000';
  String expiredDate = 'MM/YY';

  //formatters
  var cardNumberMaskFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var expiryDateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  String getType() {
    if (cardNumber.isEmpty) {
      return '';
    }
    if (cardNumber.startsWith('4')) {
      return 'VISA';
    } else if (cardNumber.startsWith('5')) {
      return 'MASTER';
    }
    return '';
  }



  //toast

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //back
  void backToFinish(CreditCard creditCard) {
    Navigator.of(context).pop(creditCard);
  }

  //save cards to memory
  _saveCard(CreditCard card) async {
    List<CreditCard> cards = [];
    List<CreditCard>? storedCards = await Shared.loadCardList();
    if (storedCards != null) {
      cards.addAll(storedCards);
    }
    Shared.removeCardList();
    cards.add(card);
    Shared.storeCardList(cards);
  }

  //save
  void saveCreditCard() {
    String cardNumber = cardNumberController.text;
    String expiryDate = expiredDateController.text;

    CreditCard creditCard =
        CreditCard(cardNumber: cardNumber, expiredDate: expiryDate);

    setState(() {
      if (cardNumber.trim().isEmpty || cardNumber.length < 16) {
        showToast('Enter valid card number');
        return;
      }
      if (expiryDate.trim().isEmpty || expiryDate.length < 5) {
        showToast('Enter valid date');
        return;
      }
      if (cardNumber.startsWith('4')) {
        creditCard.cardImage = 'assets/images/ic_card_visa.png';
        creditCard.cardType = 'visa';
      } else if (cardNumber.startsWith('5')) {
        creditCard.cardImage = 'assets/images/ic_card_master.png';
        creditCard.cardType = 'master';
      } else {
        showToast('Enter only visa and master cards');
        return;
      }
      _saveCard(creditCard);
      backToFinish(creditCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add card"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            //card
            Expanded(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1005 / 555,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/im_card_bg.png"),
                            fit: BoxFit.cover),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                getType(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  cardNumber,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                Text(
                                  expiredDate,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  //card number input
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 45,
                    child: TextField(
                      controller: cardNumberController,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: "Card number",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                           
                          },
                          icon: const Icon(Icons.document_scanner_rounded),
                        ),
                      ),
                      onChanged: (text) {
                        setState(
                          () {
                            cardNumber = text;
                          },
                        );
                      },
                      inputFormatters: [cardNumberMaskFormatter],
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  //expire date input
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 45,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: expiredDateController,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: const InputDecoration(
                        hintText: 'Expired Date',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          expiredDate = value;
                        });
                      },
                      inputFormatters: [expiryDateMaskFormatter],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blue,
              ),
              child: MaterialButton(
                onPressed: () {
                  saveCreditCard();
                  // scanCard();
                },
                child: const Text(
                  'Save Card',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
