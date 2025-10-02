import 'package:flutter/material.dart';
import 'nova_pergunta_view.dart';

class PerguntarButton extends StatelessWidget {
  const PerguntarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return const NovaPerguntaView();
          }),
        );
      },
      backgroundColor: const Color(0xFF4F82B2),
      child: const Icon(Icons.add, size: 38, color: Colors.white),
    );
  }
}
