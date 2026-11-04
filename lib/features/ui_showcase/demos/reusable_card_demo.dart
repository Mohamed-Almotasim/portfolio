import 'package:flutter/material.dart';

class ReusableCardDemo extends StatelessWidget {
  const ReusableCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star, size: 40),
            SizedBox(height: 10),
            Text("Reusable Card"),
          ],
        ),
      ),
    );
  }
}
