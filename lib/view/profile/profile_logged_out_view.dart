import 'package:flutter/material.dart';

class ProfileLoggedOutView extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;

  const ProfileLoggedOutView({
    super.key,
    required this.onLoginPressed,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Stack(
        children: [
          Column(
            children: [
              // Área azul - ocupa cerca de 60% da tela
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                color: const Color(0xFF4F82B2),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Center(
                  child: Text(
                    'Faça Login ou\nCadastre-se\npara continuar',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              // Área cinza claro - ocupa o restante da tela
              Expanded(
                child: Container(
                  color: const Color(0xFFEEEEEE),
                ),
              ),
            ],
          ),
                    
          // Botões Login e Cadastro - posicionados sobre a parte azul
          Positioned(
            left: 32,
            right: 32,
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onLoginPressed,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            bottomLeft: Radius.circular(28),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF4F82B2),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  // Divisor vertical
                  Container(
                    width: 1,
                    height: 36,
                    color: const Color(0xFFDDDDDD),
                  ),
                  
                  Expanded(
                    child: TextButton(
                      onPressed: onSignUpPressed,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            topRight: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF4F82B2),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}