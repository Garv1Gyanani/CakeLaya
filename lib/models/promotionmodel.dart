class Promotion {
  String? id;
  String? shopId;
  List<String>? bannerUrls;
  String? createdAt;
  String? updatedAt;

  Promotion({this.id, this.shopId, this.bannerUrls, this.createdAt, this.updatedAt});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['_id'],
      shopId: json['shopId'],
      bannerUrls: List<String>.from(json['bannerUrls']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'bannerUrls': bannerUrls,
    };
  }
}
