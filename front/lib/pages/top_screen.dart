import 'package:flutter/material.dart';
import './record_screen.dart';

//開発中のみ
import 'package:shared_preferences/shared_preferences.dart';
import './login_screen.dart'; 
//開発中のみ

class TopScreen extends StatefulWidget {
  const TopScreen({super.key});

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  int _selectIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    const RecordPage(),
    const TopPage(),
    const Center(child: Text('2')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: '記録'),
          BottomNavigationBarItem(icon: Icon(Icons.smoking_rooms),label: 'TOP',),
          BottomNavigationBarItem(icon: Icon(Icons.maps_ugc), label: '共有'),
        ],
        currentIndex: _selectIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF212121),
        selectedItemColor: Color(0xFFE74545),
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,

        selectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF742424)),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        iconSize: 30,
      ),
    );
  }
}

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 150),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'today',
                style: TextStyle(color: Color(0xFFE74545), fontSize: 60),
              ),
              SizedBox(width: 24),
              Text(
                ':',
                style: TextStyle(fontSize: 35, color: Color(0xFFE74545)),
              ),
              SizedBox(width: 25),

              Text(
                '6',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 60,
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Average',
                style: TextStyle(
                  color: Color.fromARGB(255, 231, 231, 231),
                  fontSize: 23,
                ),
              ),
              SizedBox(width: 10),
              Text(
                ':',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(width: 20),

              Text(
                '7',
                style: TextStyle(color: Color(0xFFE74545), fontSize: 23),
              ),
            ],
          ),
          const SizedBox(height: 120),
          Image.asset('assets/images/tobacco.png'),
          const SizedBox(height: 110),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF742424)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(Size(300, 65)),
              ),
              child: const Text(
                '喫煙',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),

          //開発中のみ
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('jwt'); // ← JWT削除
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          child: Text("ログアウト（開発用）"),
          ),
          //開発中のみ
          
        ],
      ),
    );
  }
}
