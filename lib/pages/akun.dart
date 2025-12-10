import 'package:flutter/material.dart';

// Warna Identitas Hijauin (disinkronkan dari file-file sebelumnya)
const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color accentLime = Color(0xFFDDEB9D);
const Color backgroundLight = Color(0xFFF7F7F7);
const Color darkGreenAccent = Color(
  0xFF7E9A68,
); // Warna aksen hijau di tombol menu
const Color redExit = Color(0xFFE53935);

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: CustomScrollView(
        slivers: [
          // ========================= 1. CUSTOM APP BAR / HEADER =========================
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: lightLime,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: primaryBlue),
              onPressed: () {
                // Navigasi kembali (jika diakses dari luar MainWrapper)
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: darkTeal),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 60, bottom: 8),
              title: const Text(
                'Akun Saya',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 50,
                  left: 16,
                  right: 16,
                ),
                child: _buildProfileInfo(),
              ),
            ),
          ),

          // ========================= 2. BODY CONTENT =========================
          SliverList(
            delegate: SliverChildListDelegate([
              // Kartu Poin
              _buildPointCard(),

              // Riwayat Pemesanan
              _buildOrderHistorySection(),

              // Pengaturan Akun
              _buildSettingsGroup('Pengaturan Akun', [
                _buildMenuItem(Icons.menu, 'Aktivitas'),
                _buildMenuItem(Icons.local_offer, 'Promo'),
                _buildMenuItem(Icons.credit_card, 'Metode Pembayaran'),
                _buildMenuItem(Icons.handshake, 'Mitra'),
                _buildMenuItem(Icons.language, 'Bahasa'),
              ]),

              // Keamanan Akun
              _buildSettingsGroup('Keamanan Akun', [
                _buildMenuItem(Icons.help_outline, 'Pusat Bantuan'),
                _buildMenuItem(
                  Icons.description_outlined,
                  'Syarat & Ketentuan',
                ),
                _buildMenuItem(
                  Icons.verified_user_outlined,
                  'Kebijakan Privasi',
                ),
                _buildMenuItem(Icons.star_border_outlined, 'Ulasan'),
              ]),

              const SizedBox(height: 30),

              // Tombol Keluar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildLogoutButton(),
              ),

              const SizedBox(height: 50),
            ]),
          ),
        ],
      ),
    );
  }

  // --- 1. PROFIL INFO ---
  Widget _buildProfileInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: primaryBlue,
          // Placeholder Image
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile_placeholder.jpg',
              fit: BoxFit.cover,
              width: 70,
              height: 70,
            ),
          ),
        ),
        const SizedBox(width: 15),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Sri Novellaputri Ramadhany',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            Text(
              'sri.novella@email.com',
              style: TextStyle(fontSize: 13, color: darkTeal),
            ),
            Text(
              '+62 8123987212',
              style: TextStyle(fontSize: 13, color: darkTeal),
            ),
          ],
        ),
      ],
    );
  }

  // --- 2. KARTU POIN ---
  Widget _buildPointCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tukarkan poin!', style: TextStyle(color: darkTeal)),
                SizedBox(height: 5),
                Text(
                  '32.000',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _buildPaymentIcon(
                  Icons.payment,
                  primaryBlue,
                ), // Placeholder Icon
                const SizedBox(width: 8),
                _buildPaymentIcon(
                  Icons.monetization_on,
                  Colors.orange,
                ), // Placeholder OVO
                const SizedBox(width: 8),
                _buildPaymentIcon(
                  Icons.account_balance_wallet,
                  Colors.blue,
                ), // Placeholder DANA
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(IconData icon, Color color) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: color,
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }

  // --- 3. RIWAYAT PEMESANAN ---
  Widget _buildOrderHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Pemesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'Lainnya',
                      style: TextStyle(color: darkTeal, fontSize: 14),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: darkTeal),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _HistoryItem(
                icon: Icons.access_time_filled,
                label: 'Belum bayar',
              ),
              _HistoryItem(icon: Icons.inventory_2_outlined, label: 'Dikemas'),
              _HistoryItem(
                icon: Icons.local_shipping_outlined,
                label: 'Dikirim',
              ),
              _HistoryItem(icon: Icons.star_border, label: 'Ulasan'),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. GROUP PENGATURAN AKUN & KEAMANAN ---
  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 20, right: 20),
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

  // --- 5. ITEM MENU ---
  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: darkGreenAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: primaryBlue),
          title: Text(
            title,
            style: const TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: primaryBlue,
          ),
          onTap: () {
            // Logika navigasi untuk setiap menu
          },
        ),
      ),
    );
  }

  // --- 6. TOMBOL KELUAR ---
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // Logika Keluar/Logout
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: redExit,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
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

// --- Helper Widget untuk Riwayat Pemesanan ---
class _HistoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HistoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: accentLime.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryBlue),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: darkTeal)),
      ],
    );
  }
}
