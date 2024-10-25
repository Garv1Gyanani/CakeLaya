import 'dart:convert';
import 'dart:io';
import 'package:cakalaya/models/promotionmodel.dart';
import 'package:cakalaya/service/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PromotionsScreen extends StatefulWidget {
  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  List<XFile> banners = [];
  final ShopService _promotionService = ShopService();
  String? _shopId;

  @override
  void initState() {
    super.initState();
    _loadShopId();
  }

  Future<void> _loadShopId() async {
    try {
      _shopId = await _promotionService.getCurrentShopId();
      if (_shopId == null) {
        throw Exception("Failed to load shop ID");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading shop ID: $e')),
      );
    }
  }

  Future<void> _pickBanner() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null && banners.length < 4) {
      setState(() {
        banners.add(image);
      });
    } else if (banners.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only add up to 4 banners.')),
      );
    }
  }

  Future<String> _uploadBanner(XFile banner) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.6:8081/api/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', banner.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      return jsonResponse['url'];
    } else {
      throw Exception('Failed to upload banner');
    }
  }

  Future<void> _savePromotion() async {
    if (_shopId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Shop ID is required')),
      );
      return;
    }

    if (banners.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one banner.')),
      );
      return;
    }

    try {
      List<String> bannerUrls = [];
      for (XFile banner in banners) {
        String url = await _uploadBanner(banner);
        bannerUrls.add(url);
      }

      Promotion promotion = Promotion(
        shopId: _shopId!,
        bannerUrls: bannerUrls,
      );

      await _promotionService.createPromotion(promotion, _shopId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Promotion saved successfully!')),
      );

      setState(() {
        banners.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save promotion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("PROMOTIONS", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Promotional Banners (Max 4):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _pickBanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Add Image', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            banners.isEmpty
                ? Center(child: Text('No Banners Added', style: TextStyle(fontSize: 16)))
                : Expanded(
                    child: GridView.builder(
                      itemCount: banners.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Image.file(
                          File(banners[index].path),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _savePromotion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Save Promotion', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
