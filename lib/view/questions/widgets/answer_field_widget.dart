import 'package:flutter/material.dart';

class AnswerFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const AnswerFieldWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            style: const TextStyle(fontSize: 14),
            controller: controller,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Digite sua resposta...',
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F82B2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          onPressed: onSubmit,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Enviar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
