import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ivy Resto App',
      theme: ThemeData(
        fontFamily: '.SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        primaryColor: const Color(0xFFDA291C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F9FB),
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

// ==========================================
// AUTH SCREEN
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _submit() {
    if (_emailController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => MainScreen(
            email: _emailController.text,
            name: isLogin
                ? "Lia"
                : _nameController.text.isEmpty
                ? "Lia"
                : _nameController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  CupertinoIcons.flame_fill,
                  size: 60,
                  color: Color(0xFFDA291C),
                ),
                const SizedBox(height: 30),
                Text(
                  isLogin ? 'Sign In.' : 'Create\nAccount.',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 40),
                if (!isLogin) ...[
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Full Name',
                  ),
                  const SizedBox(height: 15),
                ],
                _buildTextField(
                  controller: _emailController,
                  hint: 'Email Address',
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _passwordController,
                  hint: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDA291C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      isLogin ? 'Sign In' : 'Continue',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Sign In",
                      style: const TextStyle(
                        color: Color(0xFFDA291C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MAIN SCREEN
// ==========================================
class MainScreen extends StatefulWidget {
  final String email;
  final String name;
  const MainScreen({super.key, required this.email, required this.name});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Map<String, int> _cart = {};
  bool _voucherAktif = false;

  XFile? _profileImage;
  XFile? _studentCardImage;
  final ImagePicker _picker = ImagePicker();

  String _alamatPengiriman = "St. Sunset Road, Seminyak, Bali";
  String _kategoriAktif = 'Burgers';
  late String _userName;
  String _currency = 'USD';
  final int _usdRate = 15000;

  @override
  void initState() {
    super.initState();
    _userName = widget.name;
  }

  final List<Map<String, dynamic>> _menuMakanan = [
    {
      'nama': 'Double Patty Burger',
      'hargaIdr': 300000,
      'deskripsi':
          'Delicious, juicy, cheesy, double-layered. A delicious burger with two layers of grilled beef patty, arranged on a soft sesame-studded bun. Perfect for true burger lovers!',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=60',
      'kategori': 'Burgers',
    },
    {
      'nama': 'Cheeseburger',
      'hargaIdr': 345000,
      'deskripsi': 'Delicious, juicy, cheesy. Topped with special sauce.',
      'image':
          'https://images.unsplash.com/photo-1586816001966-79b736744398?auto=format&fit=crop&w=500&q=60',
      'kategori': 'Burgers',
    },
    {
      'nama': 'Grilled Chicken Burger',
      'hargaIdr': 420000,
      'deskripsi': 'Delicious, juicy, cheesy, chicken-layered.',
      'image':
          'https://images.unsplash.com/photo-1606755962773-d324e0a13086?auto=format&fit=crop&w=500&q=60',
      'kategori': 'Burgers',
    },
    {
      'nama': 'French Fries',
      'hargaIdr': 75000,
      'deskripsi': 'Crispy golden fries.',
      'image':
          'https://images.unsplash.com/photo-1576107232684-1279f390859f?auto=format&fit=crop&w=500&q=60',
      'kategori': 'Snacks & Sides',
    },
  ];

  String _formatPrice(int hargaIdr) {
    if (_currency == 'USD') {
      double priceUsd = hargaIdr / _usdRate;
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
      ).format(priceUsd);
    } else {
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(hargaIdr);
    }
  }

  void _tambahKeCart(Map<String, dynamic> item) {
    setState(() => _cart[item['nama']] = (_cart[item['nama']] ?? 0) + 1);
  }

  void _kurangiCart(String nama) {
    setState(() {
      if (_cart.containsKey(nama)) {
        if (_cart[nama]! > 1) {
          _cart[nama] = _cart[nama]! - 1;
        } else {
          _cart.remove(nama);
        }
      }
    });
  }

  Future<void> _pickImage(bool isStudentCard) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          if (isStudentCard) {
            _studentCardImage = pickedFile;
          } else {
            _profileImage = pickedFile;
          }
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil gambar: $e");
    }
  }

  void _editName() {
    TextEditingController editController = TextEditingController(
      text: _userName,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: "Enter your name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _userName = editController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  int get _subtotalIdr {
    int sum = 0;
    _cart.forEach((nama, jumlah) {
      final item = _menuMakanan.firstWhere((e) => e['nama'] == nama);
      sum += (item['hargaIdr'] as int) * jumlah;
    });
    return sum;
  }

  void _bukaPeta() async {
    final alamatTerpilih = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const MapPickerScreen()),
    );
    if (alamatTerpilih != null)
      setState(() => _alamatPengiriman = alamatTerpilih);
  }

  void _bukaDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DetailScreen(
          item: item,
          formatPrice: _formatPrice,
          onAddToCart: () {
            _tambahKeCart(item);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      _buildCartTab(),
      const Center(child: Text("Promo Page")),
      _buildProfileTab(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFFDA291C),
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled, size: 28),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart_fill, size: 28),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.ticket_fill, size: 28),
                label: 'Promo',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_solid, size: 28),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(CupertinoIcons.bell, size: 28),
              GestureDetector(
                onTap: _bukaPeta,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDA291C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'Bali, Indonesia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 3),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _profileImage != null
                      ? (kIsWeb
                                ? NetworkImage(_profileImage!.path)
                                : FileImage(File(_profileImage!.path)))
                            as ImageProvider
                      : null,
                  child: _profileImage == null
                      ? const Icon(
                          CupertinoIcons.person_fill,
                          size: 20,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Text(
            'Hello, $_userName!',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            "It's time to pamper your tummy.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.black38),
                border: InputBorder.none,
                prefixIcon: Icon(CupertinoIcons.search, color: Colors.black38),
                prefixIconConstraints: BoxConstraints(minWidth: 40),
                suffixIcon: Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: Color(0xFFDA291C),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    {'name': 'Burgers', 'icon': '🍔'},
                    {'name': 'Snacks & Sides', 'icon': '🍟'},
                    {'name': 'Drinks', 'icon': '🍹'},
                  ].map((kat) {
                    bool isSel = _kategoriAktif == kat['name'];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _kategoriAktif = kat['name']!),
                      child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFDA291C) : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            if (!isSel)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              kat['icon']!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              kat['name']!,
                              style: TextStyle(
                                color: isSel ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 30),
          ..._menuMakanan.where((i) => i['kategori'] == _kategoriAktif).map((
            item,
          ) {
            return GestureDetector(
              onTap: () => _bukaDetail(item),
              child: Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        item['image'],
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nama'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['deskripsi'].toString().split('.').first + '.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatPrice(item['hargaIdr']),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    int delivCostIdr = _cart.isEmpty ? 0 : 37500;
    double multiplier = _voucherAktif && _studentCardImage != null ? 0.85 : 1.0;
    int totalAkhirIdr = (_subtotalIdr * multiplier).toInt() + delivCostIdr;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: () => setState(() => _selectedIndex = 0),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Review Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _alamatPengiriman,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _bukaPeta,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Change address',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                if (_cart.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        'Keranjang kosong',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ..._cart.entries.map((entry) {
                    final item = _menuMakanan.firstWhere(
                      (e) => e['nama'] == entry.key,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              item['image'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _formatPrice(item['hargaIdr']),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.black12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _kurangiCart(item['nama']),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFDA291C,
                                      ).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.minus,
                                      color: Color(0xFFDA291C),
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '${entry.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _tambahKeCart(item),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDA291C),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDA291C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            CupertinoIcons.ticket_fill,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Limited Offer: 15% OFF!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_studentCardImage != null) {
                            setState(() => _voucherAktif = !_voucherAktif);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Upload kartu pelajar di Profile dulu!',
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _voucherAktif ? 'Applied' : 'Use',
                            style: const TextStyle(
                              color: Color(0xFFDA291C),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'See other promo >',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),

                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatPrice(_subtotalIdr),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery cost',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatPrice(delivCostIdr),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: Colors.black12, thickness: 1.5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      _formatPrice(totalAkhirIdr),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDA291C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Buy and delivery now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Text(
            'Account',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              GestureDetector(
                onTap: () => _pickImage(false),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                    image: _profileImage != null
                        ? DecorationImage(
                            image: kIsWeb
                                ? NetworkImage(_profileImage!.path)
                                : FileImage(File(_profileImage!.path))
                                      as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _profileImage == null
                      ? const Icon(
                          CupertinoIcons.person_fill,
                          size: 40,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.pencil,
                            size: 18,
                            color: Colors.grey,
                          ),
                          onPressed: _editName,
                        ),
                      ],
                    ),
                    Text(
                      widget.email,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.money_dollar_circle_fill,
                    color: Colors.green,
                  ),
                  title: const Text(
                    'Currency',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'USD', label: Text('USD')),
                      ButtonSegment(value: 'IDR', label: Text('IDR')),
                    ],
                    selected: {_currency},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() => _currency = newSelection.first);
                    },
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 50, color: Colors.black12),
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.blueAccent),
                  title: const Text(
                    'Verifikasi Pelajar',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: _studentCardImage != null
                      ? const Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      : const Text(
                          'Upload',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  onTap: () => _pickImage(true),
                ),
                const Divider(height: 1, indent: 50, color: Colors.black12),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.square_arrow_right,
                    color: Color(0xFFDA291C),
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFFDA291C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// DETAIL SCREEN
// ==========================================
class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) formatPrice;
  final VoidCallback onAddToCart;

  const DetailScreen({
    super.key,
    required this.item,
    required this.formatPrice,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFDA291C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Hero(
                  tag: item['nama'],
                  child: Image.network(
                    item['image'],
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['nama'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFDA291C,
                                      ).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.minus,
                                      color: Color(0xFFDA291C),
                                      size: 16,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDA291C),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 5),
                            Text(
                              '4.9',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '27 Likes',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          formatPrice(item['hargaIdr']),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          item['deskripsi'],
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildIngredientIcon('🧀', Colors.yellow.shade100),
                            _buildIngredientIcon('🧅', Colors.orange.shade100),
                            _buildIngredientIcon('🥬', Colors.green.shade100),
                            _buildIngredientIcon('🍅', Colors.red.shade100),
                            _buildIngredientIcon('🥩', Colors.brown.shade100),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDA291C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              CupertinoIcons.cart_fill,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: onAddToCart,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientIcon(String emoji, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}

// ==========================================
// MAP PICKER
// ==========================================
class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});
  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-8.6838, 115.1659),
    zoom: 15,
  );
  bool _isMoving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMoveStarted: () => setState(() => _isMoving = true),
            onCameraIdle: () => setState(() => _isMoving = false),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Icon(
              CupertinoIcons.location_solid,
              size: 50,
              color: _isMoving ? Colors.black54 : const Color(0xFFDA291C),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 20),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Geser peta untuk menentukan titik lokasi yang tepat.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDA291C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => Navigator.pop(
                          context,
                          "St. Sunset Road, Seminyak, Bali",
                        ),
                        child: const Text(
                          'Pilih Lokasi Ini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
