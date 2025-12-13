import 'package:flutter/material.dart';
import 'package:hijauin/pages/chat_page.dart';

// Asumsi Warna (didefinisikan di global scope atau file utama)
const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color accentLime = Color(0xFFDDEB9D);
const Color headerAccentBlue = Color(0xFF297EC6); // Aksen Biru di Header

class ArticleDetailPage extends StatelessWidget {
  final String articleTitle;
  final String date;
  final String author;

  const ArticleDetailPage({
    super.key,
    required this.articleTitle,
    required this.date,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Collapsible
          SliverAppBar(
            expandedHeight: 320.0,
            pinned: true,
            backgroundColor: primaryBlue,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 15),
              title: Text(
                articleTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                // Ini adalah dekorasi gradient yang menciptakan tampilan Header Blue-Greenish
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryBlue, headerAccentBlue],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Artikel Placeholder
                    Container(
                      height: 150,
                      // Warna latar belakang Gambar
                      color: darkTeal.withOpacity(0.6),
                      margin: const EdgeInsets.only(
                        top: 50,
                        left: 16,
                        right: 16,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.photo_library,
                        size: 50,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Info Tanggal/Penulis
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        // Data di gambar: 'Diunggah pada 15 Maret 2023 Penulis : Zaldy Seno'
                        'Diunggah pada $date | Penulis: $author',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),

          // Konten Artikel
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      articleTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const Divider(height: 30),
                    _buildArticleSection(
                      '1. Mengurangi Timbunan Sampah di TPA',
                      'Setiap hari, ribuan ton sampah dikirim ke Tempat Pembuangan Akhir (TPA). Tanpa pengelolaan yang baik, sampah ini bisa mencemari tanah dan air. Dengan mendaur ulang, kita mengurangi jumlah sampah yang harus dibuang dan memperpanjang umur TPA.',
                    ),
                    _buildArticleSection(
                      '2. Menghemat Sumber Daya Alam',
                      'Banyak bahan yang digunakan dalam produk sehari-hari berasal dari sumber daya alam yang terbatas seperti kayu, minyak bumi, dan logam. Dengan mendaur ulang kertas, plastik, dan logam, kita bisa mengurangi eksploitasi sumber daya alam.',
                    ),
                    _buildArticleSection(
                      '3. Mengurangi Polusi dan Emisi Karbon',
                      'Proses produksi barang baru membutuhkan energi besar dan menghasilkan emisi karbon yang mempercepat perubahan iklim. Daur ulang membutuhkan energi kecil daripada produksi baru dan menghemat energi. Contohnya, mendaur ulang aluminium bisa menghemat hingga 95% energi dibandingkan membuat aluminium dari bahan mentah!',
                    ),
                    _buildArticleSection(
                      '4. Melindungi Ekosistem dan Kehidupan Laut',
                      'Sampah plastik yang tidak terkelola sering berakhir di lautan dan mengancam kehidupan laut. Hewan, seperti penyu, lumba-lumba, dan burung sering memakan plastik karena mengira itu makanan. Dengan mendaur ulang plastik, kita bisa mencegah lebih banyak sampah masuk ke ekosistem laut.',
                    ),
                    _buildArticleSection(
                      '5. Menciptakan Peluang Ekonomi',
                      'Daur ulang membuka banyak lapangan pekerjaan, mulai dari pengumpulan, pengolahan, hingga pembuatan produk daur ulang. Ini membantu perekonomian lokal sekaligus menjaga lingkungan.',
                    ),
                    const SizedBox(height: 20),
                    _buildConclusionBox(),
                    const SizedBox(height: 30),

                    // Tombol Suka/Komentar (sesuai gambar)
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          color: primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Suka',
                          style: TextStyle(color: primaryBlue),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Beri komentar...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkTeal,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildConclusionBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: lightLime.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: darkTeal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bagaimana Kita Bisa Mulai?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkTeal,
            ),
          ),
          const SizedBox(height: 8),
          _buildChecklistItem('Pilahlah sampah dari rumah'),
          _buildChecklistItem('Gunakan kembali barang yang masih bisa dipakai'),
          _buildChecklistItem('Jual atau donasikan barang bekas'),
          _buildChecklistItem('Kurangi penggunaan plastik sekali pakai'),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_box, size: 20, color: darkTeal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
