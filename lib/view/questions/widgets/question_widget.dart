import 'package:flutter/material.dart';
import '../../../provider/firestore_provider.dart';

class QuestionWidget extends StatelessWidget {
  final String userId;
  final String date;
  final String time;
  final String text;

  const QuestionWidget({
    super.key,
    required this.userId,
    required this.date,
    required this.time,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD5DAE0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
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
                        color: Color(0xFF595959),
                      ),
                    );
                  },
                ),
                Text(
                  '$date   $time',
                  style: const TextStyle(
                    color: Color(0xFF595959),
                    fontSize: 12,
                  ),
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
                text,
                style: const TextStyle(fontSize: 14, color: Color(0xFF595959)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
