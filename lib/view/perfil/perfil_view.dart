import 'package:flutter/material.dart';
import '../../control/usuario_controller.dart';
import 'perfil_deslogado_view.dart';
import 'perfil_login_view.dart';
import 'perfil_cadastro_view.dart';
import 'perfil_logado_view.dart';
import '../shared/shared.dart';

enum PerfilEstado {
  deslogado,
  login,
  cadastro,
  logado,
}

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  PerfilEstado _estado = PerfilEstado.deslogado;
  final UsuarioController _usuarioController = UsuarioController();

  @override
  void initState() {
    super.initState();
    // Verifica se já existe usuário logado
    if (_usuarioController.estaLogado) {
      _estado = PerfilEstado.logado;
    }
  }

  void _alternarParaLogin() {
    setState(() {
      _estado = PerfilEstado.login;
    });
  }

  void _alternarParaCadastro() {
    setState(() {
      _estado = PerfilEstado.cadastro;
    });
  }

  void _realizarLogin(String email, String senha) async {
    final sucesso = await _usuarioController.login(email, senha);
    if (sucesso) {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Login realizado com sucesso!',
        textoBotao: 'OK',
        onPressed: () {
          Navigator.of(context).pop(); // Fecha o modal
          setState(() {
            _estado = PerfilEstado.logado;
          });
        },
      );
    } else {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Email ou senha incorretos.',
        textoBotao: 'OK',
      );
    }
  }

  void _realizarCadastro(String nome, String email, String senha) async {
    final sucesso = await _usuarioController.cadastrar(nome, email, senha);
    if (sucesso) {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Cadastro realizado com sucesso!',
        textoBotao: 'OK',
        onPressed: () {
          Navigator.of(context).pop(); // Fecha o modal
          setState(() {
            _estado = PerfilEstado.logado;
          });
        },
      );
    } else {
      ModalPersonalizado.mostrar(
        context,
        texto: 'Este email já está cadastrado.',
        textoBotao: 'OK',
      );
    }
  }

  void _sair() {
    _usuarioController.logout();
    setState(() {
      _estado = PerfilEstado.deslogado;
    });
  }

  void _atualizarUsuario(String nome, String email) async {
    final sucesso = await _usuarioController.atualizarUsuario(nome, email);
    if (sucesso) setState(() {});
    
  }

  void _mostrarErro(String mensagem) {
    ModalPersonalizado.mostrar(
      context,
      texto: mensagem,
      textoBotao: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    
    switch (_estado) {
      case PerfilEstado.deslogado:
        return PerfilDeslogadoView(
          onLoginPressed: _alternarParaLogin,
          onCadastroPressed: _alternarParaCadastro,
        );
      case PerfilEstado.login:
        return PerfilLoginView(
          onLoginSuccess: _realizarLogin,
          onLoginError: _mostrarErro,
        );
      case PerfilEstado.cadastro:
        return PerfilCadastroView(
          onCadastroSuccess: _realizarCadastro,
          onCadastroError: _mostrarErro,
        );
      case PerfilEstado.logado:
        final usuario = _usuarioController.usuarioLogado!;
        return PerfilLogadoView(
          nome: usuario.nome,
          email: usuario.email,
          onLogout: () => _sair(),
          onUpdateUser: _atualizarUsuario,
        );
    }
  }
}