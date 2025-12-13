import 'package:flutter/material.dart';
import 'package:hijauin/pages/article_detail_page.dart';

// Asumsi Warna (didefinisikan di global scope atau file utama)
const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color accentLime = Color(0xFFDDEB9D);
const Color headerAccentBlue = Color(0xFF297EC6);
const Color buttonGreen = Color(0xFFA0C878);

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  // Data dummy artikel
  final List<Map<String, dynamic>> articles = const [
    {
      'title': 'Bumi Butuh Kita: Saatnya Mulai Daur Ulang!',
      'description':
          'Sampah yang tidak dikelola dengan baik bisa merusak lingkungan. Yuk, pahami mengapa daur ulang adalah solusi terbaik!',
      'image': 'assets/images/recycling_1.jpg', // Placeholder
      'detail_page': ArticleDetailPage(
        articleTitle: 'Bumi Butuh Kita: Saatnya Mulai Daur Ulang!',
        date: '15 Maret 2023',
        author: 'Editor Kami',
      ),
    },
    {
      'title': 'Bingung Cara Daur Ulang? Ikuti 5 Langkah Mudah Ini!',
      'description':
          'Masih bingung bagaimana cara mendaur ulang? Artikel ini akan membantumu memahami langkah-langkah dasarnya!',
      'image': 'assets/images/recycling_2.jpg', // Placeholder
      'detail_page': ArticleDetailPage(
        articleTitle: 'Bingung Cara Daur Ulang? Ikuti 5 Langkah Mudah Ini!',
        date: '20 Mei 2024',
        author: 'Tim Edukasi',
      ),
    },
    {
      'title': 'Kenali Jenis Sampah yang Bisa Didaur Ulang',
      'description':
          'Tidak semua sampah bisa didaur ulang. Yuk, pelajari jenis-jenisnya agar proses daur ulang lebih efektif!',
      'image': 'assets/images/recycling_3.jpg', // Placeholder
      'detail_page': ArticleDetailPage(
        articleTitle: 'Kenali Jenis Sampah yang Bisa Didaur Ulang',
        date: '10 Juli 2024',
        author: 'Admin',
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [lightLime, darkTeal],
            stops: [0.1, 0.9],
          ),
        ),
        child: Column(
          children: [
            // Header Kustom
            _buildCustomAppBar(context),

            // Daftar Artikel
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return _buildArticleCard(context, articles[index]);
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

            // Judul (center secara vertikal)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 56),
                child: const Text(
                  'Edukasi',
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

  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article) {
    return Card(
      color: darkTeal.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Thumbnail
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryBlue.withOpacity(0.5), // Placeholder warna
                // image: DecorationImage(image: AssetImage(article['image']!), fit: BoxFit.cover),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.image, color: Colors.white70, size: 40),
            ),
            const SizedBox(width: 12),

            // Teks dan Tombol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    article['description'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Tombol Lihat (Menuju Detail Page)
                  Align(
                    alignment:
                        Alignment.centerRight, // Mendorong tombol ke kanan
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke Halaman Detail Artikel
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  article['detail_page'] as Widget,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          // UBAH WARNA KE HIJAU
                          backgroundColor:
                              buttonGreen, // Menggunakan warna hijau yang cerah
                          elevation:
                              0, // Hapus bayangan agar terlihat datar seperti desain
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        child: const Text(
                          'Lihat',
                          // UBAH WARNA TEKS MENJADI PRIMARY BLUE (sesuai desain)
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
