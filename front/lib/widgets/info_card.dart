import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                value,
                style: const TextStyle(fontSize: 35, color: Color(0xFFE74545)),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                unit,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
