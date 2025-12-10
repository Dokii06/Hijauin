import 'package:flutter/material.dart';
import 'main.dart';
import 'auth/login_page.dart';
import 'dart:math';

// Helper untuk animasi posisi
double? lerpDouble(num a, num b, double t) {
  return a + (b - a) * t;
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Menghapus _mergeController
  late AnimationController _explodeController;
  late AnimationController _fadeTextController;

  @override
  void initState() {
    super.initState();

    // ANIMASI PERSEGI TERBANG KELUAR
    _explodeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // ANIMASI FADE-IN TEKS
    _fadeTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // JALANKAN ANIMASI BERTAHAP

    // 1. Mulai Explode segera
    Future.delayed(const Duration(milliseconds: 200), () {
      _explodeController.forward().then((_) {
        // 2. Fade-in Teks (SETELAH explode selesai)
        _fadeTextController.forward();

        // 3. Pindah ke halaman utama (setelah teks muncul sebentar)
        Future.delayed(const Duration(milliseconds: 900), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    // Menghapus _mergeController
    _explodeController.dispose();
    _fadeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna dari gambar awal yang tergelap sebagai background
    return Scaffold(
      backgroundColor: const Color(0xFF406E72), // Warna dasar yang gelap/teal
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ================== 4 PERSEGI ===================
            AnimatedBuilder(
              // Hanya mendengarkan _explodeController
              animation: _explodeController,
              builder: (context, child) {
                final screenWidth = MediaQuery.of(context).size.width;

                return SizedBox(
                  width: screenWidth,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ukuran 600 cukup besar untuk menutupi layar
                      _buildSquare(
                        -1,
                        -1,
                        600,
                        screenWidth,
                      ), // 1. kiri atas -> ATAS
                      _buildSquare(
                        1,
                        -1,
                        600,
                        screenWidth,
                      ), // 2. kanan atas -> KANAN
                      _buildSquare(
                        -1,
                        1,
                        600,
                        screenWidth,
                      ), // 3. kiri bawah -> BAWAH
                      _buildSquare(
                        1,
                        1,
                        600,
                        screenWidth,
                      ), // 4. kanan bawah -> KIRI
                    ],
                  ),
                );
              },
            ),

            // ================== TEKS HIJAUIN ===================
            FadeTransition(
              opacity: _fadeTextController,
              child: Image.asset(
                'assets/images/logo_horizontal.png',
                width: 180, // sesuaikan
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquare(
    double xDir,
    double yDir,
    double squareSize,
    double screenWidth,
  ) {
    // Tidak ada lagi mergeController, jadi distanceMerge selalu 0
    double dx = 0;
    double dy = 0;

    // PERSEGI MELEDAR KELUAR LAYAR (Explode)
    final explode = CurvedAnimation(
      parent: _explodeController,
      curve: Curves.easeIn,
    );

    // Hitung Jarak Explode (Maksimum 500 pixel, agar keluar layar)
    double distanceExplode = lerpDouble(0, 500, explode.value)!;

    // Logika Explode (Atas, Kanan, Bawah, Kiri)
    // Persegi 1 (xDir=-1, yDir=-1) -> ATAS
    if (xDir == -1 && yDir == -1) {
      dy = -distanceExplode; // Ke Atas
    }
    // Persegi 2 (xDir=1, yDir=-1) -> KANAN
    else if (xDir == 1 && yDir == -1) {
      dx = distanceExplode; // Ke Kanan
    }
    // Persegi 3 (xDir=-1, yDir=1) -> BAWAH
    else if (xDir == -1 && yDir == 1) {
      dy = distanceExplode; // Ke Bawah
    }
    // Persegi 4 (xDir=1, yDir=1) -> KIRI
    else if (xDir == 1 && yDir == 1) {
      dx = -distanceExplode; // Ke Kiri
    }

    // Gradient disesuaikan untuk meniru tampilan menyatu saat awal
    LinearGradient gradient;
    if (xDir == -1 && yDir == -1) {
      // Kiri Atas -> ATAS
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFC7E0B3), Color(0xFF406E72)],
      );
    } else if (xDir == 1 && yDir == -1) {
      // Kanan Atas -> KANAN
      gradient = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFC7E0B3), Color(0xFF406E72)],
      );
    } else if (xDir == -1 && yDir == 1) {
      // Kiri Bawah -> BAWAH
      gradient = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFFC7E0B3), Color(0xFF406E72)],
      );
    } else {
      // Kanan Bawah -> KIRI
      gradient = const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [Color(0xFFC7E0B3), Color(0xFF406E72)],
      );
    }

    return Transform.translate(
      offset: Offset(dx, dy),
      child: Transform.rotate(
        angle: pi / 4, // jadi belah ketupat
        child: Container(
          width: squareSize,
          height: squareSize,
          decoration: BoxDecoration(
            gradient: gradient, // Menggunakan gradient
            borderRadius: BorderRadius.circular(
              20,
            ), // Membuat sudut lebih halus
          ),
        ),
      ),
    );
  }
}
