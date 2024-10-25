import 'package:flutter/material.dart';
import 'package:cakalaya/service/service.dart';
import 'package:cakalaya/models/shopmodel.dart';
import 'package:cakalaya/models/delivery.dart';

class PackagingDeliveryScreen extends StatefulWidget {
  final String shopId;
  final String shopName;
  final String fssaiLicenseNumber;
  final double commissionPercentage;

  const PackagingDeliveryScreen({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.fssaiLicenseNumber,
    required this.commissionPercentage,
  });

  @override
  _PackagingDeliveryScreenState createState() => _PackagingDeliveryScreenState();
}

class _PackagingDeliveryScreenState extends State<PackagingDeliveryScreen> {
  final TextEditingController _deliveryTimeController = TextEditingController();
  final TextEditingController _deliveryRadiusController = TextEditingController();
  final TextEditingController _freeDeliveryRadiusController = TextEditingController();
  final TextEditingController _orderValueAbove500Controller = TextEditingController();
  final TextEditingController _orderValueBelow500Controller = TextEditingController();

  final ShopService _shopService = ShopService();
  Shop? existingShop;

  @override
  void initState() {
    super.initState();
    _loadExistingShopData();
  }

  Future<void> _loadExistingShopData() async {
    try {
      Shop? fetchedShop = await _shopService.getShop(widget.shopId);
      if (fetchedShop != null) {
        setState(() {
          existingShop = fetchedShop;
        });

        // Load existing packaging delivery data
        _deliveryTimeController.text = existingShop!.packagingDelivery?.deliveryTime.toString() ?? '';
        _deliveryRadiusController.text = existingShop!.packagingDelivery?.deliveryRadius.toString() ?? '';
        _freeDeliveryRadiusController.text = existingShop!.packagingDelivery?.freeDeliveryRadius.toString() ?? '';
        _orderValueAbove500Controller.text = existingShop!.packagingDelivery?.orderValueAbove500.toString() ?? '';
        _orderValueBelow500Controller.text = existingShop!.packagingDelivery?.orderValueBelow500.toString() ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load shop: $e')),
      );
    }
  }

  Future<void> updatePackagingAndDelivery() async {
    if (existingShop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No shop data to update')),
      );
      return;
    }

    try {
      final deliveryTime = int.parse(_deliveryTimeController.text);
      final deliveryRadius = int.parse(_deliveryRadiusController.text);
      final freeDeliveryRadius = int.parse(_freeDeliveryRadiusController.text);
      final orderValueAbove500 = double.parse(_orderValueAbove500Controller.text);
      final orderValueBelow500 = double.parse(_orderValueBelow500Controller.text);

      // Create PackagingDelivery object
      PackagingDelivery packagingDelivery = PackagingDelivery(
        deliveryTime: deliveryTime,
        deliveryRadius: deliveryRadius,
        freeDeliveryRadius: freeDeliveryRadius,
        orderValueAbove500: orderValueAbove500,
        orderValueBelow500: orderValueBelow500,
      );

      // Update Shop object with new values
      Shop updatedShop = Shop(
        id: widget.shopId,
        shopName: widget.shopName,
        fssaiLicenseNumber: widget.fssaiLicenseNumber,
        commissionPercentage: widget.commissionPercentage,
        shopPhotoUrl: existingShop!.shopPhotoUrl ?? '',
        packagingDelivery: packagingDelivery,
        createAt: existingShop!.createAt ?? '',
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Call service to update shop details
      final updatedResponse = await _shopService.updateShop(widget.shopId, updatedShop);

      if (updatedResponse != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated Successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          "PACKAGING & DELIVERY",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Time Input
              _buildInputRow(
                "Delivery Time:",
                _deliveryTimeController,
                "Enter Value",
                "Minutes",
              ),
              SizedBox(height: 10),
              // Delivery Radius Input
              _buildInputRow(
                "Delivery Radius:",
                _deliveryRadiusController,
                "Enter Value",
                "KM",
              ),
              SizedBox(height: 10),
              // Free Delivery Radius Input
              _buildInputRow(
                "Free Delivery Radius:",
                _freeDeliveryRadiusController,
                "Enter Value",
                "KM",
              ),
              SizedBox(height: 15),
              // Order Value Wise
              Text(
                "Order Value(OV) Wise:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildInputRow(
                "OV ₹ ≥ 500",
                _orderValueAbove500Controller,
                "0",
              ),
              SizedBox(height: 10),
              _buildInputRow(
                "OV ₹ < 500",
                _orderValueBelow500Controller,
                "Enter Price in ₹",
              ),
              SizedBox(height: 35),
              Center(
                child: Container(
                  width: 280,
                  child: ElevatedButton(
                    onPressed: updatePackagingAndDelivery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 214, 19, 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for text fields
  Widget _buildInputRow(
      String label,
      TextEditingController controller,
      String hintText, [
        String? unit,
      ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: hintText,
                ),
              ),
            ),
            SizedBox(width: 10),
            unit != null
                ? Expanded(
                    flex: 2,
                    child: Container(
                      height: 60,
                      child: Center(
                        child: Text(
                          unit,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
