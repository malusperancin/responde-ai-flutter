import 'package:flutter/material.dart';

class ProfileLoginView extends StatefulWidget {
  final Function(String email, String password) onLoginSuccess;
  final Function(String message) onLoginError;

  const ProfileLoginView({
    super.key,
    required this.onLoginSuccess,
    required this.onLoginError,
  });

  @override
  State<ProfileLoginView> createState() => _ProfileLoginViewState();
}

class _ProfileLoginViewState extends State<ProfileLoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _tryLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      widget.onLoginError('Por favor, preencha todos os campos.');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await widget.onLoginSuccess(_emailController.text, _passwordController.text);
    } catch (e) {
      widget.onLoginError('Erro ao fazer login: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
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
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.40,
                color: const Color(0xFF4F82B2)
              ),
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
              'Login',
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
              'Faça Login para continuar:',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    ),
                    obscureText: true,
                  ),
                  
                  const SizedBox(height: 24),
                ],
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
                onPressed: _loading ? null : _tryLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F82B2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _loading 
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