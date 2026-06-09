import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkSaved = prefs.getBool('isDarkMode') ?? false;
  runApp(MyApp(initialIsDark: isDarkSaved));
}

class MyApp extends StatefulWidget {
  final bool initialIsDark;
  const MyApp({super.key, this.initialIsDark = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  bool isLoading = true;
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.initialIsDark;
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    isLogin = prefs.getBool('isLogin') ?? false;

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    if (!mounted) return;
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: isLogin
          ? HomePage(isDark: isDark, onThemeChanged: toggleTheme)
          : const LoginPage(),
    );
  }
}
