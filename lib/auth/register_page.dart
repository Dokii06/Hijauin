import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijauin/auth/login_page.dart';
import 'package:hijauin/services/auth_service.dart';
import 'dart:async';

// ===================== WARNA =====================
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFA0C878);
const Color primaryBlue = Color(0xFF143D60);
const Color accentLime = Color(0xFFDDEB9D);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentStep = 1;

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ===================== CONTROLLERS =====================
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // ===================== NAVIGATION =====================
  void _nextStep() {
    if (_currentStep == 1) {
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        _showError("Semua field wajib diisi");
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        _showError("Konfirmasi password tidak sama");
        return;
      }

      if (!_agreedToTerms) {
        _showError("Anda harus menyetujui syarat & ketentuan");
        return;
      }

      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
        _showError("Format email tidak valid");
        return;
      }

      if (passwordController.text.length < 6) {
        _showError("Password minimal 6 karakter");
        return;
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() => _currentStep = 2);
    } else {
      _handleRegister();
    }
  }

  void _goBack() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      setState(() => _currentStep = 1);
    } else {
      Navigator.pop(context);
    }
  }

  // ===================== REGISTER LOGIC =====================
  Future<void> _handleRegister() async {
    final result = await AuthService.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      alamat: addressController.text.trim(),
      noHp: phoneController.text.trim(),
    );

    if (addressController.text.isEmpty || phoneController.text.isEmpty) {
      _showError("Semua field wajib diisi");
      return;
    }

    if (result["success"]) {
      _showRegistrationSuccess();
    } else {
      if (result["errors"] != null && result["errors"].isNotEmpty) {
        final errors = result["errors"] as Map<String, dynamic>;
        final firstError = errors.values.first;
        _showError(firstError[0]);
      } else {
        _showError(result["message"] ?? "Registrasi gagal");
      }
    }
  }

  void _showRegistrationSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SuccessRegistrationPage()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFBFD98A), Color(0xFF27667B), Color(0xFFDDEB9D)],
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryBlue),
            onPressed: _goBack,
          ),
          Text(
            _currentStep == 1 ? 'Daftar' : 'Lokasi',
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

  Widget _buildInputField({
    required String label,
    TextEditingController? controller,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword
          ? _obscurePassword
          : isConfirmPassword
          ? _obscureConfirmPassword
          : false,
      cursorColor: primaryBlue,
      style: GoogleFonts.montserrat(),
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
        filled: true,
        fillColor: Colors.white,
        suffixIcon: (isPassword || isConfirmPassword)
            ? IconButton(
                icon: Icon(
                  (isPassword ? _obscurePassword : _obscureConfirmPassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    if (isPassword) {
                      _obscurePassword = !_obscurePassword;
                    } else {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }
                  });
                },
              )
            : null,
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

  Widget _buildMainButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _nextStep,
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
          _buildInputField(label: 'Nama lengkap', controller: nameController),
          const SizedBox(height: 20),
          _buildInputField(label: 'Email', controller: emailController),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Kata sandi',
            controller: passwordController,
            isPassword: true,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Konfirmasi kata sandi',
            controller: confirmPasswordController,
            isConfirmPassword: true,
          ),
          const SizedBox(height: 10),

          // Checkbox Syarat & Ketentuan
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _agreedToTerms,
                  onChanged: (v) => setState(() => _agreedToTerms = v!),
                  activeColor: primaryBlue,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
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
                  padding: const EdgeInsets.only(top: 4),
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
          _buildMainButton("Lanjutkan"),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
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
          _buildInputField(
            label: 'Alamat lengkap',
            controller: addressController,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'Nomor Handphone',
            controller: phoneController,
          ),
          const SizedBox(height: 30),
          _buildMainButton("Daftar"),
        ],
      ),
    );
  }
}

class SuccessRegistrationPage extends StatefulWidget {
  const SuccessRegistrationPage({super.key});

  @override
  State<SuccessRegistrationPage> createState() =>
      _SuccessRegistrationPageState();
}

class _SuccessRegistrationPageState extends State<SuccessRegistrationPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFBFD98A), Color(0xFF27667B), Color(0xFFDDEB9D)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/success_icon.png',
                    width: 90,
                    height: 90,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.check_circle,
                      size: 90,
                      color: primaryBlue,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // TITLE
                const Text(
                  'Akun Berhasil Dibuat!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryBlue,
                  ),
                ),

                const SizedBox(height: 12),

                // DESCRIPTION
                const Text(
                  'Sekarang kamu dapat masuk\ndan mulai menggunakan aplikasi Hijauin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, height: 1.5, color: darkTeal),
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Masuk Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // LOGO
                Image.asset(
                  'assets/images/logo_horizontal.png',
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
