import 'package:flutter/material.dart';

class NewsCarousel extends StatefulWidget {
  const NewsCarousel({super.key});

  @override
  State<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  int _currentPage = 0;
  final int _itemCount = 3;

  // Warna dari konteks desain Anda
  final Color primaryBlue = const Color(0xFF143D60);
  final Color darkTeal = const Color(0xFF27667B);
  final Color textFillColor = const Color(0xFFF2F9D4);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. PageView Carousel
        SizedBox(
          height: 284,
          child: PageView.builder(
            itemCount: _itemCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildCarouselItem(
                context,
              ); // Panggil fungsi pembangun item
            },
          ),
        ),

        const SizedBox(height: 10),

        // 2. Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_itemCount, (index) {
            return _buildDotIndicator(index); // Panggil fungsi pembangun titik
          }),
        ),
      ],
    );
  }

  // Widget untuk setiap item carousel (kartu berita)
  Widget _buildCarouselItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          //
          image: const DecorationImage(
            image: AssetImage('assets/images/lantern_festival.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: textFillColor,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          child: const Text(
            'Ramah Lingkungan, Festival Lentera Taiwan 2025 Gunakan Bahan Daur Ulang',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Widget untuk Indikator Titik
  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? primaryBlue : Colors.white70,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
