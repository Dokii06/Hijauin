import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const Color primaryBlue = Color(0xFF143D60);
const Color backgroundLight = Color(0xFFF7F7F7);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final alamatController = TextEditingController();
  final noHpController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // ===================== LOAD USER FROM API =====================
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final res = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/me'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final user = jsonDecode(res.body)['user'];

      nameController.text = user['name'] ?? '';
      emailController.text = user['email'] ?? '';
      alamatController.text = user['alamat'] ?? '';
      noHpController.text = user['no_hp'] ?? '';

      setState(() => isLoading = false);
    }
  }

  // ===================== SAVE PROFILE =====================
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': nameController.text,
        'alamat': alamatController.text,
        'no_hp': noHpController.text,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // ===================== UPDATE SHARED PREFERENCES =====================
      await prefs.setString('name', data['user']['name']);
      await prefs.setString('email', data['user']['email']);
      await prefs.setString('no_hp', data['user']['no_hp']);
      await prefs.setString('alamat', data['user']['alamat']);

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: primaryBlue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _input('Nama', nameController),
                    _input(
                      'Email',
                      emailController,
                      readOnly: true,
                      validate: false,
                    ),
                    _input('No HP', noHpController),
                    _input('Alamat', alamatController),
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    bool validate = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: validate
            ? (v) => v == null || v.isEmpty ? '$label wajib diisi' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // ======================= SAVE BUTTON =======================
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
        ),
        child: const Text(
          'Simpan',
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
