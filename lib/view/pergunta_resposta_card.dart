import 'package:flutter/material.dart';
import '../model/pergunta.dart';
import 'pergunta_widget.dart';
import 'resposta_widget.dart';
import 'campo_resposta_widget.dart';
import 'modal_personalizado.dart';

class PerguntaRespostaCard extends StatefulWidget {
  final Pergunta pergunta;
  final Function(String)? onResponder;

  const PerguntaRespostaCard({
    super.key,
    required this.pergunta,
    this.onResponder,
  });

  @override
  State<PerguntaRespostaCard> createState() => _PerguntaRespostaCardState();
}

class _PerguntaRespostaCardState extends State<PerguntaRespostaCard> {
  bool _expandir = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onResponderPressed() {
    setState(() {
      _expandir = !_expandir;
    });
  }

  void _onEnviarPressed() async {
    final resposta = _controller.text.trim();
    if (resposta.isEmpty) {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Por favor, digite uma resposta',
        textoBotao: 'OK',
      );
      return;
    }

    try {
      if (widget.onResponder != null) {
        widget.onResponder!(resposta);
        ModalPersonalizado.mostrar(
          context,
          texto: 'Resposta enviada com sucesso!',
          textoBotao: 'OK',
        );
      }
      setState(() {
        _expandir = false;
        _controller.clear();
      });
    } catch (e) {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Erro ao enviar resposta. Tente novamente.',
        textoBotao: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool respondida = widget.pergunta.resposta != null && widget.pergunta.resposta!.isNotEmpty;
    
    if (!respondida) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PerguntaWidget(
                usuarioId: widget.pergunta.usuarioId,
                data: widget.pergunta.data,
                hora: widget.pergunta.hora,
                texto: widget.pergunta.descricao,
              ),
              if (!_expandir && widget.onResponder != null)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD5DAE0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC3C8CE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F82B2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _onResponderPressed,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            'Responder',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_expandir)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD5DAE0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: CampoRespostaWidget(
                      controller: _controller,
                      onEnviar: _onEnviarPressed,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      // Dois cards juntos: pergunta + resposta
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PerguntaWidget(
              usuarioId: widget.pergunta.usuarioId,
              data: widget.pergunta.data,
              hora: widget.pergunta.hora,
              texto: widget.pergunta.descricao,
            ),
            RespostaWidget(
              usuarioId: widget.pergunta.respondidaPorUsuarioId ?? widget.pergunta.usuarioId,
              data: widget.pergunta.dataResposta ?? widget.pergunta.data,
              hora: widget.pergunta.horaResposta ?? widget.pergunta.hora,
              resposta: widget.pergunta.resposta!,
            ),
          ],
        ),
      );
    }
  }
}
