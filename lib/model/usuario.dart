
class Usuario {
  final int id;
  final String nome;
  final String email;
  final String senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  Usuario.login({
    required this.email,
  })  : id = 0,
        nome = '',
        senha = '';

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, email: $email}';
  }
}
