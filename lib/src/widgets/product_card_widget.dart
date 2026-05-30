import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    required this.nome,
    required this.url,
    required this.preco,
    required this.descricao,
    required this.onTap,
    required this.onAddToCart,
    super.key,
  });

  final String nome;
  final String url;
  final String preco;
  final String descricao;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final titleFont = GoogleFonts.orbitron().fontFamily;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAFF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: Image.asset(url, fit: BoxFit.contain)),
              const SizedBox(height: 14),
              Text(
                nome,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF251D33),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: titleFont,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                descricao,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF251D33).withValues(alpha: .65),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                preco,
                style: TextStyle(
                  color: const Color(0xFF251D33),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: titleFont,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Adicionar ao carrinho'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A10E8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  textStyle: GoogleFonts.orbitron(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
