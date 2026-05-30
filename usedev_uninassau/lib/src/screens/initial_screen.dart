import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/widgets/hero_section_widget.dart';
import 'package:usedev_uninassau/src/widgets/product_card_widget.dart';
import 'package:usedev_uninassau/src/widgets/subscription_section_widget.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu, size: 40),
        title: Image.asset('assets/logo_usedev.png', height: 40),
        centerTitle: true,
        actions: [
          Icon(Icons.person_outline, size: 40),
          SizedBox(width: 10),
          Icon(Icons.shopping_cart_outlined, size: 40),
          SizedBox(width: 25),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 20,
          crossAxisAlignment: .stretch,
          children: [
            HeroSectionWidget(),
            Text(
              'Promos Especiais',
              textAlign: .center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: .bold,
                fontFamily: GoogleFonts.orbitron().fontFamily,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) => ProductCardWidget(
                nome: 'Produto 0$index',
                url: 'https://placehold.co/600x600.png',
                preco: '10$index,00',
              ),
            ),
            SubscriptionSectionWidget(),
          ],
        ),
      ),
    );
  }
}
