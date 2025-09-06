import 'package:flutter/material.dart';

class BuyCard extends StatelessWidget {
  const BuyCard({super.key});

  @override
  Widget build(BuildContext context) {

    const buyItemName = '高性能掃除機';

    final textPainter = TextPainter(
      text: const TextSpan(
        text: buyItemName,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:  '半年',
                  style: TextStyle(
                    color: Color(0xFF666666), fontSize: 15,fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:  '禁煙',
                  style: TextStyle(
                    color: Color(0xFFE74545), fontSize: 15,fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:  'したら買えるもの',
                  style: TextStyle(
                    color: Color(0xFF666666), fontSize: 15,fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    buyItemName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(width: textWidth + 25, height: 2, color: Color(0xFF742424)),
                ],
              ),
              SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }
}
