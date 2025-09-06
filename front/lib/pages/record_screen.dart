import 'package:flutter/material.dart';
import '../widgets/buy_card.dart';
import '../widgets/info_card.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 70),
            const Text(
              "このままだと...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            SizedBox(height: 35),            
            Column(
              children: [
                const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 25,),
                Text(
                  "3ヵ月後",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                SizedBox(width: 10),
                Text(
                  '-NUM',
                  style: TextStyle(
                    color: Color(0xFFE74545),
                    fontSize: 90,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  "円",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
              ],
            ),

            SizedBox(height: 30,),
            const BuyCard(),
            SizedBox(height: 30,),
            const Text(
              "今までの記録",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(25),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.4,
                children:const [
                  InfoCard(title: '使った金額', value: '2', unit: '千円'),
                  InfoCard(title: '吸った本数', value: '2', unit: '本'),
                  InfoCard(title: '寿命', value: '2', unit: '分'),
                  InfoCard(title: '使った時間', value: '2', unit: '分'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
