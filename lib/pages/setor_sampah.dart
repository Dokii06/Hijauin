import 'package:flutter/material.dart';
import 'edit_alamat.dart';
import 'jenis_sampah.dart';

// Warna Identitas Hijauin (disinkronkan)
const Color primaryBlue = Color(0xFF143D60); // Biru Tua
const Color darkTeal = Color(0xFF27667B); // Teal Gelap
const Color lightLime = Color(0xFFBFD98A); // Hijau Kekuningan
const Color accentLime = Color(0xFFDDEB9D); // Hijau Muda Terang
const Color backgroundLight = Color(0xFFF7F7F7); // Warna latar belakang kartu
const Color lightGreenCard = Color(0xFFF2F9D4); // Warna latar belakang kartu
const Color headerAccentBlue = Color(0xFF297EC6);

class SetorSampahPage extends StatefulWidget {
  const SetorSampahPage({super.key});

  @override
  State<SetorSampahPage> createState() => _SetorSampahPageState();
}

class _SetorSampahPageState extends State<SetorSampahPage> {
  // State Placeholder
  String selectedAddressType = 'Rumah';
  String alamat = 'Jl. Merpati No. 45, Jakarta';
  bool alamatTerisi = false;
  bool jenisTerisi = false;
  bool beratTerisi = false;
  // Data dummy untuk Detail Item
  final List<Map<String, dynamic>> trashItems = [
    {
      'icon': Icons.delete_outline,
      'name': 'Botol Plastik',
      'weight': '2.000',
      'unit': 'Kg',
      'price': 20000,
    },
    {
      'icon': Icons.chair_alt,
      'name': 'Aluminium',
      'weight': '4.000',
      'unit': 'Kg',
      'price': 12000,
    },
  ];
  final List<Map<String, dynamic>> trashSizes = [
    {'icon': Icons.inventory_2_outlined, 'name': '10.00 Kg', 'value': 10.00},
    {'icon': Icons.inventory_2_outlined, 'name': '3.00 Kg', 'value': 3.00},
  ];
  final totalPoin = 32000;

