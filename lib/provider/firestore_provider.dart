import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/pergunta.dart';

class FirestoreProvider {
  static FirestoreProvider helper = FirestoreProvider._();
  FirestoreProvider._();

  final CollectionReference perguntasCollection = 
      FirebaseFirestore.instance.collection("perguntas");

  // Stream controller para perguntas
  final StreamController<List<Pergunta>> _perguntasController = 
      StreamController<List<Pergunta>>.broadcast();

  Stream<List<Pergunta>> get perguntasStream => _perguntasController.stream;

  // Inserir nova pergunta
  Future<void> insertPergunta(Pergunta pergunta) async {
    try {
      await perguntasCollection.add(pergunta.toJson());
      // Recarregar perguntas após inserir
      await loadPerguntas();
    } catch (e) {
      throw Exception('Erro ao inserir pergunta: $e');
    }
  }

  // Responder pergunta
  Future<void> responderPergunta(String perguntaId, String resposta, int usuarioId) async {
    try {
      final agora = DateTime.now();
      await perguntasCollection.doc(perguntaId).update({
        'resposta': resposta,
        'respondidaPorUsuarioId': usuarioId,
        'dataResposta': '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}',
        'horaResposta': '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}',
      });
      // Recarregar perguntas após responder
      await loadPerguntas();
    } catch (e) {
      throw Exception('Erro ao responder pergunta: $e');
    }
  }

  // Carregar todas as perguntas
  Future<void> loadPerguntas() async {
    try {
      QuerySnapshot snapshot = await perguntasCollection
          .orderBy('timestamp', descending: true)
          .get();

      List<Pergunta> perguntas = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Adicionar o ID do documento
        return Pergunta.fromJson(data);
      }).toList();

      _perguntasController.add(perguntas);
    } catch (e) {
      throw Exception('Erro ao carregar perguntas: $e');
    }
  }

  // Obter perguntas de um usuário específico
  Future<List<Pergunta>> getPerguntasDoUsuario(int usuarioId) async {
    try {
      QuerySnapshot snapshot = await perguntasCollection
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Pergunta.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar perguntas do usuário: $e');
    }
  }

  // Fechar stream quando não precisar mais
  void dispose() {
    _perguntasController.close();
  }
}