import 'package:flutter_test/flutter_test.dart';
import 'package:usedev_uninassau/main.dart';

void main() {
  testWidgets('mostra vitrine principal da UseDev', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Abridor de Garrafa'), findsOneWidget);
    expect(find.text('Camiseta Capivara'), findsOneWidget);
    expect(find.text('Adicionar ao carrinho'), findsWidgets);
  });
}
