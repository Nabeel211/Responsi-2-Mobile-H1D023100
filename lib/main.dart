import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");   // WAJIB

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brown = MaterialColor(0xFF6B4226, {
      50: Color(0xFFEFEBE9),
      100: Color(0xFFD7CCC8),
      200: Color(0xFFBCAAA4),
      300: Color(0xFFA1887F),
      400: Color(0xFF8D6E63),
      500: Color(0xFF6B4226),
      600: Color(0xFF5D4037),
      700: Color(0xFF4E342E),
      800: Color(0xFF3E2723),
      900: Color(0xFF2B1B17),
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Responsi 2 Mobile Paket 3 (NIM)",
      theme: ThemeData(
        primarySwatch: brown,
        appBarTheme: const AppBarTheme(backgroundColor: brown),
      ),
      home: const AuthStateSwitcher(),
    );
  }
}

class AuthStateSwitcher extends StatefulWidget {
  const AuthStateSwitcher({super.key});

  @override
  State<AuthStateSwitcher> createState() => _AuthStateSwitcherState();
}

class _AuthStateSwitcherState extends State<AuthStateSwitcher> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    // --- WAJIB: dijalankan setelah build stabil ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = supabase.auth.currentUser;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
