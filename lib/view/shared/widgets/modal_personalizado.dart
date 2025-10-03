import 'package:flutter/material.dart';

class ModalPersonalizado extends StatelessWidget {
  final String texto;
  final String textoBotao;
  final VoidCallback? onPressed;

  const ModalPersonalizado({
    super.key,
    required this.texto,
    required this.textoBotao,
    this.onPressed,
  });

  static void mostrar(
    BuildContext context, {
    required String texto,
    required String textoBotao,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ModalPersonalizado(
          texto: texto,
          textoBotao: textoBotao,
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: const Color(0xFFA67F52),
      child: Container(
        padding: const EdgeInsets.all(14),
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texto,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8A082),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0
                ),
                child: Text(
                  textoBotao,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}