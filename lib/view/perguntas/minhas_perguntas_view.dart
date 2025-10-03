import 'package:flutter/material.dart';
import 'package:perguntas_respostas/view/perguntas/widgets/widgets.dart';
import '../../control/pergunta_inherited_widget.dart';
import '../../control/usuario_controller.dart';
import '../../model/pergunta.dart';

class MinhasPerguntasView extends StatefulWidget {
  const MinhasPerguntasView({super.key});

  @override
  State<MinhasPerguntasView> createState() => _MinhasPerguntasViewState();
}

class _MinhasPerguntasViewState extends State<MinhasPerguntasView>
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

  List<Pergunta> _filtrarMinhasPerguntas(
    List<Pergunta> todasPerguntas,
    bool respondidas,
  ) {
    final usuario = _usuarioController.usuarioLogado;
    if (usuario == null) return [];

    return todasPerguntas
        .where((pergunta) => pergunta.usuarioId == usuario.id)
        .where(
          (pergunta) => respondidas
              ? pergunta.resposta != null
              : pergunta.resposta == null,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o usuário está logado
    if (!_usuarioController.estaLogado) {
      return Scaffold(
        backgroundColor: const Color(0xFFE8E8E8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4F82B2),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Minhas Perguntas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.login,
                        size: 64,
                        color: Color(0xFF4F82B2),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Faça login para ver suas perguntas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF595959),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Aqui você poderá acompanhar todas as suas perguntas e respostas organizadas em um só lugar.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final perguntaNotifier = PerguntaInheritedWidget.of(context);
    final todasPerguntas = perguntaNotifier.perguntas;

    final perguntasNaoRespondidas = _filtrarMinhasPerguntas(
      todasPerguntas,
      false,
    );
    final perguntasRespondidas = _filtrarMinhasPerguntas(todasPerguntas, true);

    return Scaffold(
      floatingActionButton: _usuarioController.estaLogado ? const PerguntarButton() : null,
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F82B2),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Minhas Perguntas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Não Respondidas (${perguntasNaoRespondidas.length})'),
            Tab(text: 'Respondidas (${perguntasRespondidas.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListaPerguntas(perguntasNaoRespondidas, false),
          _buildListaPerguntas(perguntasRespondidas, true),
        ],
      ),
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
          child: Column(
            children: [
              PerguntaRespostaCard(
                pergunta: pergunta,
                onResponder: _usuarioController.estaLogado && !respondidas
                    ? (resposta) {
                        final perguntaNotifier = PerguntaInheritedWidget.of(
                          context,
                        );
                        perguntaNotifier.responderPergunta(
                          pergunta.id,
                          resposta,
                        );
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
