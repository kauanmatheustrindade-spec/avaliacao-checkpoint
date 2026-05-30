import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/widgets/hero_section_widget.dart';
import 'package:usedev_uninassau/src/widgets/product_card_widget.dart';

const _primaryPurple = Color(0xFF8A10E8);
const _softBackground = Color(0xFFF8F0FB);
const _textColor = Color(0xFF251D33);

class Product {
  const Product({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
  });

  final String name;
  final String description;
  final String imageAsset;
  final double price;
}

class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get total => product.price * quantity;
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final List<Product> _products = const [
    Product(
      name: 'Abridor de Garrafa',
      description:
          'Abridor de garrafas pratico e compacto, perfeito para guardar na cozinha ou escritorio.',
      imageAsset: 'assets/products/abridor_garrafa.png',
      price: 12,
    ),
    Product(
      name: 'Camiseta Capivara',
      description: 'Camiseta roxa geek com estampa divertida de capivara.',
      imageAsset: 'assets/products/camiseta_capivara.png',
      price: 59,
    ),
    Product(
      name: 'Mousepad Cafe e Codigo',
      description: 'Mousepad grande para deixar o setup mais confortavel.',
      imageAsset: 'assets/products/mousepad_cafe_codigo.png',
      price: 35,
    ),
    Product(
      name: 'Caneca Never Bug',
      description: 'Caneca preta para acompanhar cafe, codigo e foco.',
      imageAsset: 'assets/products/caneca_never_bug.png',
      price: 32,
    ),
    Product(
      name: 'Bone 404',
      description: 'Bone preto com detalhe 404 para completar o visual dev.',
      imageAsset: 'assets/products/bone_404.png',
      price: 45,
    ),
    Product(
      name: 'Quadro While Alive',
      description: 'Quadro decorativo com codigo para mesa ou parede.',
      imageAsset: 'assets/products/quadro_while_alive.png',
      price: 42,
    ),
    Product(
      name: 'Copo do Programador',
      description: 'Copo termico com humor de programador para o dia a dia.',
      imageAsset: 'assets/products/copo_programador.png',
      price: 49,
    ),
    Product(
      name: 'Camiseta Estagios do Programador',
      description: 'Camiseta preta com arte dos estagios do programador.',
      imageAsset: 'assets/products/camiseta_estagios_programador.png',
      price: 59,
    ),
  ];

  final List<CartItem> _cart = [];
  bool _isLoggedIn = false;
  String _paymentMethod = 'Pix';

  String _formatPrice(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  int get _cartCount {
    return _cart.fold(0, (total, item) => total + item.quantity);
  }

  double get _cartTotal {
    return _cart.fold(0, (total, item) => total + item.total);
  }

  Future<bool> _ensureLogin() async {
    if (_isLoggedIn) {
      return true;
    }

    final logged = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (context) => const LoginScreen()));

    if (logged == true) {
      setState(() => _isLoggedIn = true);
      return true;
    }

    return false;
  }

  Future<void> _addToCart(Product product) async {
    final canContinue = await _ensureLogin();
    if (!canContinue) {
      return;
    }

    if (!mounted) {
      return;
    }

    final quantity = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (context) =>
            QuantityScreen(product: product, formatPrice: _formatPrice),
      ),
    );

    if (quantity == null || quantity <= 0) {
      return;
    }

    setState(() {
      final index = _cart.indexWhere(
        (item) => item.product.name == product.name,
      );
      if (index == -1) {
        _cart.add(CartItem(product: product, quantity: quantity));
      } else {
        _cart[index].quantity += quantity;
      }
    });

    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cart: _cart,
          formatPrice: _formatPrice,
          onChanged: () => setState(() {}),
          onCheckout: _openPaymentScreen,
        ),
      ),
    );
  }

  Future<void> _openProductDetails(Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          product: product,
          cartCount: _cartCount,
          formatPrice: _formatPrice,
          onAddToCart: () => _addToCart(product),
          onOpenCart: _openCart,
        ),
      ),
    );
  }

  Future<void> _openCart() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cart: _cart,
          formatPrice: _formatPrice,
          onChanged: () => setState(() {}),
          onCheckout: _openPaymentScreen,
        ),
      ),
    );
  }

  Future<void> _openPaymentScreen() async {
    final canContinue = await _ensureLogin();
    if (!canContinue || !mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          total: _cartTotal,
          paymentMethod: _paymentMethod,
          formatPrice: _formatPrice,
          onPaymentChanged: (value) => setState(() => _paymentMethod = value),
          onConfirm: () {
            setState(() => _cart.clear());
            Navigator.of(context).popUntil((route) => route.isFirst);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Compra finalizada com $_paymentMethod!')),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({bool showBack = false}) {
    return AppBar(
      backgroundColor: _softBackground,
      elevation: 0,
      foregroundColor: _textColor,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 30),
              onPressed: () => Navigator.pop(context),
            )
          : const Icon(Icons.menu, size: 34),
      title: Image.asset('assets/logo_usedev.png', height: 40),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isLoggedIn ? Icons.person : Icons.person_outline,
            size: 31,
          ),
          onPressed: () async {
            final logged = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            if (logged == true) {
              setState(() => _isLoggedIn = true);
            }
          },
        ),
        Badge(
          isLabelVisible: _cartCount > 0,
          label: Text(_cartCount.toString()),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 31),
            onPressed: _openCart,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _softBackground,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: HeroSectionWidget()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 10),
              child: Text(
                'Promos Especiais',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 420,
                mainAxisExtent: 420,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCardWidget(
                  nome: product.name,
                  url: product.imageAsset,
                  preco: _formatPrice(product.price),
                  descricao: product.description,
                  onTap: () => _openProductDetails(product),
                  onAddToCart: () => _addToCart(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    required this.product,
    required this.cartCount,
    required this.formatPrice,
    required this.onAddToCart,
    required this.onOpenCart,
    super.key,
  });

  final Product product;
  final int cartCount;
  final String Function(double value) formatPrice;
  final VoidCallback onAddToCart;
  final VoidCallback onOpenCart;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: _textColor,
      fontFamily: GoogleFonts.orbitron().fontFamily,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: _softBackground,
      appBar: AppBar(
        backgroundColor: _softBackground,
        elevation: 0,
        foregroundColor: _textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/logo_usedev.png', height: 40),
        centerTitle: true,
        actions: [
          const Icon(Icons.person_outline, size: 31),
          const SizedBox(width: 12),
          Badge(
            isLabelVisible: cartCount > 0,
            label: Text(cartCount.toString()),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 31),
              onPressed: onOpenCart,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(product.imageAsset, fit: BoxFit.contain),
                ),
              ),
              Text(product.name, style: titleStyle.copyWith(fontSize: 22)),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: GoogleFonts.poppins(
                  color: _textColor.withValues(alpha: .72),
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                formatPrice(product.price),
                style: titleStyle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Adicionar ao carrinho'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  textStyle: GoogleFonts.orbitron(
                    fontSize: 15,
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

class QuantityScreen extends StatefulWidget {
  const QuantityScreen({
    required this.product,
    required this.formatPrice,
    super.key,
  });

  final Product product;
  final String Function(double value) formatPrice;

  @override
  State<QuantityScreen> createState() => _QuantityScreenState();
}

class _QuantityScreenState extends State<QuantityScreen> {
  int _quantity = 1;

  TextStyle get _titleStyle => TextStyle(
    color: _textColor,
    fontFamily: GoogleFonts.orbitron().fontFamily,
    fontWeight: FontWeight.w700,
  );

  void _changeQuantity(int value) {
    setState(() {
      _quantity = (_quantity + value).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.product.price * _quantity;

    return Scaffold(
      backgroundColor: _softBackground,
      appBar: AppBar(
        backgroundColor: _softBackground,
        elevation: 0,
        foregroundColor: _textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/logo_usedev.png', height: 40),
        centerTitle: true,
        actions: const [
          Icon(Icons.person_outline, size: 31),
          SizedBox(width: 18),
          Icon(Icons.shopping_cart_outlined, size: 31),
          SizedBox(width: 18),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    widget.product.imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                widget.product.name,
                style: _titleStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                widget.formatPrice(widget.product.price),
                style: _titleStyle.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _changeQuantity(-1),
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    _quantity.toString(),
                    style: GoogleFonts.poppins(
                      color: _textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _changeQuantity(1),
                    icon: const Icon(Icons.add),
                  ),
                  const Spacer(),
                  Text(
                    'Total: ${widget.formatPrice(total)}',
                    style: _titleStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, _quantity),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Adicionar ao carrinho'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  textStyle: GoogleFonts.orbitron(
                    fontSize: 15,
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

class CartScreen extends StatefulWidget {
  const CartScreen({
    required this.cart,
    required this.formatPrice,
    required this.onChanged,
    required this.onCheckout,
    super.key,
  });

  final List<CartItem> cart;
  final String Function(double value) formatPrice;
  final VoidCallback onChanged;
  final VoidCallback onCheckout;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get _total {
    return widget.cart.fold(0, (total, item) => total + item.total);
  }

  TextStyle get _titleStyle => TextStyle(
    color: _textColor,
    fontFamily: GoogleFonts.orbitron().fontFamily,
    fontWeight: FontWeight.w700,
  );

  void _changeQuantity(CartItem item, int delta) {
    setState(() {
      item.quantity += delta;
      if (item.quantity <= 0) {
        widget.cart.remove(item);
      }
    });
    widget.onChanged();
  }

  void _remove(CartItem item) {
    setState(() => widget.cart.remove(item));
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _softBackground,
      appBar: AppBar(
        backgroundColor: _softBackground,
        elevation: 0,
        foregroundColor: _textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/logo_usedev.png', height: 40),
        centerTitle: true,
        actions: const [
          Icon(Icons.person_outline, size: 31),
          SizedBox(width: 18),
          Icon(Icons.shopping_cart_outlined, size: 31),
          SizedBox(width: 18),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 12, 26, 24),
          child: Column(
            children: [
              Expanded(
                child: widget.cart.isEmpty
                    ? Center(
                        child: Text(
                          'Seu carrinho esta vazio.',
                          style: _titleStyle.copyWith(fontSize: 18),
                        ),
                      )
                    : ListView.separated(
                        itemCount: widget.cart.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 26),
                        itemBuilder: (context, index) {
                          final item = widget.cart[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                item.product.imageAsset,
                                width: 140,
                                height: 118,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: _titleStyle.copyWith(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.formatPrice(item.product.price),
                                      style: _titleStyle.copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _changeQuantity(item, -1),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(
                                          item.quantity.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: _textColor,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _changeQuantity(item, 1),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _remove(item),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xFFE53B64),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              Row(
                children: [
                  const Icon(Icons.shopping_bag, color: _primaryPurple),
                  const SizedBox(width: 8),
                  Text('Total:', style: _titleStyle.copyWith(fontSize: 18)),
                  const Spacer(),
                  Text(
                    widget.formatPrice(_total),
                    style: _titleStyle.copyWith(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.cart.isEmpty ? null : widget.onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  textStyle: GoogleFonts.orbitron(fontWeight: FontWeight.w700),
                ),
                child: const Text('Finalizar Compra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: _primaryPurple,
      fontFamily: GoogleFonts.orbitron().fontFamily,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: _softBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/logo_usedev.png', height: 112),
                  const SizedBox(height: 20),
                  Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: titleStyle.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 34),
                  TextFormField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      hintText: 'Usuario',
                      prefixIcon: Icon(Icons.person_outline),
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o usuario';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return 'Informe a senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      textStyle: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text('ENTRAR'),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Esqueceu a senha?',
                      style: GoogleFonts.poppins(color: _textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    required this.total,
    required this.paymentMethod,
    required this.formatPrice,
    required this.onPaymentChanged,
    required this.onConfirm,
    super.key,
  });

  final double total;
  final String paymentMethod;
  final String Function(double value) formatPrice;
  final ValueChanged<String> onPaymentChanged;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: _textColor,
      fontFamily: GoogleFonts.orbitron().fontFamily,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: _softBackground,
      appBar: AppBar(
        backgroundColor: _softBackground,
        elevation: 0,
        foregroundColor: _textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/logo_usedev.png', height: 40),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Pagamento', style: titleStyle.copyWith(fontSize: 24)),
              const SizedBox(height: 10),
              Text(
                'Total: ${formatPrice(total)}',
                style: GoogleFonts.poppins(fontSize: 16, color: _textColor),
              ),
              const SizedBox(height: 24),
              RadioGroup<String>(
                groupValue: paymentMethod,
                onChanged: (value) {
                  if (value != null) {
                    onPaymentChanged(value);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Pix',
                      title: Text('Pix'),
                      secondary: Icon(Icons.qr_code_2),
                    ),
                    RadioListTile<String>(
                      value: 'Cartao de credito',
                      title: Text('Cartao de credito'),
                      secondary: Icon(Icons.credit_card),
                    ),
                    RadioListTile<String>(
                      value: 'Cartao de debito',
                      title: Text('Cartao de debito'),
                      secondary: Icon(Icons.payment),
                    ),
                    RadioListTile<String>(
                      value: 'Boleto',
                      title: Text('Boleto'),
                      secondary: Icon(Icons.receipt_long),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  textStyle: GoogleFonts.orbitron(fontWeight: FontWeight.w700),
                ),
                child: const Text('Confirmar pagamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
