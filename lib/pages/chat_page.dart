import 'package:flutter/material.dart';

// Warna Identitas Hijauin (disinkronkan dari file-file sebelumnya)
const Color primaryBlue = Color(0xFF143D60); // Biru Tua
const Color darkTeal = Color(0xFF27667B); // Teal Gelap
const Color accentLime = Color(0xFFDDEB9D); // Hijau Muda Terang
const Color headerAccentBlue = Color(0xFF297EC6); // Aksen Biru di Header
const Color badgeGreen = Color(0xFF4CAF50); // Hijau untuk Badge notifikasi

// --- WARNA GRADIENT BARU ---
const Color startColor = Color(0xFFDDEB9D); // 0%
const Color middleColor = Color(0xFFA0C878); // 45%
const Color endColor = Color(0xFF143D60); // 100%

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk daftar chat
    final List<Map<String, dynamic>> chatList = [
      {
        'name': 'DIY Karawang',
        'message': 'Stoknya masih ready kak, mau dikirim yang mana?',
        'time': '12.47',
        'unread': 2,
        'avatar': Icons.person,
      },
      {
        'name': 'EcoCraft Studio',
        'message':
            'Halo! Terima kasih sudah menghubungi EcoCraft Studio. Kami menyediakan be...',
        'time': '9.30',
        'unread': 1,
        'avatar': Icons.person,
      },
      {
        'name': 'UpCycke Wear',
        'message': 'Ready ya ka',
        'time': 'Kemarin',
        'unread': 1,
        'avatar': Icons.person,
      },
      {
        'name': 'Pahlawan Jemput #123',
        'message': 'Saya sudah sampai di depan rumah.',
        'time': '1 Des',
        'unread': 0,
        'avatar': Icons.person,
      },
    ];

    return Scaffold(
      body: Container(
        // ===================================
        // 1. MODIFIKASI BACKGROUND GRADIENT
        // ===================================
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Arah: dari atas kanan ke bawah kiri
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [startColor, middleColor, endColor],
            stops: [0.0, 0.45, 1.0], // Stops yang diminta
          ),
        ),
        child: Column(
          children: [
            // 1. App Bar Kustom dengan Gradient Biru
            _buildCustomAppBar(context),
            // 2. Daftar Chat (Expand agar mengisi sisa ruang)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  // Meneruskan data chat ke item builder
                  return _buildChatListItem(chatList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryBlue, headerAccentBlue],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Container(
        height: 72, // 🔑 tinggi konten appbar (atur di sini)
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            // Tombol Back
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Judul (center secara vertikal)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 56),
                child: const Text(
                  'Pesan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. Item Daftar Chat (MODIFIKASI: Tambah Divider Putih) ---
  Widget _buildChatListItem(Map<String, dynamic> chat) {
    bool hasUnread = chat['unread'] > 0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          // Hapus margin bottom (diganti oleh Divider)
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Pusatkan secara vertikal
            children: [
              // Avatar/Ikon
              CircleAvatar(
                radius: 28,
                backgroundColor: darkTeal.withOpacity(0.7),
                child: Icon(
                  chat['avatar'] as IconData,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),

              // Nama dan Pesan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black, // Warna Nama Chat (Hitam)
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat['message'] as String,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: hasUnread
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Waktu dan Badge Notifikasi
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat['time'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasUnread
                          ? badgeGreen
                          : Colors.black, // Warna Waktu
                      fontWeight: hasUnread
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (hasUnread)
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: Colors.white, // Badge putih
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        chat['unread'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // ===================================
        // GARIS PEMISAH PUTIH BARU
        // ===================================
        const Divider(
          color: Colors.white,
          height: 1,
          thickness: 1,
          indent: 80, // Indentasi agar garis dimulai setelah avatar
          endIndent: 16,
        ),
      ],
    );
  }
}
