import 'package:flutter/material.dart';
import 'control/pergunta_change_notifier.dart';
import 'control/pergunta_inherited_widget.dart';
import 'view/apresentacao_view.dart';
import 'view/perguntas_view.dart';
import 'view/perfil_view.dart';
import 'view/minhas_perguntas_view.dart';

void main() {
  runApp(const PerguntasRespostasApp());
}

class PerguntasRespostasApp extends StatefulWidget {
  const PerguntasRespostasApp({Key? key}) : super(key: key);

  @override
  State<PerguntasRespostasApp> createState() => _PerguntasRespostasAppState();
}

class _PerguntasRespostasAppState extends State<PerguntasRespostasApp> {
  late final PerguntaChangeNotifier _perguntaChangeNotifier;

  @override
  void initState() {
    super.initState();
    _perguntaChangeNotifier = PerguntaChangeNotifier();
  }

  @override
  void dispose() {
    _perguntaChangeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PerguntaInheritedWidget(
      perguntaChangeNotifier: _perguntaChangeNotifier,
      child: MaterialApp(
        title: 'Perguntas & Respostas',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;

  List<Widget> get _widgetOptions {
    return const <Widget>[
      ApresentacaoView(),
      PerguntasView(),
      MinhasPerguntasView(),
      PerfilView(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF4F82B2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 30),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.question_answer, color: Colors.white, size: 30),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: const Icon(Icons.all_inbox, color: Colors.white, size: 30),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white, size: 30),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
