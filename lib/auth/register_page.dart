import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijauin/services/auth_service.dart';

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
    if (!_agreedToTerms) {
      _showError("Anda harus menyetujui syarat & ketentuan");
      return;
    }

    final result = await AuthService.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      alamat: addressController.text.trim(),
      noHp: phoneController.text.trim(),
    );

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
      MaterialPageRoute(builder: (_) => const RegistrationSuccessPage()),
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
      decoration: InputDecoration(
        labelText: label,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStep() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
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
          const SizedBox(height: 20),
          CheckboxListTile(
            value: _agreedToTerms,
            onChanged: (v) => setState(() => _agreedToTerms = v!),
            title: const Text("Saya menyetujui syarat & ketentuan"),
          ),
          _buildMainButton("Lanjutkan"),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
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

// ===================== SUCCESS PAGE =====================
class RegistrationSuccessPage extends StatelessWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 120, color: primaryBlue),
            const SizedBox(height: 20),
            const Text("Akun berhasil terdaftar"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("Masuk Sekarang"),
            ),
          ],
        ),
      ),
    );
  }
}
