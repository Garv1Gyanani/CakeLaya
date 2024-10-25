import 'package:cakalaya/models/delivery.dart';

class Shop {
  String? id;
  String? shopName;
  String? fssaiLicenseNumber;
  double? commissionPercentage;
  String? shopPhotoUrl;
  PackagingDelivery? packagingDelivery;
  String? createAt;
  String? updatedAt;

  Shop({
    this.id,
    this.shopName,
    this.fssaiLicenseNumber,
    this.commissionPercentage,
    this.shopPhotoUrl,
    this.packagingDelivery,
    this.createAt,
    this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'],
      shopName: json['shopName'],
      fssaiLicenseNumber: json['fssaiLicenseNumber'],
      commissionPercentage: (json['commissionPercentage'] as num?)?.toDouble(),
      shopPhotoUrl: json['shopPhotoUrl'],
      packagingDelivery: json['packagingDelivery'] != null
          ? PackagingDelivery.fromJson(json['packagingDelivery'])
          : null,
      createAt: json['createAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (shopName != null) 'shopName': shopName,
      if (fssaiLicenseNumber != null) 'fssaiLicenseNumber': fssaiLicenseNumber,
      if (commissionPercentage != null) 'commissionPercentage': commissionPercentage,
      if (shopPhotoUrl != null) 'shopPhotoUrl': shopPhotoUrl,
      if (packagingDelivery != null) 'packagingDelivery': packagingDelivery?.toJson(),
      if (createAt != null) 'createAt': createAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }
}
