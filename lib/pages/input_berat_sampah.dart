import 'package:flutter/material.dart';

class InputBeratPage extends StatefulWidget {
  const InputBeratPage({super.key});

  @override
  State<InputBeratPage> createState() => _InputBeratPageState();
}

class _InputBeratPageState extends State<InputBeratPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Berat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Berat (Kg)'),
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
