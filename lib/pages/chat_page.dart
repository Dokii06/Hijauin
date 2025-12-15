import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color accentLime = Color(0xFFDDEB9D);
const Color headerAccentBlue = Color(0xFF297EC6);
const Color badgeGreen = Color(0xFF4CAF50);
const Color startColor = Color(0xFFDDEB9D);
const Color middleColor = Color(0xFFA0C878);
const Color endColor = Color(0xFF143D60);

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
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [startColor, middleColor, endColor],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Column(
          children: [
            _buildCustomAppBar(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: chatList.length,
                itemBuilder: (context, index) {
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
        height: 72,
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

  Widget _buildChatListItem(Map<String, dynamic> chat) {
    bool hasUnread = chat['unread'] > 0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: Colors.black,
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
                      color: hasUnread ? badgeGreen : Colors.black,
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
                        color: Colors.white,
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
          indent: 80,
          endIndent: 16,
        ),
      ],
    );
  }
}
