import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final supabase = Supabase.instance.client;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool loading = false;

void _register() async {
  setState(() => loading = true);

  try {
    final res = await supabase.auth.signUp(
      email: _emailCtrl.text,
      password: _passCtrl.text,
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registrasi sukses. Silakan login.')),
    );
    Navigator.pop(context);

  } catch (e) {
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Inventaris DaanBooks'), // contoh sesuai ketentuan
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: _passCtrl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          SizedBox(height: 12),
          ElevatedButton(onPressed: loading ? null : _register, child: loading ? CircularProgressIndicator() : Text('Registrasi')),
        ]),
      ),
    );
  }
}
