import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Warna Identitas Hijauin (disinkronkan dengan LoginPage Anda)
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFA0C878);
const Color primaryBlue = Color(0xFF143D60);
const Color accentLime = Color(0xFFDDEB9D); // Warna tombol/teks aksen

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentStep = 1; // 1: Profil, 2: Lokasi

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ===================== HELPER NAVIGATION =====================

  void _nextStep() {
    if (_currentStep == 1) {
      // Logic validasi di sini sebelum pindah
      // Asumsi validasi sukses:
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentStep = 2;
      });
    } else if (_currentStep == 2) {
      // Jika Daftar berhasil, navigasi ke halaman sukses
      _showRegistrationSuccess();
    }
  }

  void _goBack() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      setState(() {
        _currentStep = 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _showRegistrationSuccess() {
    // Navigasi ke halaman sukses (kita buatkan placeholder success page)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationSuccessPage()),
    );
  }

  // ===================== WIDGET UTAMA =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background Gradient seperti di LoginPage
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFBFD98A), Color(0xFF27667B), Color(0xFFDDEB9D)],
            stops: [0.25, 0.54, 1.0],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(child: _buildProfileStep()),
                  SingleChildScrollView(child: _buildLocationStep()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== KOMPONEN REUSABLE =====================

  Widget _buildHeader() {
    String title = _currentStep == 1 ? 'Daftar' : 'Lokasi';
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 10,
        left: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryBlue),
            onPressed: _goBack,
          ),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // Disesuaikan dari style TextFormField di LoginPage
  Widget _buildInputField({
    required String label,
    bool isPassword = false,
    bool isConfirmPassword = false,
    IconData? suffixIcon,
  }) {
    IconData? icon;
    if (isPassword) {
      icon = _obscurePassword ? Icons.visibility_off : Icons.visibility;
    } else if (isConfirmPassword) {
      icon = _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility;
    }

    return TextFormField(
      obscureText: isPassword
          ? _obscurePassword
          : (isConfirmPassword ? _obscureConfirmPassword : false),
      cursorColor: primaryBlue,
      style: GoogleFonts.montserrat(), // Menggunakan Font yang sama
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserrat(
          color: Colors.black.withOpacity(0.75),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: GoogleFonts.montserrat(
          color: Colors.black.withOpacity(0.75),
          fontWeight: FontWeight.w600,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        suffixIcon: isPassword || isConfirmPassword
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isPassword) {
                        _obscurePassword = !_obscurePassword;
                      } else if (isConfirmPassword) {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                  child: Icon(icon, color: Colors.black.withOpacity(0.75)),
                ),
              )
            : null, // Suffix icon hanya untuk password

        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryBlue.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }

  // Widget Tombol Utama
  Widget _buildMainButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ===================== LANGKAH 1: PROFIL =====================

  Widget _buildProfileStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Lengkapi profil sebelum melanjutkan\nuntuk daftar',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),
          _buildInputField(label: 'Nama lengkap'),
          const SizedBox(height: 20),
          _buildInputField(label: 'Email atau No. Telp.'),
          const SizedBox(height: 20),
          _buildInputField(label: 'Kata sandi', isPassword: true),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Konfirmasi kata sandi',
            isConfirmPassword: true,
          ),
          const SizedBox(height: 10),

          // Checkbox Persetujuan
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24, // Agar Checkbox tidak terlalu besar
                width: 24,
                child: Checkbox(
                  value: _agreedToTerms,
                  onChanged: (val) {
                    setState(() {
                      _agreedToTerms = val ?? false;
                    });
                  },
                  activeColor: primaryBlue,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return primaryBlue;
                    }
                    return Colors.white;
                  }),
                  side: BorderSide(
                    color: primaryBlue.withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Saya telah membaca dan menyetujui ',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: primaryBlue,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Syarat dan Ketentuan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' serta Kebijakan Privasi.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
          _buildMainButton(text: 'Lanjutkan', onPressed: _nextStep),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ===================== LANGKAH 2: LOKASI =====================

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          // Ilustrasi Peta (Placeholder)
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors
                  .transparent, // Transparan agar terlihat menyatu dengan background
              borderRadius: BorderRadius.circular(20),
            ),
            // Placeholder Ilustrasi
            child: Icon(
              Icons.public,
              size: 80,
              color: primaryBlue.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Daftarkan juga lokasimu agar mudah saat\nproses penjemputan sampah',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildInputField(label: 'Provinsi'),
          const SizedBox(height: 20),
          _buildInputField(label: 'Kabupaten / Kota'),
          const SizedBox(height: 20),
          _buildInputField(label: 'Kecamatan'),
          const SizedBox(height: 20),
          _buildInputField(label: 'Alamat lengkap'),
          const SizedBox(height: 30),
          _buildMainButton(text: 'Daftar', onPressed: _nextStep),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ===================== HALAMAN SUKSES (Placeholder) =====================

class RegistrationSuccessPage extends StatelessWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background Gradient seperti di RegisterPage
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFBFD98A), Color(0xFF27667B), Color(0xFFDDEB9D)],
            stops: [0.25, 0.54, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ilustrasi Berhasil Daftar (Placeholder)
                Icon(Icons.assignment_turned_in, size: 150, color: primaryBlue),
                const SizedBox(height: 50),
                Text(
                  'Akun berhasil terdaftar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sekarang kamu dapat masuk\ndan menggunakan fitur aplikasi kami.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Kembali ke halaman Login (pop 2 kali jika dari Register)
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      'Masuk Sekarang',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
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
    );
  }
}
