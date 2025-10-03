import 'package:flutter/material.dart';
import 'package:responde_ai/control/usuario_controller.dart';
import '../perguntas/widgets/widgets.dart';
import './widgets/icon_widget.dart';

class ApresentacaoView extends StatelessWidget {
  const ApresentacaoView({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioController = UsuarioController();

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      floatingActionButton: usuarioController.estaLogado
          ? const PerguntarButton()
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xFF4F82B2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'RespondeAí',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Bem-vindo ao RespondeAí!',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Faça perguntas e compartilhe respostas sobre diversos temas.',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      IconInfo(
                        image: 'lib/view/shared/images/question.png',
                        label: 'Pergunte sobre\no que quiser.',
                        color: Color(0xFF4F5FB2),
                      ),
                      IconInfo(
                        image: 'lib/view/shared/images/help.png',
                        label: 'Responda e\ncompartilhe.',
                        color: Color(0xFFB2925B),
                      ),
                      IconInfo(
                        image: 'lib/view/shared/images/list.png',
                        label: 'Explore listas e\ntópicos.',
                        color: Color(0xFF4F5FB2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            // Texto inferior
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                usuarioController.estaLogado
                    ? 'Clique no botão azul para perguntar.'
                    : 'Faça login para perguntar e responder.',
                style: const TextStyle(color: Color(0xFF888888), fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
