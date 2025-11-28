import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/buy_card.dart';
import '../widgets/info_card.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool isLoading = true;
  Map<String, dynamic>? recordData;

  @override
  void initState() {
    super.initState();
    fetchRecordData();
  }

  Future<void> fetchRecordData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    if (jwt == null) return;

    final logUrl = Uri.parse('http://10.0.2.2:3000/log');
    final logRes = await http.get(
      logUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );

    if (logRes.statusCode != 200) {
      print('log API error: ${logRes.statusCode}');
      return;
    }

    final logData = jsonDecode(logRes.body);
    final threeMonthsPredictionPrice = logData['threeMonthsPredictionPrice'];

    final itemUrl = Uri.parse('http://10.0.2.2:3000/item');
    final itemRes = await http.post(
      itemUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "threeMonthsPredictionPrice": threeMonthsPredictionPrice,
      }),
    );

    if (itemRes.statusCode != 201) {
      print('item API error: ${itemRes.statusCode}');
      return;
    }

    final itemData = jsonDecode(itemRes.body);

    setState(() {
      recordData = {
        ...logData,
        "buyItemName": itemData["buyItemName"],
      };
      isLoading = false;
    });

    } catch (e) {
      print('record画面 API接続エラー: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading || recordData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final record = recordData!;
    final threeMonthsPredictionPrice = record['threeMonthsPredictionPrice'] ?? 'エラー';
    final usePrice = record['usePrice'] ?? 'エラー';
    final totalSmoke = record['totalSmoke'] ?? 'エラー';
    final lifespan = record['lifespan'] ?? 'エラー';
    final useTime = record['useTime'] ?? 'エラー';
    final buyItemName = record['buyItemName'] ?? '???';


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 70),
            const Text(
              "このままだと...",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 35),
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Text(
                      "3ヵ月後",
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:  [
                    SizedBox(width: 10),
                    Text(
                      threeMonthsPredictionPrice.toString(),
                      style: TextStyle(color: Color(0xFFE74545), fontSize: 90),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "円",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 30),
            BuyCard(buyItemName: buyItemName),
            SizedBox(height: 30),
            const Text(
              "今までの記録",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 5),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(25),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.4,
                children:  [
                  InfoCard(title: '使った金額', value: usePrice.toString(), unit: '千円'),
                  InfoCard(title: '吸った本数', value: totalSmoke.toString(), unit: '本'),
                  InfoCard(title: '寿命', value: lifespan.toString(), unit: '分'),
                  InfoCard(title: '使った時間', value: useTime.toString(), unit: '分'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
