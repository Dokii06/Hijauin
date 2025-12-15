import 'dart:convert';
import 'package:hijauin/config/api_config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = '${ApiConfig.baseUrl}';

  static Future<List<dynamic>> getSampah() async {
    final response = await http.get(Uri.parse('$baseUrl/sampah'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data sampah');
    }
  }

  static Future<void> kirimSetoran({
    required int userId,
    required int sampahId,
    required double beratKg,
    required String alamat,
    required int totalPoin,
    required int totalHarga,
  }) async {
    final url = Uri.parse("$baseUrl/setoran-sampah");
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'user_id': userId,
        'sampah_id': sampahId,
        'berat_kg': beratKg,
        'alamat': alamat,
        'total_poin': totalPoin,
        'total_harga': totalHarga,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menyimpan setoran');
    }
  }
}
