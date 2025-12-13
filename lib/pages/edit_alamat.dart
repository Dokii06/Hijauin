import 'package:flutter/material.dart';

class EditAlamatPage extends StatefulWidget {
  const EditAlamatPage({super.key});

  @override
  State<EditAlamatPage> createState() => _EditAlamatPageState();
}

class _EditAlamatPageState extends State<EditAlamatPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Alamat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Alamat Lengkap'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
