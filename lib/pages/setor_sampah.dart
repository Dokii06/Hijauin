import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hijauin/config/api_config.dart';
import 'package:hijauin/services/sampah_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_alamat.dart';
import 'jenis_sampah.dart';

const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color accentLime = Color(0xFFDDEB9D);
const Color backgroundLight = Color(0xFFF7F7F7);
const Color lightGreenCard = Color(0xFFF2F9D4);
const Color headerAccentBlue = Color(0xFF297EC6);

const int POIN_PER_KG = 8;

class SetorSampahPage extends StatefulWidget {
  const SetorSampahPage({super.key});

  @override
  State<SetorSampahPage> createState() => _SetorSampahPageState();
}

class _SetorSampahPageState extends State<SetorSampahPage> {
  String? alamatUser;
  bool alamatTerisi = false;
  bool isLoadingAlamat = true;

  Map<String, dynamic>? sampahTerpilih;
  List<dynamic> sampahList = [];
  bool isLoadingSampah = true;
  bool jenisTerisi = false;
  int? selectedSampahId;

  late TextEditingController beratController;
  double beratKg = 0;
  bool beratTerisi = false;

  int hitungTotalPoin() {
    if (sampahTerpilih == null || beratKg <= 0) return 0;

    return (beratKg * POIN_PER_KG).round();
  }

  int hitungTotalHarga() {
    if (sampahTerpilih == null || beratKg <= 0) return 0;

    final hargaPerKg = sampahTerpilih!['harga_per_kg'] as int;
    return (beratKg * hargaPerKg).round();
  }

  bool get isFormValid {
    return alamatTerisi &&
        jenisTerisi &&
        beratKg > 0 &&
        alamatUser != null &&
        sampahTerpilih != null;
  }

  @override
  void initState() {
    super.initState();
    loadAlamat();
    loadSampah();
    beratController = TextEditingController(text: beratKg.toStringAsFixed(1));
  }

