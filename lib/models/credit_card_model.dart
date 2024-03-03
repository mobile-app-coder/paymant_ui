import 'package:hive/hive.dart';
part 'credit_card_model.g.dart';

@HiveType(typeId: 0)
class CreditCard extends HiveObject {

  @HiveField(0)
  late String cardNumber;

  @HiveField(1)
  late String expiredDate;

  @HiveField(2)
  late String cardType;

  @HiveField(3)
  late String cardImage;

  CreditCard({required this.cardNumber, required this.expiredDate});

  CreditCard.fromMap(Map<String, dynamic> json)
      : cardNumber = json['cardNumber'],
        expiredDate = json['expiredDate'],
        cardType = json['cardType'],
        cardImage = json['cardImage'];

  Map<String, dynamic> toMap() => {
        'expiredDate': expiredDate,
        'cardNumber': cardNumber,
        'cardType': cardType,
        'cardImage': cardImage
      };
}
