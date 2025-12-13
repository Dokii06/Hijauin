import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijauin/main.dart';
import 'package:hijauin/pages/education_page.dart';
import 'package:hijauin/pages/setor_sampah.dart';
import 'chat_page.dart';
import 'widget/new_carousel.dart';

// Warna Identitas Hijauin (disinkronkan dari file-file sebelumnya)
const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color lightYellow = Color(0xFFF2F9D4);
const Color accentLime = Color(0xFFDDEB9D);
const Color darkGreen = Color(0xFFA0C878);
const Color cardGreen = Color(0xFFC8E6C9);

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===================== APPBAR =====================
      appBar: AppBar(
        backgroundColor: const Color(0xFF143D60),
        elevation: 0,
        title: const Text(
          "Hijauin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Background Gradient untuk halaman (seperti di desain)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Gradient ringan dari hijau terang ke hijau gelap
            colors: [lightLime, darkTeal],
            stops: [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ruang untuk status bar
              SizedBox(height: MediaQuery.of(context).padding.top),

              // ========================= 1. CUSTOM APP BAR =========================
              _buildCustomAppBar(),

              // ========================= 2. WIDGET UTAMA (MAIN CONTENT) =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu Ringkasan Sampah
                    _buildRecycleSummaryCard(context),

                    const SizedBox(height: 10),

                    // Berita Terkini
                    _buildSectionTitle(context, 'Berita terkini'),
                    const SizedBox(height: 10),
                    _buildNewsCarousel(),

                    const SizedBox(height: 20),

                    // Tips untuk Anda
                    _buildTipsCard(context),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 30), // Padding bawah
            ],
          ),
        ),
      ),
    );
  }

  //Custom AppBar
  Widget _buildCustomAppBar() {
    // Dummy data sementara
    String userName = "Sri Novellaputri Ramadhany";
    int userPoints = 12000;

    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== Row 1: Halo, Selamat datang ====================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: accentLime,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'Halo, Selamat datang!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF143D60),
              ),
            ),
          ),

          // ==================== Row 2: Username + Poin ====================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- Kiri: Foto, Nama, Pesan ---
                Row(
                  children: [
                    // Foto Profil
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: primaryBlue,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Nama & Pesan
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Yuk, lengkapi profil kamu!',
                          style: TextStyle(color: darkTeal, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),

                // --- Kanan: Poin ---
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.coins, color: darkGreen, size: 28),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$userPoints",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: primaryBlue,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Poin',
                              style: TextStyle(fontSize: 12, color: darkTeal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. KARTU RINGKASAN DAUR ULANG ---
  Widget _buildRecycleSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Gradient ringan dari hijau terang ke hijau gelap
          colors: [Color(0xFFDDEB9D), Color(0xFFA0C878)],
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Sampah Ter-Daur Ulang',
                style: TextStyle(
                  fontSize: 18,
                  color: primaryBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Terimakasih melakukan daur ulang! Kami siap \nmenjemput sampah kamu.',
                style: TextStyle(fontSize: 12, color: darkTeal),
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  // 1. Teks untuk Outline (Stroke)
                  Text(
                    '8.3 Kg',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      // Menggunakan Paint untuk stroke
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth =
                            2.5 // Ketebalan outline
                        ..color = Color(0xFF505050), // Warna outline (Biru Tua)
                    ),
                  ),

                  // 2. Teks untuk Isi (Fill)
                  const Text(
                    '8.3 Kg',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: lightYellow, // Warna isi (Kuning Muda)
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tombol Setor
          SizedBox(
            height: 60,
            width: 80,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainWrapper(initialIndex: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
                elevation: 4,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recycling, color: Colors.white, size: 24),
                  SizedBox(height: 4),
                  Text(
                    'Setor',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. BERITA TERKINI (CAROUSEL) ---
  Widget _buildNewsCarousel() {
    // Cukup panggil widget stateful yang sudah kita buat
    return const NewsCarousel();
  }

  // --- 4. KARTU TIPS UNTUK ANDA ---
  Widget _buildTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        // Gradient di atas kartu tips (terlihat di desain)
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Gradient ringan dari hijau terang ke hijau gelap
          colors: [Color(0xFFDDEB9D), Color(0xFFA0C878)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips untuk Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sampah anorganik bisa merusak lingkungan. Yuk, pahami mengapa daur ulang adalah solusi terbaik!',
                  style: TextStyle(fontSize: 14, color: darkTeal),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          // Tombol Lihat
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EducationPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Lihat', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Section Title Helper ---
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    );
  }
}