  @override
  void dispose() {
    beratController.dispose();
    super.dispose();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> loadAlamat() async {
    setState(() {
      isLoadingAlamat = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        alamatUser = null;
        alamatTerisi = false;
        isLoadingAlamat = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/me'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];

      setState(() {
        alamatUser = user['alamat'];
        alamatTerisi = alamatUser != null && alamatUser!.toString().isNotEmpty;
        isLoadingAlamat = false;
      });
    } else {
      setState(() {
        alamatUser = null;
        alamatTerisi = false;
        isLoadingAlamat = false;
      });
    }
  }

  Future<void> loadSampah() async {
    try {
      final data = await ApiService.getSampah();
      setState(() {
        sampahList = data;
        isLoadingSampah = false;
      });
    } catch (e) {
      isLoadingSampah = false;
      debugPrint(e.toString());
    }
  }

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
            _buildBlueHeader(context),

            Padding(
              padding: const EdgeInsets.only(top: headerHeight),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMapLocationCard(context),

                    const SizedBox(height: 15),
                    _buildAddressCard(context),

                    const SizedBox(height: 12),
                    _buildSectionTitle('Jenis Sampah'),
                    isLoadingSampah
                        ? const Center(child: CircularProgressIndicator())
                        : _buildPilihJenisSampah(context),
                    const SizedBox(height: 12),

                    // --- 3. UKURAN SAMPAH ---
                    _buildSectionTitle('Ukuran Sampah'),
                    _buildInputBerat(),
                    const SizedBox(height: 12),

                    // --- 4. DETAIL SETORAN ---
                    _buildDetailSummary(),
                    const SizedBox(height: 20),

                    // --- 5. TOMBOL CARI KURIR ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isFormValid
                              ? () async {
                                  final userId = await getUserId();

                                  if (userId == null) return;

                                  await ApiService.kirimSetoran(
                                    userId: userId,
                                    sampahId: sampahTerpilih!['id'],
                                    beratKg: beratKg,
                                    alamat: alamatUser!,
                                    totalPoin: hitungTotalPoin(),
                                    totalHarga: hitungTotalHarga(),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Setoran berhasil dikirim'),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            disabledBackgroundColor: primaryBlue.withOpacity(
                              0.4,
                            ),
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

                    const SizedBox(height: 160),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueHeader(BuildContext context) {
    return Container(
      height: headerHeight,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [primaryBlue, headerAccentBlue],
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
            'Mau jemput di mana,',
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
          ],
        ),
      ),
    );
  }

  // --- 3. Kartu Detail Alamat (Diperbaiki) ---
  Widget _buildAddressCard(BuildContext context) {
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
            setState(() {
              alamatUser = result;
              alamatTerisi = result.isNotEmpty;
            });
          }
        },
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 90),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightGreenCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: darkTeal.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alamat Penjemputan',
                style: const TextStyle(
                  fontSize: 16,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isLoadingAlamat
                    ? 'Memuat alamat...'
                    : (alamatTerisi
                          ? alamatUser!
                          : 'Belum ada alamat. Ketuk untuk menambahkan.'),
                style: const TextStyle(fontSize: 14, color: darkTeal),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPilihJenisSampah(BuildContext context) {
    final bool sudahPilih = sampahTerpilih != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JenisSampahPage()),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              sampahTerpilih = result;
              jenisTerisi = true;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightGreenCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: sudahPilih ? primaryBlue : darkTeal.withOpacity(0.3),
              width: sudahPilih ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: sudahPilih ? primaryBlue : accentLime,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: sudahPilih ? Colors.white : darkTeal,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              // TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sudahPilih
                          ? sampahTerpilih!['nama']
                          : 'Pilih jenis sampah',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: sudahPilih
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sudahPilih
                          ? 'Rp ${sampahTerpilih!['harga_per_kg']} / kg'
                          : 'Ketuk untuk memilih jenis sampah',
                      style: TextStyle(
                        fontSize: 12,
                        color: sudahPilih
                            ? darkTeal
                            : darkTeal.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // ICON KANAN
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: sudahPilih
                    ? const Icon(
                        Icons.check_circle,
                        key: ValueKey('check'),
                        color: primaryBlue,
                        size: 24,
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        key: const ValueKey('arrow'),
                        size: 18,
                        color: darkTeal.withOpacity(0.7),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBerat() {
    if (sampahTerpilih == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            // Nama sampah
            Text(
              sampahTerpilih!['nama'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Rp ${sampahTerpilih!['harga_per_kg']} / kg',
              style: const TextStyle(fontSize: 13, color: darkTeal),
            ),

            const SizedBox(height: 16),

            // INPUT BERAT
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Berat Sampah (kg)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ),

                // minus
                _buildCounterButton(
                  icon: Icons.remove,
                  onTap: () {
                    setState(() {
                      if (beratKg > 0.1) {
                        beratKg -= 0.1;
                        beratController.text = beratKg.toStringAsFixed(1);
                      }
                    });
                  },
                ),

                const SizedBox(width: 8),

                // INPUT MANUAL
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: beratController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: darkTeal.withOpacity(0.4),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed >= 0) {
                        setState(() {
                          beratKg = parsed;
                          beratTerisi = beratKg > 0;
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // plus
                _buildCounterButton(
                  icon: Icons.add,
                  onTap: () {
                    setState(() {
                      beratKg += 0.1;
                      beratController.text = beratKg.toStringAsFixed(1);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: accentLime,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: primaryBlue, size: 18),
      ),
    );
  }

  Widget _buildDetailSummary() {
    if (sampahTerpilih == null || beratKg <= 0) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            // Judul
            const Text(
              'Detail Setoran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 12),

            // Rincian sampah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sampahTerpilih!['nama']} (${beratKg.toStringAsFixed(1)} kg)',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: darkTeal,
                  ),
                ),
                Text(
                  'Rp ${sampahTerpilih!['harga_per_kg']} / kg',
                  style: const TextStyle(fontSize: 13, color: darkTeal),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === BOX HIJAU TOTAL ===
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: lightLime,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Total Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                        ),
                      ),
                      Text(
                        'Rp ${hitungTotalHarga()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Total Poin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Poin',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                        ),
                      ),
                      Text(
                        '${hitungTotalPoin()} poin',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
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
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