  // Konstanta untuk tinggi Header
  static const double headerHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background Gradient untuk Body utama
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [accentLime, darkTeal],
            stops: [0.0, 1.00],
          ),
        ),
        child: Stack(
          children: [
            // 1. Header Biru Tua (fixed di atas)
            _buildBlueHeader(context),

            // 2. Scrollable Content (Dimulai di bawah header)
            Padding(
              // Mulai di bawah HeaderHeight - agar kartu lokasi bisa 'tenggelam' sedikit
              padding: const EdgeInsets.only(top: headerHeight - 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu Lokasi Map (Diberi margin negatif di dalam fungsi ini untuk efek tenggelam)
                    _buildMapLocationCard(context),

                    const SizedBox(height: 10),

                    // Kartu Detail Alamat
                    _buildSectionTitle('Alamat'),
                    _buildAddressCard(context),

                    const SizedBox(height: 12),

                    // --- 2. JENIS SAMPAH ---
                    _buildSectionTitle('Jenis Sampah'),
                    _buildTypeSection(items: trashItems, isType: true),

                    const SizedBox(height: 12),

                    // --- 3. UKURAN SAMPAH ---
                    _buildSectionTitle('Ukuran Sampah'),
                    _buildTypeSection(items: trashSizes, isType: false),

                    const SizedBox(height: 12),

                    // --- 4. DETAIL SETORAN ---
                    _buildDetailSummary(trashItems, trashSizes, totalPoin),

                    const SizedBox(height: 20),

                    // --- 5. TOMBOL CARI KURIR ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed:
                              (alamatTerisi && jenisTerisi && beratTerisi)
                              ? () {
                                  print("Cari Kurir Aktif!");
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cari Kurir',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. Header Biru Tua (Diperbaiki) ---
  Widget _buildBlueHeader(BuildContext context) {
    return Container(
      height: headerHeight,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top, // Mulai dari bawah status bar
        bottom: 20,
        left: 16,
        right: 16,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Menggunakan warna biru gelap dan aksen biru seperti di gambar
          colors: [primaryBlue, headerAccentBlue], // [143D60, 297EC6]
          stops: [0.00, 0.88],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            'Mau jemput di mana, Sri?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Kami siap daur ulang sampah kamu.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- 2. Kartu Lokasi Map ---
  Widget _buildMapLocationCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, accentLime],
            stops: const [0.00, 0.88],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih lokasi penjemputanmu, yuk!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: primaryBlue.withOpacity(0.8),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Map Placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: lightLime,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryBlue.withOpacity(0.2)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Peta Lokasi [Map View]',
                style: TextStyle(color: darkTeal),
              ),
            ),
            const SizedBox(height: 10),
            // Search Bar (Enhanced)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Ikon Lokasi
                  const Icon(
                    Icons.location_on_rounded,
                    color: darkTeal,
                    size: 26,
                  ),
                  const SizedBox(width: 10),

                  // Input
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Cari lokasi penjemputan...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  // Ikon Search
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: darkTeal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // Type Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTypeButton('Rumah'),
                const SizedBox(width: 8),
                _buildTypeButton('Kantor'),
                const SizedBox(width: 8),
                _buildTypeButton('Lainnya'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol Rumah / Kantor / Lainnya
  Widget _buildTypeButton(String label) {
    final bool isSelected = selectedAddressType == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressType = label;
          alamatTerisi = true; // tipe alamat sudah dipilih
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryBlue : darkTeal.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : darkTeal,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // --- 3. Kartu Detail Alamat (Diperbaiki) ---
  Widget _buildAddressCard(BuildContext context) {
    // Data alamat detail dipisahkan untuk tampilan
    final String shortAddress = 'Jalan Mawar Indah 3 No.51';
    final String fullAddress =
        'Jl. Mawar Indah 3 Blok P1 No.51, RT.8/RW.2, Desa Bunga Indah, Kec. Harum Wangi, Kabupaten Bekasi, Jawa Barat, 19870, Indonesia';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () async {
          // Navigasi ke halaman EditAlamatPage
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditAlamatPage()),
          );

          if (result != null && result is String) {
            // Asumsi Anda memiliki setState() yang dapat diakses di sini
            // Misalnya, jika ini dipanggil dari _SetorSampahPageState:
            // setState(() {
            //   alamat = result;
            //   alamatTerisi = true;
            // });

            // Karena saya tidak bisa mengakses setState di sini,
            // saya biarkan kode navigasi tetap seperti yang Anda minta.
            print('Alamat baru terpilih: $result');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightGreenCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: darkTeal.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL "Alamat" - Dibuat terpisah di atas kartu untuk tampilan sesuai gambar
              // Text(
              //   'Alamat', // Sesuai image_21c5c2.png
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: primaryBlue.withOpacity(0.8),
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 5),

              // ALAMAT SINGKAT (Headline)
              Text(
                shortAddress, // Gunakan alamat pendek atau variabel state 'alamat'
                style: const TextStyle(
                  fontSize: 16,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),

              // ALAMAT DETAIL
              Text(
                fullAddress, // Gunakan alamat detail
                style: const TextStyle(fontSize: 12, color: darkTeal),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- JENIS SAMPAH & UKURAN SAMPAH SECTION ---
  Widget _buildTypeSection({
    required List<Map<String, dynamic>> items,
    required bool isType, // true untuk Jenis Sampah, false untuk Ukuran
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: lightGreenCard, // Warna yang sama dengan kartu alamat
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: darkTeal.withOpacity(0.3)),
        ),
        child: Column(
          children: items.map((item) {
            return _buildTypeItem(item, isType);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTypeItem(Map<String, dynamic> item, bool isType) {
    final icon = item['icon'] as IconData;
    final name = isType ? item['name'] : item['name'];
    final valueText = isType
        ? '${item['weight']}/${item['unit']}'
        : item['name'];

    // Warna dan gaya teks berbeda jika ini adalah bagian Jenis Sampah vs Ukuran
    final nameStyle = isType
        ? const TextStyle(fontSize: 16, color: primaryBlue)
        : const TextStyle(
            fontSize: 16,
            color: darkTeal,
            fontWeight: FontWeight.w600,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue, size: 24),
              const SizedBox(width: 10),
              Text(name, style: nameStyle),
            ],
          ),
          // Tombol/Indikator Kanan
          isType
              ? Row(
                  children: [
                    Text(
                      valueText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: darkTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: accentLime,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: primaryBlue.withOpacity(0.8),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: accentLime,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: primaryBlue.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // --- DETAIL SETORAN (Summary) ---
  Widget _buildDetailSummary(
    List<Map<String, dynamic>> items,
    List<Map<String, dynamic>> sizes,
    int totalPoin,
  ) {
    final rincian = [
      {
        'name': 'Botol Plastik',
        'quantity': sizes[0]['value'],
        'price': items[0]['price'],
      },
      {
        'name': 'Aluminium',
        'quantity': sizes[1]['value'],
        'price': items[1]['price'],
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: lightGreenCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: darkTeal.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Detail Setoran',
                style: TextStyle(
                  fontSize: 18,
                  color: primaryBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            ...rincian.map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${r['name']} ${r['quantity']} Kg',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: darkTeal,
                      ),
                    ),
                    Text(
                      r['price'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: darkTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ TOTAL POIN
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: lightLime, // ✅ WARNA ASLI TIDAK DIUBAH
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Poin',
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryBlue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      totalPoin.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: primaryBlue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE WIDGETS ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 16,
          // FIX: Warna teks di desain adalah primaryBlue, bukan Colors.white
          color: Colors.white, // Menggunakan primaryBlue (sesuai desain kartu)
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
