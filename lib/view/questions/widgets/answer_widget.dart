import 'package:flutter/material.dart';
import '../../../provider/firestore_provider.dart';

class AnswerWidget extends StatelessWidget {
  final String userId;
  final String date;
  final String time;
  final String answer;

  const AnswerWidget({
    super.key,
    required this.userId,
    required this.date,
    required this.time,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3B4A8B),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: FirestoreProvider.helper.getUserName(userId),
                builder: (context, snapshot) {
                  final userName = snapshot.data ?? 'Carregando...';
                  return Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              Text(
                '$date   $time',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
