import 'package:flutter/material.dart';

class PilihJenisSampahPage extends StatelessWidget {
  const PilihJenisSampahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Jenis Sampah')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Botol Plastik'),
            onTap: () => Navigator.pop(context, 'Botol Plastik'),
          ),
          ListTile(
            title: const Text('Aluminium'),
            onTap: () => Navigator.pop(context, 'Aluminium'),
          ),
        ],
      ),
    );
  }
}
