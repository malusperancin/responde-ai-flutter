import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responde_ai/bloc/auth_bloc.dart';
import 'bloc/pergunta_bloc.dart';
import 'view/view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBeE6bCuBi3-ABicndiSYbBo3q92I1ZZCg",
      authDomain: "responde-ai-si700.firebaseapp.com",
      projectId: "responde-ai-si700",
      storageBucket: "responde-ai-si700.firebasestorage.app",
      messagingSenderId: "563112049979",
      appId: "1:563112049979:web:5b8908db381cc0ff908b1e",
      measurementId: "G-K0QC8VHPHJ",
    ),
  );
  runApp(const RespondeAiApp());
}

class RespondeAiApp extends StatelessWidget {
  const RespondeAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocProvider(
        create: (context) => PerguntaBloc()..add(LoadPerguntasEvent()),
        child: MaterialApp(
          title: 'Responde Aí',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const AppNavigator(),
        ),
      ),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

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
              icon: const Icon(
                Icons.question_answer,
                color: Colors.white,
                size: 30,
              ),
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
