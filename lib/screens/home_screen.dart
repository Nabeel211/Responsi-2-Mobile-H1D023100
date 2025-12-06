import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'book_form_screen.dart';
import 'book_detail_screen.dart';
import 'login_screen.dart';
import 'package:flutter/foundation.dart'; // kIsWeb


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  final apiBase = kIsWeb 
    ? "http://localhost:3000" 
    : (dotenv.env['API_BASE'] ?? 'http://10.0.2.2:3000');
  List books = [];
  bool loading = false;
  String storeName = dotenv.env['STORE_NAME'] ?? 'DaanBooks';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => loading = true);
    final res = await http.get(Uri.parse('$apiBase/books'));
    if (res.statusCode == 200) {
      setState(() {
        books = jsonDecode(res.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal ambil data')));
    }
  }

  Future<void> _deleteBook(int id) async {
    final res = await http.delete(Uri.parse('$apiBase/books/$id'));
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terhapus')));
      _fetchBooks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal hapus')));
    }
  }

  void _logout() async {
    await supabase.auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Supabase.instance.client.auth.currentUser == null ? LoginScreen() : LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventaris Buku $storeName'),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => BookFormScreen()));
          _fetchBooks();
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchBooks,
        child: loading ? Center(child: CircularProgressIndicator()) : ListView.builder(
          itemCount: books.length,
          itemBuilder: (_, i) {
            final b = books[i];
            return ListTile(
              title: Text('${b['judul']}'),
              subtitle: Text('Penulis: ${b['penulis']} • Harga: ${b['harga']} • Jumlah: ${b['jumlah']}'),
              trailing: PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(child: Text('Edit'), value: 'edit'),
                  PopupMenuItem(child: Text('Hapus'), value: 'delete'),
                ],
                onSelected: (v) async {
                  if (v == 'edit') {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => BookFormScreen(book: b)));
                    _fetchBooks();
                  } else if (v == 'delete') {
                    _deleteBook(b['id']);
                  }
                },
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BookDetailScreen(book: b)));
              },
            );
          },
        ),
      ),
    );
  }
}
