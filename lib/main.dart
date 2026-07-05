import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/lista_tareas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE5097F), 
          primary: const Color(0xFFE5097F),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFF568B5),
          onPrimaryContainer: const Color(0xFF6B0023), 
          secondary: const Color(0xFFA6024F),
          secondaryContainer: const Color(0xFFFFA1EF), 
          onSecondaryContainer: const Color(0xFF6B0023),
          surfaceContainerHighest: const Color(0xFFFFA1EF).withOpacity(0.4), 
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE5097F), 
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFA6024F),
          foregroundColor: Colors.white,
        ),
      ),
      home: const ListaTareasScreen(),
    );
  }
}
