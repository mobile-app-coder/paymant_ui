class CreditCard {
  String? cardNumber;
  String? expiredDate;
  String? cardType;
  String? cardImage;

  CreditCard(
      {this.cardNumber, this.expiredDate, this.cardType, this.cardImage});


  CreditCard.fromMap(Map<String, dynamic> json)
      : cardNumber = json['cardNumber'],
        expiredDate = json['expiredDate'],
        cardType = json['cardType'],
        cardImage = json['cardImage'];

  Map<String, dynamic> toMap() =>
      {
        'expiredDate': expiredDate,
        'cardNumber': cardNumber,
        'cardType': cardType,
        'cardImage': cardImage
      };
}