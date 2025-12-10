import 'package:flutter/material.dart';
import 'package:hijauin/auth/register_page.dart';
import 'package:hijauin/main.dart';
import 'package:hijauin/pages/homePage.dart';
import 'forgot_password.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Warna Identitas Hijauin
  static const Color darkTeal = Color(0xFF27667B);
  static const Color lightLime = Color(0xFFA0C878);
  static const Color primaryBlue = Color(0xFF143D60);

  // Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State untuk validasi
  String? emailError;
  String? passwordError;
  bool obscurePassword = true;

  // ===================== HELPER =====================
  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Login berhasil!"),
        backgroundColor: primaryBlue,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  // ===================== LOGIN LOGIC =====================
  void handleLogin() {
    String email = emailController.text.trim();
    String pass = passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showError("Email dan password tidak boleh kosong!");
      return;
    }

    // ==================== DUMMY CHECK ====================
    if (email == "admin@gmail.com" && pass == "123456") {
      _showSuccess();
      // Pindah halaman setelah 500ms (biarkan snackbar muncul dulu)
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainWrapper()),
        );
      });
    } else {
      _showError("Email atau password salah.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFBFD98A), Color(0xFF27667B), Color(0xFFDDEB9D)],
              stops: [0.25, 0.54, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 180),

                // LOGO
                Image.asset('assets/images/logo.png', width: 120, height: 120),

                const SizedBox(height: 60),

                // EMAIL
                _buildEmailField(),

                const SizedBox(height: 20),

                // PASSWORD
                _buildPasswordField(),

                const SizedBox(height: 5),

                // FORGOT PASSWORD
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Lupa kata sandi?',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // LOGIN BUTTON
                _buildLoginButton(),

                const SizedBox(height: 25),

                const Text(
                  'atau masuk dengan',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon('google'),
                    const SizedBox(width: 30),
                    _buildSocialIcon('facebook'),
                  ],
                ),

                const SizedBox(height: 25),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Daftar disini',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================= EMAIL FIELD =======================
  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      cursorColor: primaryBlue,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: GoogleFonts.montserrat(
          color: Colors.black.withOpacity(0.75),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: GoogleFonts.montserrat(
          color: Colors.black.withOpacity(0.75),
          fontWeight: FontWeight.w600,
        ),

        // ⬇ Padding seluruh area dalam TextField
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        // ⬇ Padding khusus suffix icon agar tidak mepet kanan
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Icon(
            Icons.email_outlined,
            color: Colors.black.withOpacity(0.75),
          ),
        ),

        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
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

  // ======================= PASSWORD FIELD =======================
  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: obscurePassword,
      cursorColor: primaryBlue,
      decoration: InputDecoration(
        labelText: "Kata Sandi",
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

        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: GestureDetector(
            onTap: () => setState(() => obscurePassword = !obscurePassword),
            child: Icon(
              obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.black.withOpacity(0.75),
            ),
          ),
        ),

        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
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

  // ======================= LOGIN BUTTON =======================
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
        ),
        child: const Text(
          'Masuk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ======================= SOCIAL ICON =======================
  Widget _buildSocialIcon(String type) {
    String iconPath = type == "google"
        ? 'assets/icons/google.png'
        : 'assets/icons/facebook.png';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(iconPath, fit: BoxFit.contain),
      ),
    );
  }

  // ======================= FIELD CONTAINER =======================
  Widget _inputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
