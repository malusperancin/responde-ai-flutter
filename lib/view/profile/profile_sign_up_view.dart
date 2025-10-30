import 'package:flutter/material.dart';

class ProfileSignUpView extends StatefulWidget {
  final Function(String name, String email, String password) onSignUpSuccess;
  final Function(String message) onSignUpError;

  const ProfileSignUpView({
    super.key,
    required this.onSignUpSuccess,
    required this.onSignUpError,
  });

  @override
  State<ProfileSignUpView> createState() => _ProfileSignUpViewState();
}

class _ProfileSignUpViewState extends State<ProfileSignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _tentarSignUp() async {
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      widget.onSignUpError('Por favor, preencha todos os campos.');
      return;
    }

    if (_passwordController.text.length < 6) {
      widget.onSignUpError('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      await widget.onSignUpSuccess(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      widget.onSignUpError('Erro ao fazer cadastro: $e');
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
          Column(
            children: [
              // Área azul - ocupa metade da tela
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
                    color: Colors.black.withValues(alpha: 0.1),
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
                      controller: _nameController,
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
                      controller: _passwordController,
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
          Positioned(
            left: 32,
            right: 32,
            bottom: 40,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _carregando ? null : _tentarSignUp,
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