import 'package:cakalaya/models/delivery.dart';
import 'package:cakalaya/models/shopmodel.dart';
import 'package:cakalaya/offers.dart';
import 'package:cakalaya/packaging_screen.dart';
import 'package:cakalaya/promotions.dart';
import 'package:cakalaya/service/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManageShopPage extends StatefulWidget {
  @override
  _ManageShopPageState createState() => _ManageShopPageState();
}

class _ManageShopPageState extends State<ManageShopPage> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController fssaiLicenseNumberController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  XFile? _selectedImage;

  final ShopService _shopService = ShopService();
  String? _currentShopId;

  @override
  void initState() {
    super.initState();
    _loadCurrentShopId();
  }

  Future<void> _loadCurrentShopId() async {
    try {
      String? shopId = await _shopService.getCurrentShopId();
      setState(() {
        _currentShopId = shopId;
      });

      if (shopId != null) {
        Shop? currentShop = await _shopService.getShop(shopId);
        if (currentShop != null) {
          shopNameController.text = currentShop.shopName ?? '';
          fssaiLicenseNumberController.text = currentShop.fssaiLicenseNumber ?? '';
          commissionController.text = currentShop.commissionPercentage?.toString() ?? '';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading current shop ID: $e')),
      );
    }
  }

  Future<void> _createShop() async {
    if (_currentShopId != null && _currentShopId!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Shop already exists with ID: $_currentShopId')),
      );
      return;
    }

    String shopName = shopNameController.text.trim();
    String fssaiLicenseNumber = fssaiLicenseNumberController.text.trim();
    double commissionPercentage = double.tryParse(commissionController.text) ?? 0.0;

    if (shopName.isEmpty || fssaiLicenseNumber.isEmpty || commissionPercentage <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly.')),
      );
      return;
    }

    Shop newShop = Shop(
      id: '',
      shopName: shopName,
      fssaiLicenseNumber: fssaiLicenseNumber,
      commissionPercentage: commissionPercentage,
      shopPhotoUrl: _selectedImage?.path ?? '',
      packagingDelivery: PackagingDelivery(
        deliveryTime: 0,
        deliveryRadius: 0,
        freeDeliveryRadius: 0,
        orderValueAbove500: 0.0,
        orderValueBelow500: 0.0,
      ),
      createAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    try {
      Shop? createdShop = await _shopService.createShop(newShop);
      if (createdShop != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shop created successfully!')),
        );
        _loadCurrentShopId();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create shop: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedFile;
    });
  }

  void _navigateToPackagingDeliveryPage() {
    if (_currentShopId != null && _currentShopId!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackagingDeliveryScreen(
            shopId: _currentShopId!,
            shopName: shopNameController.text,
            fssaiLicenseNumber: fssaiLicenseNumberController.text,
            commissionPercentage: double.tryParse(commissionController.text) ?? 0.0,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No shop found, please create one first!')),
      );
    }
  }

  void _navigateToOfferDiscountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferDiscountScreen(),
      ),
    );
  }

  void _navigateToPromotionsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromotionsScreen(),
      ),
    );
  }

  Widget _buildNavigationButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Container(
        width: 360,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(width: 8),
              Icon(
                icon,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('MANAGE SHOP'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildTextField('Shop Name:', shopNameController, 'Enter Shop Name'),
            SizedBox(height: 16),
            _buildTextField('FSSAI License Number:', fssaiLicenseNumberController, 'Enter FSSAI License Number'),
            SizedBox(height: 16),
            _buildTextField('Commission %:', commissionController, 'Enter Commission percentage', isNumeric: true),
            SizedBox(height: 16),
            Text('Add Shop Display Photo (Max 1):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            Center(
              child: Container(
                height: 50,
                width: 360,
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 22, 22, 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Add Image', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildNavigationButton(
              text: 'Go to Offer & Discount',
              icon: Icons.arrow_forward_ios,
              onPressed: _navigateToOfferDiscountPage,
            ),
            SizedBox(height: 10),
            _buildNavigationButton(
              text: 'Go to Packaging & Delivery',
              icon: Icons.arrow_forward_ios,
              onPressed: _navigateToPackagingDeliveryPage,
            ),
            SizedBox(height: 10,),
            _buildNavigationButton(
              text: 'Go to Promotions',
              icon: Icons.arrow_forward_ios,
              onPressed: _navigateToPromotionsPage,
            ),
            SizedBox(height: 20),
            Text('Note:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('1. Shop will not be visible to customers if you have no products added!'),
            Text('2. We recommend adding products at menu price to avoid items being delisted in the future!'),
            SizedBox(height: 20),
             _buildNavigationButton(
                onPressed: _createShop,
                icon: Icons.save,
                text: 'Create Shop',
            ),
          
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hintText, {bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Container(
          width: 300,
          child: TextFormField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        ),
      ],
    );
  }
}
