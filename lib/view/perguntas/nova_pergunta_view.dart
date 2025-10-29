import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pergunta_bloc.dart';
import '../../control/usuario_controller.dart';
import '../../model/pergunta.dart';
import '../shared/shared.dart';

class NovaPerguntaView extends StatefulWidget {
  const NovaPerguntaView({super.key});

  @override
  State<NovaPerguntaView> createState() => _NovaPerguntaViewState();
}

class _NovaPerguntaViewState extends State<NovaPerguntaView> {
  final TextEditingController _descricaoController = TextEditingController();
  final UsuarioController _usuarioController = UsuarioController();
  bool _isLoading = false;

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _enviarPergunta() async {
    if (!_usuarioController.estaLogado) {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Você precisa estar logado para fazer uma pergunta!',
        textoBotao: 'OK',
      );
      return;
    }

    final descricao = _descricaoController.text.trim();

    if (descricao.isEmpty) {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Por favor, descreva sua pergunta.',
        textoBotao: 'OK',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final pergunta = Pergunta(
        id: '', // O Firebase vai gerar automaticamente
        usuarioId: _usuarioController.usuarioLogado?.id ?? 1,
        data: '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
        hora: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        descricao: descricao,
        timestamp: now,
      );

      context.read<PerguntaBloc>().add(SubmitPerguntaEvent(pergunta: pergunta));
    } catch (e) {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Erro inesperado. Tente novamente.',
        textoBotao: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PerguntaBloc, PerguntaState>(
      listener: (context, state) {
        if (state is PerguntaSuccessState) {
          setState(() {
            _isLoading = false;
          });
          ModalPersonalizado.mostrar(
            context,
            texto: 'Pergunta enviada com sucesso!',
            textoBotao: 'OK',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              _descricaoController.clear();
            },
          );
        } else if (state is PerguntaErrorState) {
          setState(() {
            _isLoading = false;
          });
          ModalPersonalizado.mostrar(
            context,
            texto: 'Erro ao enviar pergunta: ${state.message}',
            textoBotao: 'OK',
          );
        } else if (state is PerguntaLoadingState) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Nova Pergunta', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF4F82B2),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8),
                  child: Text(
                    'Qual a sua pergunta?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF595959),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: TextField(
                    controller: _descricaoController,
                    minLines: 6,
                    maxLines: 10,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Escreva aqui sua pergunta com detalhes.',
                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: 380,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _enviarPergunta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F82B2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Enviar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (!_usuarioController.estaLogado)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Você precisa estar logado para criar uma pergunta.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
