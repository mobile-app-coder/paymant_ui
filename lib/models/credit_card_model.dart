import 'package:hive/hive.dart';

part 'credit_card_model.g.dart';

@HiveType(typeId: 0)
class CreditCard extends HiveObject {
  int? id;
  @HiveField(0)
  late String cardNumber;

  @HiveField(1)
  late String expiredDate;

  @HiveField(2)
  late String cardType;

  @HiveField(3)
  late String cardImage;

  CreditCard.of(this.cardNumber, this.expiredDate, this.cardType, this.cardImage);

  CreditCard({required this.cardNumber, required this.expiredDate});

  CreditCard.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        cardNumber = json['cardNumber'],
        expiredDate = json['expiredDate'],
        cardType = json['cardType'],
        cardImage = json['cardImage'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'expiredDate': expiredDate,
        'cardNumber': cardNumber,
        'cardType': cardType,
        'cardImage': cardImage
      };
}
