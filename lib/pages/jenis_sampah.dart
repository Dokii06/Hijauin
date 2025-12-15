import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hijauin/config/api_config.dart';
import 'package:http/http.dart' as http;

const Color primaryBlue = Color(0xFF143D60);
const Color darkTeal = Color(0xFF27667B);
const Color lightGreenCard = Color(0xFFF2F9D4);

class JenisSampahPage extends StatefulWidget {
  const JenisSampahPage({super.key});

  @override
  State<JenisSampahPage> createState() => _JenisSampahPageState();
}

class _JenisSampahPageState extends State<JenisSampahPage> {
  List<dynamic> sampahList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSampah();
  }

  Future<void> loadSampah() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/sampah'));

    if (response.statusCode == 200) {
      setState(() {
        sampahList = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Jenis Sampah'),
        backgroundColor: primaryBlue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sampahList.length,
              itemBuilder: (context, index) {
                final item = sampahList[index];

                return _buildSampahCard(item);
              },
            ),
    );
  }

  // ================= CARD ITEM =================
  Widget _buildSampahCard(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pop(context, item);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: lightGreenCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: darkTeal.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ICON
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: primaryBlue,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              // TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nama'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${item['harga_per_kg']} / kg',
                      style: const TextStyle(fontSize: 13, color: darkTeal),
                    ),
                  ],
                ),
              ),

              // ARROW
              const Icon(Icons.arrow_forward_ios, size: 16, color: darkTeal),
            ],
          ),
        ),
      ),
    );
  }
}
