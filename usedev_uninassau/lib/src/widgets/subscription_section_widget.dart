import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionSectionWidget extends StatelessWidget {
  const SubscriptionSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Color(0xFF8FFF24)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            Text(
              'Inscreva-se para ganhar descontos!',
              textAlign: .center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
                fontFamily: GoogleFonts.orbitron().fontFamily,
              ),
            ),
            Text(
              'Cadastre seu email, receba novidades e descontos imperdíveis antes de todo mundo!',
              textAlign: .center,
              style: TextStyle(
                fontSize: 18,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            TextField(
              keyboardType: .emailAddress,
              decoration: InputDecoration(
                hintText: 'Digite seu melhor endereço de email',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF780BF7),
                padding: .symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text(
                'Inscrever',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: .bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
