import 'package:flutter/material.dart';
import '../shared/shared.dart';

class PerfilLogadoView extends StatefulWidget {
  final String nome;
  final String email;
  final VoidCallback onLogout;
  final Function(String nome, String email)? onUpdateUser;

  const PerfilLogadoView({
    super.key,
    required this.nome,
    required this.email,
    required this.onLogout,
    this.onUpdateUser,
  });

  @override
  State<PerfilLogadoView> createState() => _PerfilLogadoViewState();
}

class _PerfilLogadoViewState extends State<PerfilLogadoView> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  bool _editandoNome = false;
  bool _editandoEmail = false;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nome);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void didUpdateWidget(PerfilLogadoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza os controllers quando os dados do widget mudarem
    if (oldWidget.nome != widget.nome || oldWidget.email != widget.email) {
      _nomeController.text = widget.nome;
      _emailController.text = widget.email;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _salvarAlteracoes() async {
    if (widget.onUpdateUser == null) return;

    setState(() {
      _carregando = true;
    });

    try {
      await widget.onUpdateUser!(_nomeController.text, _emailController.text);
      setState(() {
        _editandoNome = false;
        _editandoEmail = false;
      });

      if (mounted) {
        ModalPersonalizado.mostrar(
          context,
          texto: 'Dados atualizados com sucesso!',
          textoBotao: 'Concluído',
        );
      }
    } catch (e) {
      if (mounted) {
        ModalPersonalizado.mostrar(
          context,
          texto: 'Erro ao atualizar dados: $e',
          textoBotao: 'Tentar novamente',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _cancelarEdicao() {
    setState(() {
      _nomeController.text = widget.nome;
      _emailController.text = widget.email;
      _editandoNome = false;
      _editandoEmail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF4F82B2),
            padding: const EdgeInsets.all(24),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  'Dados Pessoais',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nome:',
                        style: TextStyle(
                          color: Color(0xFF595959),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      if (!_editandoNome)
                        IconButton(
                          onPressed: () => setState(() => _editandoNome = true),
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF4F82B2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_editandoNome)
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.nome,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Campo Email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Email:',
                        style: TextStyle(
                          color: Color(0xFF595959),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      if (!_editandoEmail)
                        IconButton(
                          onPressed: () =>
                              setState(() => _editandoEmail = true),
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF4F82B2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_editandoEmail)
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCCCCCC)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 24),

                  if (_editandoNome || _editandoEmail)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _carregando ? null : _salvarAlteracoes,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFA67F52),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _carregando
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _carregando ? null : _cancelarEdicao,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const Spacer(),

                  // Botão Sair
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F82B2),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
