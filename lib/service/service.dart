import 'dart:convert';
import 'package:cakalaya/models/shopmodel.dart';
import 'package:cakalaya/models/offerlist.dart';
import 'package:cakalaya/models/promotionmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ShopService {
  final String shopBaseUrl = "http://192.168.1.6:8081/api/shops";
  final String promotionBaseUrl = "http://192.168.1.6:8081/api/promotions";

  ShopService();

  Future<Shop?> createShop(Shop shop) async {
    final response = await http.post(
      Uri.parse(shopBaseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(shop.toJson()),
    );

    if (response.statusCode == 201) {
      return Shop.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create shop');
    }
  }

  Future<String?> getCurrentShopId() async {
    final response = await http.get(Uri.parse("$shopBaseUrl/current/id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['id'] as String;
    } else {
      throw Exception('Failed to load current shop ID');
    }
  }

  Future<Shop?> getShop(String shopId) async {
    final response = await http.get(Uri.parse("$shopBaseUrl/$shopId"));

    if (response.statusCode == 200) {
      return Shop.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load shop: ${response.statusCode}');
    }
  }

  Future<Shop?> updateShop(String id, Shop shopDetails) async {
    final response = await http.put(
      Uri.parse("$shopBaseUrl/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(shopDetails.toJson()),
    );

    if (response.statusCode == 200) {
      return Shop.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update shop: ${response.statusCode}');
    }
  }

  Future<Offer?> createOffer(Offer offer) async {
    String? shopId = await getCurrentShopId();
    if (shopId == null) {
      throw Exception('No current shop ID found');
    }

    final String offerUrl = '$shopBaseUrl/$shopId/offers';

    final response = await http.post(
      Uri.parse(offerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(offer.toJson()),
    );

    if (response.statusCode == 201) {
      return Offer.fromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print('Failed to create offer: ${response.statusCode} ${response.body}');
      }
      throw Exception('Failed to create offer: ${response.statusCode}');
    }
  }

  Future<Promotion?> createPromotion(Promotion promotion, String shopId) async {
    String? shopId = await getCurrentShopId();
    if (shopId == null) {
      throw Exception('No current shop ID found');
    }

    final String promotionUrl = '$promotionBaseUrl/shop/$shopId';

    final response = await http.post(
      Uri.parse(promotionUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(promotion.toJson()),
    );

    if (response.statusCode == 201) {
      return Promotion.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create promotion: ${response.statusCode}');
    }
  }
}
