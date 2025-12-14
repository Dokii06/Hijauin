import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ===================== LOAD USER DATA =====================
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/me'),
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
      body: CustomScrollView(
        slivers: [
          // ===================== APP BAR =====================
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: lightLime,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 60, bottom: 8),
              title: const Text(
                'Akun Saya',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 50,
                  left: 16,
                  right: 16,
                ),
                child: _buildProfileInfo(),
              ),
            ),
          ),

          // ===================== BODY =====================
          SliverList(
            delegate: SliverChildListDelegate([
              _buildPointCard(),
              _buildOrderHistorySection(),

              _buildSettingsGroup('Pengaturan Akun', [
                _buildMenuItem(Icons.menu, 'Aktivitas'),
                _buildMenuItem(Icons.local_offer, 'Promo'),
                _buildMenuItem(Icons.credit_card, 'Metode Pembayaran'),
              ]),

              _buildSettingsGroup('Keamanan Akun', [
                _buildMenuItem(Icons.help_outline, 'Pusat Bantuan'),
                _buildMenuItem(
                  Icons.verified_user_outlined,
                  'Kebijakan Privasi',
                ),
              ]),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildLogoutButton(),
              ),
              const SizedBox(height: 50),
            ]),
          ),
        ],
      ),
    );
  }

  // ===================== PROFIL =====================
  Widget _buildProfileInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: primaryBlue,
          child: Icon(Icons.person, color: Colors.white, size: 40),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            Text(email, style: const TextStyle(color: darkTeal)),
            Text(noHp, style: const TextStyle(color: darkTeal)),
            Text(alamat, style: const TextStyle(color: darkTeal)),
          ],
        ),
      ],
    );
  }

  // ===================== POINT =====================
  Widget _buildPointCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Poin Anda\n32.000',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
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

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: primaryBlue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
