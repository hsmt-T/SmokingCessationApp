import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import './top_screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  static const platform = MethodChannel(
    'nosmoke/deeplink',
  ); // Android/iOS側でIntentを送るため
  
  bool _handledInitial = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkIfLoggedIn();
    _checkDeepLink(force: true);
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    if (!mounted) return;

    if (jwt != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TopScreen()),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDeepLink(force: true); // 強制チェック
    }
  }

  Future<void> _checkDeepLink({bool force = false}) async {
    if (!force && _handledInitial) return; // 初回のみ処理

    try {
      String? uri;
      if (Platform.isAndroid || Platform.isIOS) {
        uri = await platform.invokeMethod<String>('getInitialLink');
        print('invokeMethod returned: $uri'); // ←ここを追加
      }
      if (uri != null && uri.startsWith('nosmoke://callback')) {
        final jwtToken = Uri.parse(uri).queryParameters['jwt'];
        print('JWT from deep link: $jwtToken'); // ←ここも
        if (jwtToken != null) {
          await _handleJwt(jwtToken);
          _handledInitial = true;
        }
      }
    } catch (e, st) {
      print('DeepLinkチェック失敗: $e');
      print(st);
    }
  }

  Future<void> _handleJwt(String jwtToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', jwtToken);

      final savedJwt = prefs.getString('jwt');
      print('保存されたJWT: $savedJwt');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TopScreen()),
      );
    } catch (e, st) {
      print('JWT処理失敗: $e');
      print(st);
    }
  }

  // NestJS から LINE ログイン URL を取得してブラウザで開く
  Future<void> loginWithLine() async {
    print('ボタンおされた');
    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/auth/line/login'),
      );
      print('サーバー応答: ${res.body}');

      if (res.statusCode != 200) {
        print('LINEログインURL取得失敗: ${res.statusCode}');
        return;
      }

      final data = jsonDecode(res.body);
      final loginUrl = data['url'] as String?;
      if (loginUrl == null) throw Exception('LINEログインURLがありません');

      await launchUrlString(loginUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('ログインエラー：$e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SignUP
            Text(
              'SignUP',
              style: TextStyle(
                fontSize: 75,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE74545),
              ),
            ),

            //or
            Text(
              'or',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE74545),
              ),
            ),

            //LOgin
            Text(
              'Login',
              style: TextStyle(
                fontSize: 75,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE74545),
              ),
            ),

            const SizedBox(height: 135),

            //LINE連携ボタン
            ElevatedButton(
              onPressed: () => loginWithLine(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF742424)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ), // 丸み
                ),
                minimumSize: MaterialStateProperty.all(Size(300, 60)),
              ),
              child: Text(
                'LINEと連携',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
