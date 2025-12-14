import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hijauin/main.dart';
import 'package:hijauin/pages/education_page.dart';
import 'package:hijauin/pages/setor_sampah.dart';
import 'chat_page.dart';
import 'widget/new_carousel.dart';

// Warna Identitas Hijauin
const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color lightYellow = Color(0xFFF2F9D4);
const Color accentLime = Color(0xFFDDEB9D);
const Color darkGreen = Color(0xFFA0C878);
const Color cardGreen = Color(0xFFC8E6C9);

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userName = "User"; // default sementara
  int userPoints = 0; // dummy
  double totalWasteKg = 0.0; // dummy

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // AMBIL DATA USER DARI SHARED PREFERENCES
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name") ?? "User";
      userPoints = 12000; // nanti dari API
      totalWasteKg = 8.3; // nanti dari API
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
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
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightLime, darkTeal],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              _buildCustomAppBar(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRecycleSummaryCard(context),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Berita terkini"),
                    const SizedBox(height: 10),
                    const NewsCarousel(),
                    const SizedBox(height: 20),
                    _buildTipsCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== CUSTOM APP BAR =====================
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentLime,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Halo, Selamat datang!',
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: primaryBlue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Yuk, lengkapi profil kamu!",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.coins, color: darkGreen),
                    const SizedBox(width: 6),
                    Text(
                      "$userPoints Poin",
                      style: const TextStyle(fontWeight: FontWeight.bold),
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

  // ===================== RECYCLE SUMMARY =====================
  Widget _buildRecycleSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [accentLime, darkGreen]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Sampah Ter-Daur Ulang",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "$totalWasteKg Kg",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainWrapper(initialIndex: 1),
                ),
              );
            },
            child: const Text("Setor"),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Sampah anorganik bisa merusak lingkungan. Yuk mulai daur ulang!",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EducationPage()),
              );
            },
            child: const Text("Lihat"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
