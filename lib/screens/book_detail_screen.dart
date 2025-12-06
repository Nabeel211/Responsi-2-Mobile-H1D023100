import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final Map book;
  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Inventaris DaanBooks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(book['judul'] ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Penulis: ${book['penulis']}'),
            Text('Penerbit: ${book['penerbit']}'),
            Text('Harga: ${book['harga']}'),
            Text('Jumlah: ${book['jumlah']}'),
            Text('Volume: ${book['volume']}'),
            Text('Tanggal Masuk: ${book['tanggal_masuk']}'),
          ],
        ),
      ),
    );
  }
}
