import 'package:flutter/material.dart';
import 'package:front/pages/top_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final jwt = prefs.getString('jwt');

  runApp(
    MyApp(
      initialScreen: jwt != null ? const TopScreen() : const LoginScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'noSmoke',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF212025),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: initialScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF212025));
  }
}
