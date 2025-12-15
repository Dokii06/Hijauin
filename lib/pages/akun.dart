import 'package:flutter/material.dart';
import 'package:hijauin/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'edit_profile.dart';
import 'riwayat_setoran_page.dart';

// ===================== WARNA =====================
const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color accentLime = Color(0xFFDDEB9D);
const Color backgroundLight = Color(0xFFF7F7F7);
const Color darkGreenAccent = Color(0xFF7E9A68);
const Color redExit = Color(0xFFE53935);

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String name = '-';
  String email = '-';
  String noHp = '-';
  String alamat = '-';

  int userPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserPoints();
  }

  // ===================== LOAD USER DATA =====================
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/me'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];

      setState(() {
        name = user['name'] ?? '-';
        email = user['email'] ?? '-';
        noHp = user['no_hp'] ?? '-';
        alamat = user['alamat'] ?? '-';
      });
    }
  }

  // ================ LOAD USER POINT =================
  Future<void> _loadUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/dashboard'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userPoints = data['points'] ?? 0;
      });
    }
  }

  // ===================== LOGOUT =====================
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildPointCard(),
            _buildOrderHistorySection(),

            _buildSettingsGroup('Riwayat Setor Sampah', [
              _buildMenuItem(
                Icons.history,
                'Riwayat Setoran',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RiwayatSetoranPage(),
                    ),
                  );
                },
              ),
            ]),

            _buildSettingsGroup('Keamanan Akun', [
              _buildMenuItem(Icons.help_outline, 'Pusat Bantuan'),
              _buildMenuItem(Icons.verified_user_outlined, 'Kebijakan Privasi'),
            ]),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildLogoutButton(),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // ===================== PROFIL =====================
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkTeal, primaryBlue],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 36, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                        if (updated == true) {
                          _loadUserData();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 2),
                Text(noHp, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 2),
                Text(
                  alamat,
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== POINT =====================
  Widget _buildPointCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [darkTeal, primaryBlue],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Poin Anda\n$userPoints',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(Icons.star, color: Colors.orange, size: 30),
          ],
        ),
      ),
    );
  }

  // ===================== RIWAYAT =====================
  Widget _buildOrderHistorySection() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'Riwayat Pemesanan',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  // ===================== GROUP MENU =====================
  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: primaryBlue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // ===================== LOGOUT BUTTON =====================
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: redExit,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Keluar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
