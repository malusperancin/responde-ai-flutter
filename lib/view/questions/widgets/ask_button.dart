import 'package:flutter/material.dart';
import '../new_question_view.dart';

class AskButton extends StatelessWidget {
  const AskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return const NewQuestionView();
          }),
        );
      },
      backgroundColor: const Color(0xFF4F82B2),
      child: const Icon(Icons.add, size: 38, color: Colors.white),
    );
  }
}
