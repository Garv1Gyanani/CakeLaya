import 'package:cakalaya/offers.dart';
import 'package:cakalaya/packaging_screen.dart';
import 'package:cakalaya/promotions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'manage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ManageShopPage(),
      routes: {
        '/offer_discount': (context) => OfferDiscountScreen(),
        '/packaging_delivery': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          final shopId = args['shopId'];
          final shopName = args['shopName'];
          final fssaiLicenseNumber = args['fssaiLicenseNumber'];
          final commissionPercentage = args['commissionPercentage'];

          return PackagingDeliveryScreen(
            shopId: shopId,
            shopName: shopName,
            fssaiLicenseNumber: fssaiLicenseNumber,
            commissionPercentage: commissionPercentage, 
          );
        },
        '/promotions': (context) => PromotionsScreen(),
      },
    );
  }
}
