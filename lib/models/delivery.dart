class PackagingDelivery {
  int deliveryTime; 
  int deliveryRadius; 
  int freeDeliveryRadius; 
  double orderValueAbove500; 
  double orderValueBelow500; 

  PackagingDelivery({
    required this.deliveryTime,
    required this.deliveryRadius,
    required this.freeDeliveryRadius,
    required this.orderValueAbove500,
    required this.orderValueBelow500,
  });

  factory PackagingDelivery.fromJson(Map<String, dynamic> json) {
    return PackagingDelivery(
      deliveryTime: json['deliveryTime'],
      deliveryRadius: json['deliveryRadius'],
      freeDeliveryRadius: json['freeDeliveryRadius'],
      orderValueAbove500: json['orderValueAbove500'],
      orderValueBelow500: json['orderValueBelow500'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryTime': deliveryTime,
      'deliveryRadius': deliveryRadius,
      'freeDeliveryRadius': freeDeliveryRadius,
      'orderValueAbove500': orderValueAbove500,
      'orderValueBelow500': orderValueBelow500,
    };
  }
}
