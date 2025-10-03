import 'package:flutter/material.dart';
import '../../../control/usuario_controller.dart';

class RespostaWidget extends StatelessWidget {
  final int usuarioId;
  final String data;
  final String hora;
  final String resposta;

  const RespostaWidget({
    super.key,
    required this.usuarioId,
    required this.data,
    required this.hora,
    required this.resposta,
  });

  String _getNomeUsuario() {
    final usuarioController = UsuarioController();
    final usuarios = usuarioController.todosUsuarios;
    try {
      final usuario = usuarios.firstWhere((u) => u.id == usuarioId);
      return usuario.nome;
    } catch (e) {
      return 'Usuário não encontrado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3B4A8B),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getNomeUsuario(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Text(
                '$data   $hora',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              resposta,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
