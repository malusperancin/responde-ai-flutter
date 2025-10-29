
class Pergunta {
  final String id;
  final int usuarioId;
  final String data;
  final String hora;
  final String descricao;
  final String? resposta;
  final int? respondidaPorUsuarioId;
  final String? dataResposta;
  final String? horaResposta;
  final DateTime? timestamp;

  Pergunta({
    required this.id,
    required this.usuarioId,
    required this.data,
    required this.hora,
    required this.descricao,
    this.resposta,
    this.respondidaPorUsuarioId,
    this.dataResposta,
    this.horaResposta,
    this.timestamp,
  });

  factory Pergunta.fromJson(Map<String, dynamic> json) {
    return Pergunta(
      id: json['id'] ?? '',
      usuarioId: json['usuarioId'] ?? 0,
      data: json['data'] ?? '',
      hora: json['hora'] ?? '',
      descricao: json['descricao'] ?? '',
      resposta: json['resposta'],
      respondidaPorUsuarioId: json['respondidaPorUsuarioId'],
      dataResposta: json['dataResposta'],
      horaResposta: json['horaResposta'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'data': data,
      'hora': hora,
      'descricao': descricao,
      'resposta': resposta,
      'respondidaPorUsuarioId': respondidaPorUsuarioId,
      'dataResposta': dataResposta,
      'horaResposta': horaResposta,
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
    };
  }

  Pergunta copyWith({
    String? id,
    int? usuarioId,
    String? data,
    String? hora,
    String? descricao,
    String? resposta,
    int? respondidaPorUsuarioId,
    String? dataResposta,
    String? horaResposta,
    DateTime? timestamp,
  }) {
    return Pergunta(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      data: data ?? this.data,
      hora: hora ?? this.hora,
      descricao: descricao ?? this.descricao,
      resposta: resposta ?? this.resposta,
      respondidaPorUsuarioId: respondidaPorUsuarioId ?? this.respondidaPorUsuarioId,
      dataResposta: dataResposta ?? this.dataResposta,
      horaResposta: horaResposta ?? this.horaResposta,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
