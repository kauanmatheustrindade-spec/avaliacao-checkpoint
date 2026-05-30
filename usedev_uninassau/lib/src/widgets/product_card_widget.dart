import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    required this.nome,
    required this.url,
    required this.preco,
    super.key,
  });

  final String nome;
  final String url;
  final String preco;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: .all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Image.network(url, height: 200, width: double.infinity, fit: .cover),
          Padding(
            padding: .symmetric(horizontal: 15, vertical: 10),
            child: Text(
              nome,
              style: TextStyle(
                fontSize: 25,
                fontWeight: .bold,
                fontFamily: GoogleFonts.orbitron().fontFamily,
              ),
            ),
          ),
          Padding(
            padding: .symmetric(horizontal: 15, vertical: 10),
            child: Text(
              preco,
              style: TextStyle(
                fontSize: 31,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
