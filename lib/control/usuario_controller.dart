import '../model/usuario.dart';

class UsuarioController {
  static final UsuarioController _instance = UsuarioController._internal();
  factory UsuarioController() => _instance;
  UsuarioController._internal();

  // Lista de usuários mockados enquanto não há backend
  final List<Map<String, dynamic>> _usuariosMockados = [
    {
      'id': 1,
      'nome': 'Maria Silva',
      'email': 'maria@email.com',
      'senha': '123456'
    },
    {
      'id': 2,
      'nome': 'João Santos',
      'email': 'joao@email.com',
      'senha': 'senha123'
    },
    {
      'id': 3,
      'nome': 'Ana Costa',
      'email': 'ana@email.com',
      'senha': 'minhasenha'
    }
  ];

  Usuario? _usuarioLogado;

  int _proximoId = 4;

  Usuario? get usuarioLogado => _usuarioLogado;
  bool get estaLogado => _usuarioLogado != null;
  List<Usuario> get todosUsuarios => _usuariosMockados.map((json) => Usuario.fromJson(json)).toList();

  // Método para fazer login
  Future<bool> login(String email, String senha) async {
    try {
      final usuarioJson = _usuariosMockados.firstWhere(
        (user) => user['email'] == email && user['senha'] == senha,
      );
      
      _usuarioLogado = Usuario.fromJson(usuarioJson);
      return true;
    } catch (e) {
      return false; // Usuário não encontrado ou senha incorreta
    }
  }

  // Método para fazer cadastro
  Future<bool> cadastrar(String nome, String email, String senha) async {
    final emailJaExiste = _usuariosMockados.any((user) => user['email'] == email);
    if (emailJaExiste) {
      return false; // Não devemos repetir emails
    }

    final novoUsuario = {
      'id': _proximoId++,
      'nome': nome,
      'email': email,
      'senha': senha,
    };

    _usuariosMockados.add(novoUsuario); // Adiciona à lista de usuários mockados
    _usuarioLogado = Usuario.fromJson(novoUsuario); // Loga automaticamente após o cadastro

    return true;
  }

  // Método para fazer logout
  void logout() {
    _usuarioLogado = null;
  }
  
  // Método para atualizar dados do usuário
  Future<bool> atualizarUsuario(String nome, String email) async {
    if (_usuarioLogado == null) return false;
        
    final emailExisteEmOutroUsuario = _usuariosMockados.any(
      (user) => user['email'] == email && user['id'] != _usuarioLogado!.id,
    );
    
    if (emailExisteEmOutroUsuario) {
      return false;
    }

    final index = _usuariosMockados.indexWhere((user) => user['id'] == _usuarioLogado!.id);
    if (index != -1) {
      _usuariosMockados[index]['nome'] = nome;
      _usuariosMockados[index]['email'] = email;
      
      _usuarioLogado = Usuario.fromJson(_usuariosMockados[index]);
      return true;
    }
    
    return false;
  }
}