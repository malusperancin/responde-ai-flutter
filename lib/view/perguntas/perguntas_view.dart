import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responde_ai/view/perguntas/widgets/widgets.dart';
import '../../bloc/pergunta_bloc.dart';
import '../../control/usuario_controller.dart';
import '../../model/pergunta.dart';

class PerguntasView extends StatefulWidget {
  const PerguntasView({super.key});

  @override
  State<PerguntasView> createState() => _PerguntasViewState();
}

class _PerguntasViewState extends State<PerguntasView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UsuarioController _usuarioController = UsuarioController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerguntaBloc, PerguntaState>(
      builder: (context, state) {
        if (state is PerguntaLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PerguntaErrorState) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erro: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PerguntaBloc>().add(LoadPerguntasEvent());
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        final perguntas = (state is PerguntaLoadedState) ? state.perguntaList : <Pergunta>[];
        final perguntasNaoRespondidas = perguntas.where((p) => p.resposta == null).toList();
        final perguntasRespondidas = perguntas.where((p) => p.resposta != null).toList();

        return Scaffold(
          floatingActionButton: _usuarioController.estaLogado ? const PerguntarButton() : null,
          backgroundColor: const Color(0xFFE8E8E8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4F82B2),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Perguntas',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  text: 'Não Respondidas (${perguntasNaoRespondidas.length})',
                ),
                Tab(
                  text: 'Respondidas (${perguntasRespondidas.length})',
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              if (!_usuarioController.estaLogado)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Faça login para criar perguntas e responder questões.',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListaPerguntas(perguntasNaoRespondidas, false),
                    _buildListaPerguntas(perguntasRespondidas, true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListaPerguntas(List<Pergunta> perguntas, bool respondidas) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: perguntas.length,
      itemBuilder: (context, index) {
        final pergunta = perguntas[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: PerguntaRespostaCard(
            pergunta: pergunta,
            onResponder: _usuarioController.estaLogado && !respondidas
                ? (resposta) {
                    context.read<PerguntaBloc>().add(ResponderPerguntaEvent(
                      perguntaId: pergunta.id,
                      resposta: resposta,
                      usuarioId: _usuarioController.usuarioLogado?.id ?? 1,
                    ));
                  }
                : null,
          ),
        );
      },
    );
  }
}