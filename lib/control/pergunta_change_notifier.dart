import 'package:flutter/material.dart';
import '../model/pergunta.dart';
import '../control/usuario_controller.dart';

class PerguntaChangeNotifier extends ChangeNotifier {
  final UsuarioController _usuarioController = UsuarioController();

  // Lista de perguntas mockadas enquanto não há backend
  final List<Pergunta> _perguntas = [
    Pergunta(
      id: 1,
      usuarioId: 1,
      data: '02/10',
      hora: '14:30',
      descricao: "Meu carro está fazendo um barulho estranho no motor quando acelero. Será que pode ser problema no sistema de refrigeração? Estou preocupada pois preciso viajar no fim de semana.",
      resposta: "Esse barulho pode indicar alguns problemas. Recomendo verificar o nível do líquido de arrefecimento e se há vazamentos. É melhor levar a um mecânico antes da viagem para evitar problemas maiores.",
      respondidaPorUsuarioId: 2,
      dataResposta: '02/10',
      horaResposta: '15:45',
    ),
    Pergunta(
      id: 2,
      usuarioId: 2,
      data: '02/10',
      hora: '09:15',
      descricao: 'Como posso otimizar meu computador que está muito lento? Ele tem 8GB de RAM e SSD, mas demora muito para abrir programas.',
      resposta: null,
    ),
    Pergunta(
      id: 3,
      usuarioId: 1,
      data: '01/10',
      hora: '20:22',
      descricao: 'Estou com dor de cabeça constante há 3 dias e tomando bastante água, mas não melhora. Devo me preocupar ou é normal?',
      resposta: 'Dor de cabeça persistente por mais de 3 dias merece atenção médica. Recomendo procurar um clínico geral para avaliar possíveis causas e orientar o tratamento adequado.',
      respondidaPorUsuarioId: 3,
      dataResposta: '01/10',
      horaResposta: '21:10',
    ),
    Pergunta(
      id: 4,
      usuarioId: 3,
      data: '01/10',
      hora: '16:45',
      descricao: 'Qual a melhor forma de organizar os cabos atrás da minha mesa de trabalho home office? Está uma bagunça total e atrapalha a limpeza.',
      resposta: null,
    ),
    Pergunta(
      id: 5,
      usuarioId: 2,
      data: '30/09',
      hora: '11:30',
      descricao: 'Meu notebook esquenta muito quando uso programas pesados. Isso pode danificar os componentes? Como resolver?',
      resposta: 'Superaquecimento pode sim danificar componentes. Verifique se as entradas de ar não estão obstruídas, limpe o cooler e considere usar uma base refrigerada. Se persistir, pode ser necessário trocar a pasta térmica.',
      respondidaPorUsuarioId: 1,
      dataResposta: '30/09',
      horaResposta: '13:20',
    ),
    Pergunta(
      id: 6,
      usuarioId: 1,
      data: '29/09',
      hora: '19:15',
      descricao: 'Como tirar manchas de gordura do sofá de tecido? Tentei com detergente mas não saiu completamente.',
      resposta: null,
    ),
    Pergunta(
      id: 7,
      usuarioId: 3,
      data: '29/09',
      hora: '08:45',
      descricao: 'É normal sentir tontura após fazer exercícios físicos intensos? Comecei academia recentemente.',
      resposta: 'Tontura pós-exercício pode indicar desidratação, hipoglicemia ou esforço excessivo. Hidrate-se bem, alimente-se adequadamente antes do treino e aumente a intensidade gradualmente. Se persistir, consulte um médico.',
      respondidaPorUsuarioId: 2,
      dataResposta: '29/09',
      horaResposta: '10:30',
    ),
  ];

  int _proximoId = 8;

  List<Pergunta> get perguntas => List.unmodifiable(_perguntas);

  List<Pergunta> get perguntasNaoRespondidas => 
      _perguntas.where((p) => p.resposta == null || p.resposta!.isEmpty).toList();

  List<Pergunta> get perguntasRespondidas => 
      _perguntas.where((p) => p.resposta != null && p.resposta!.isNotEmpty).toList();

  /// Adiciona uma nova pergunta - requer usuário logado
  bool adicionarPergunta({
    required String descricao,
  }) {
    final usuario = _usuarioController.usuarioLogado;
    if (usuario == null) {
      return false; // Usuário não está logado
    }

    final agora = DateTime.now();
    final pergunta = Pergunta(
      id: _proximoId++,
      usuarioId: usuario.id,
      data: '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}',
      hora: '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}',
      descricao: descricao,
    );

    _perguntas.add(pergunta);
    notifyListeners();
    return true;
  }

  bool responderPergunta(int perguntaId, String resposta) {    
    final usuario = _usuarioController.usuarioLogado;
    if (usuario == null) {
      return false;
    }

    final index = _perguntas.indexWhere((p) => p.id == perguntaId);
    if (index == -1) {
      return false;
    }

    final agora = DateTime.now();
    _perguntas[index] = _perguntas[index].copyWith(
      resposta: resposta,
      respondidaPorUsuarioId: usuario.id,
      dataResposta: '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}',
      horaResposta: '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}',
    );

    notifyListeners();
    return true;
  }
}
