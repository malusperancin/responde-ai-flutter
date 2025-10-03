import 'package:flutter/material.dart';

class PerfilCadastroView extends StatefulWidget {
  final Function(String nome, String email, String senha) onCadastroSuccess;
  final Function(String mensagem) onCadastroError;

  const PerfilCadastroView({
    super.key,
    required this.onCadastroSuccess,
    required this.onCadastroError,
  });

  @override
  State<PerfilCadastroView> createState() => _PerfilCadastroViewState();
}

class _PerfilCadastroViewState extends State<PerfilCadastroView> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _tentarCadastro() async {
    if (_nomeController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _senhaController.text.isEmpty) {
      widget.onCadastroError('Por favor, preencha todos os campos.');
      return;
    }

    if (_senhaController.text.length < 6) {
      widget.onCadastroError('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      await widget.onCadastroSuccess(
        _nomeController.text,
        _emailController.text,
        _senhaController.text,
      );
    } catch (e) {
      widget.onCadastroError('Erro ao fazer cadastro: $e');
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Stack(
        children: [
          // Estrutura base com cabeçalho azul e área cinza
          Column(
            children: [
              // Cabeçalho azul - ocupa cerca de 60% da tela
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                color: const Color(0xFF4F82B2),
              ),
              
              // Área cinza claro - ocupa o restante da tela
              Expanded(
                child: Container(
                  color: const Color(0xFFEEEEEE),
                ),
              ),
            ],
          ),
          
          Positioned(
            left: 32,
            right: 32,
            top: MediaQuery.of(context).size.height * 0.05,
            child: const Text(
              'Cadastre-se',
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Positioned(
            left: 32,
            right: 32,
            top: MediaQuery.of(context).size.height * 0.15,
            child: const Text(
              'Cadastre-se para continuar:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Formulário de cadastro - sobreposto na área de transição
          Positioned(
            left: 32,
            right: 32,
            top: MediaQuery.of(context).size.height * 0.25,
            child: Container(
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
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Nome completo:',
                      style: TextStyle(
                        color: Color(0xFF595959),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'E-mail:',
                      style: TextStyle(
                        color: Color(0xFF595959),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Senha:',
                      style: TextStyle(
                        color: Color(0xFF595959),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _senhaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintText: 'Mínimo 6 caracteres',
                      ),
                      obscureText: true,
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          
          // Botão Continuar na parte inferior
          Positioned(
            left: 32,
            right: 32,
            bottom: 40,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _carregando ? null : _tentarCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F82B2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _carregando 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}