class Offer {
  String offerId;
  double productDiscount;
  String promocode;
  String createdAt;
  String shopId;

  Offer({
    required this.offerId,
    required this.productDiscount,
    required this.promocode,
    required this.createdAt,
    required this.shopId,
  });

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'productDiscount': productDiscount,
      'promocode': promocode,
      'createdAt': createdAt,
      'shopId': shopId,
    };
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerId: json['offerId'],
      productDiscount: json['productDiscount'],
      promocode: json['promocode'],
      createdAt: json['createdAt'],
      shopId: json['shopId'],
    );
  }
}
