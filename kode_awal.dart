import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NamaMenu(),
    );
  }
}

class NamaMenu extends StatefulWidget {
  const NamaMenu({super.key});

  @override
  State<NamaMenu> createState() => _MenuPageState();
}

class _MenuPageState extends State<NamaMenu> {
  int jumlahPesan = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Resto Rafa - Absen 25'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fastfood, size: 60, color: Colors.orange),
                  const SizedBox(height: 8),
                  const Text(
                    'Nasi Goreng (Rafa)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Absen 25 - Rp 15.000',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: jumlahPesan > 0
                            ? () {
                                setState(() {
                                  if (jumlahPesan > 0) {
                                    jumlahPesan--;
                                  }
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        tooltip: 'Kurangi pesanan',
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            jumlahPesan++;
                          });
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        label: const Text('Tambah Pesanan'),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 0, 0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'BEST SELLER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$jumlahPesan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
}
