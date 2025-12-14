import 'package:flutter/material.dart';
import 'package:hijauin/pages/chat_page.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Asumsi Warna (didefinisikan di global scope atau file utama)
const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightLime = Color(0xFFBFD98A);
const Color accentLime = Color(0xFFDDEB9D);
const Color headerAccentBlue = Color(0xFF297EC6);

class ArticleDetailPage extends StatefulWidget {
  final int articleId;

  const ArticleDetailPage({super.key, required this.articleId});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isLoading = true;

  String title = '';
  String content = '';
  String date = '';
  String author = '';

  final String apiBase = 'http://127.0.0.1:8000/api/articles';

  @override
  void initState() {
    super.initState();
    fetchArticleDetail();
  }

  Future<void> fetchArticleDetail() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBase/${widget.articleId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        setState(() {
          title = data['judul'];
          content = data['konten'];
          date = data['tanggal'];
          author = data['penulis'];
          isLoading = false;
        });
      } else {
        print('Gagal load detail');
        isLoading = false;
      }
    } catch (e) {
      print('Error: $e');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
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
                    Container(
                      height: 150,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
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
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const Divider(height: 30),
                    _buildArticleSection(content),
                    const SizedBox(height: 30),

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

  Widget _buildArticleSection(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),
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
