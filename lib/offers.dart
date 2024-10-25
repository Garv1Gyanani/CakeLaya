import 'package:cakalaya/models/offerlist.dart';
import 'package:cakalaya/service/service.dart';
import 'package:flutter/material.dart';

class OfferDiscountScreen extends StatefulWidget {
  final double initialDiscount;

  OfferDiscountScreen({this.initialDiscount = 0.0});

  @override
  _OfferDiscountScreenState createState() => _OfferDiscountScreenState();
}

class _OfferDiscountScreenState extends State<OfferDiscountScreen> {
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _promocodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _discountController.text = widget.initialDiscount.toString();
  }

  void _addOffer() async {
    try {
      String? shopId = await ShopService().getCurrentShopId();
      if (shopId == null) {
        throw Exception('Shop ID is null');
      }

      double discount = double.tryParse(_discountController.text) ?? 0.0;

      if (discount < 0.0 || discount > 100.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Discount must be between 0 and 100!')),
        );
        return;
      }

      Offer newOffer = Offer(
        offerId: 'offer_${DateTime.now().millisecondsSinceEpoch}',
        productDiscount: discount,
        promocode: _promocodeController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
        shopId: shopId,
      );

      ShopService shopService = ShopService();
      await shopService.createOffer(newOffer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Offer added successfully!')),
      );
      Navigator.pop(context, discount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add offer: $e')),
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
          onPressed: () {
            Navigator.pop(context, double.tryParse(_discountController.text) ?? 0.0);
          },
        ),
        title: Text(
          "OFFER & DISCOUNT",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Discount:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter Value",
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 60,
                    child: Center(child: Text("%", style: TextStyle(fontSize: 20))),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              "Set Promo Codes:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _promocodeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter Promo Code",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Action for Numerical promo code
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Numerical", style: TextStyle(color: Color.fromARGB(255, 87, 72, 72))),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Action for Percentage promo code
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Percentage", style: TextStyle(color: Color.fromARGB(255, 87, 72, 72))),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _addOffer,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color.fromARGB(255, 182, 49, 5),
              ),
              child: Text("Add Offer",
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),),
            ),
            SizedBox(height: 25),
            Text(
              "Note:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "1. \"Product Discount\" is the percentage that the customer will "
              "see on product screens as a direct discount. This will decide "
              "the strike price and percentage as shown along with the products!",
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
