import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BookFormScreen extends StatefulWidget {
  final Map? book;
  BookFormScreen({this.book});

  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final apiBase = dotenv.env['API_BASE'] ?? 'http://10.0.2.2:3000';

  final judulCtrl = TextEditingController();
  final hargaCtrl = TextEditingController();
  final jumlahCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final volumeCtrl = TextEditingController();
  final penulisCtrl = TextEditingController();
  final penerbitCtrl = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      final b = widget.book!;
      judulCtrl.text = b['judul'] ?? '';
      hargaCtrl.text = b['harga']?.toString() ?? '';
      jumlahCtrl.text = b['jumlah']?.toString() ?? '';
      tanggalCtrl.text = b['tanggal_masuk'] ?? '';
      volumeCtrl.text = b['volume']?.toString() ?? '';
      penulisCtrl.text = b['penulis'] ?? '';
      penerbitCtrl.text = b['penerbit'] ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final payload = {
      'judul': judulCtrl.text,
      'harga': int.tryParse(hargaCtrl.text) ?? 0,
      'jumlah': int.tryParse(jumlahCtrl.text) ?? 0,
      'tanggal_masuk': tanggalCtrl.text,
      'volume': int.tryParse(volumeCtrl.text) ?? 0,
      'penulis': penulisCtrl.text,
      'penerbit': penerbitCtrl.text,
    };
    http.Response res;
    if (widget.book == null) {
      res = await http.post(Uri.parse('$apiBase/books'), body: jsonEncode(payload), headers: {'Content-Type':'application/json'});
    } else {
      res = await http.put(Uri.parse('$apiBase/books/${widget.book!['id']}'), body: jsonEncode(payload), headers: {'Content-Type':'application/json'});
    }
    setState(() => loading = false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Inventaris DaanBooks' : 'Tambah Inventaris DaanBooks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(controller: judulCtrl, decoration: InputDecoration(labelText: 'Judul'), validator: (v)=> v!.isEmpty ? 'wajib diisi' : null),
            TextFormField(controller: penulisCtrl, decoration: InputDecoration(labelText: 'Penulis'), validator: (v)=> v!.isEmpty ? 'wajib' : null),
            TextFormField(controller: penerbitCtrl, decoration: InputDecoration(labelText: 'Penerbit'), validator: (v)=> v!.isEmpty ? 'wajib' : null),
            TextFormField(controller: hargaCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Harga'), validator: (v)=> v!.isEmpty ? 'wajib' : null),
            TextFormField(controller: jumlahCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Jumlah'), validator: (v)=> v!.isEmpty ? 'wajib' : null),
            TextFormField(controller: volumeCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Volume (ml/halaman?)'), validator: (v)=> v!.isEmpty ? 'wajib' : null),
            TextFormField(
              controller: tanggalCtrl,
              decoration: InputDecoration(labelText: 'Tanggal Masuk (YYYY-MM-DD)'),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                if (dt != null) tanggalCtrl.text = dt.toIso8601String().split('T')[0];
              },
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: loading ? null : _save, child: loading ? CircularProgressIndicator() : Text(isEdit ? 'Update' : 'Simpan')),
          ]),
        ),
      ),
    );
  }
}
