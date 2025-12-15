import 'package:flutter/material.dart';
import 'package:hijauin/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hijauin/pages/article_detail_page.dart';

const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color accentLime = Color(0xFFDDEB9D);
const Color headerAccentBlue = Color(0xFF297EC6);
const Color buttonGreen = Color(0xFFA0C878);

class ArticleModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String date;
  final String author;
  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.author,
  });
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['judul'] ?? 'No Title',
      description: json['konten'] ?? 'No Content',
      image: json['gambar'] ?? 'placeholder',
      date: json['tanggal'] ?? 'N/A',
      author: json['penulis'] ?? 'Admin',
    );
  }
}

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  List<ArticleModel> articles = [];
  bool isLoading = true;
  final String apiUrl = '${ApiConfig.baseUrl}/articles';

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  // --- FUNGSI MENGAMBIL DATA DARI LARAVEL API ---
  Future<void> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        final List<dynamic> articleJson = decodedData['data'] ?? [];

        setState(() {
          articles = articleJson
              .map((json) => ArticleModel.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Gagal memuat data: Status Code ${response.statusCode}');
      }
    } catch (e) {
      // Handle error koneksi
      setState(() {
        isLoading = false;
      });
      print('Error koneksi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildCustomAppBar(context),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryBlue),
                    )
                  : articles.isEmpty
                  ? const Center(child: Text("Tidak ada artikel tersedia."))
                  : ListView.builder(
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
                  'Edukasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Aksi tombol chat
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, ArticleModel article) {
    return Card(
      color: darkTeal.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryBlue.withOpacity(0.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image, color: Colors.white70, size: 40),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Teks dan Tombol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title, // Data dari API
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
                    article.description,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Tombol Lihat
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleDetailPage(articleId: article.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        child: const Text(
                          'Lihat',
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
