import 'package:flutter/material.dart';
import 'perguntar_button.dart';

class ApresentacaoView extends StatelessWidget {
  const ApresentacaoView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      floatingActionButton: PerguntarButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width, // Full width
              height: height * 0.4, // 40% of screen height
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
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: width * 0.92,
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _IconInfo(
                        image: 'lib/view/images/question.png',
                        label: 'Pergunte sobre\no que quiser.',
                        color: Color(0xFF4F5FB2),
                      ),
                      _IconInfo(
                        image: 'lib/view/images/help.png',
                        label: 'Responda e\ncompartilhe.',
                        color: Color(0xFFB2925B),
                      ),
                      _IconInfo(
                        image: 'lib/view/images/list.png',
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Clique no botão azul para perguntar.',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // ...botão removido, agora está no floatingActionButton do Scaffold
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _IconInfo extends StatelessWidget {
  final String image;
  final String label;
  final Color color;
  const _IconInfo({required this.image, required this.label, required this.color});

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