import 'package:chat/pages/home_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/service/auth_service.dart';
import 'package:chat/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MaterialTheme(GoogleFonts.notoSansNKoTextTheme()).light(),
      darkTheme: MaterialTheme(GoogleFonts.notoSansNKoTextTheme()).dark(),
      themeMode: ThemeMode.system,
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          final user = authService.getCurrentUser();

          return user == null ? LoginPage() : HomePage();
        },
      ),
    );
  }
}
