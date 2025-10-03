import 'package:flutter/material.dart';

class IconInfo extends StatelessWidget {
  final String image;
  final String label;
  final Color color;
  
  const IconInfo({super.key, required this.image, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Image.asset(
              image, 
              width: 50, 
              height: 50, 
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF595959),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}