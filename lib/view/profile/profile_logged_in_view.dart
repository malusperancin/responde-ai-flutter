import 'package:flutter/material.dart';
import '../shared/shared.dart';

class ProfileLoggedInView extends StatefulWidget {
  final String name;
  final String email;
  final VoidCallback onLogout;
  final Function(String name)? onUpdateUser;

  const ProfileLoggedInView({
    super.key,
    required this.name,
    required this.email,
    required this.onLogout,
    this.onUpdateUser,
  });

  @override
  State<ProfileLoggedInView> createState() => _ProfileLoggedInViewState();
}

class _ProfileLoggedInViewState extends State<ProfileLoggedInView> {
  late TextEditingController _nameController;
  bool _editingName = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  void didUpdateWidget(ProfileLoggedInView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      _nameController.text = widget.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (widget.onUpdateUser == null) return;

    setState(() {
      _loading = true;
    });

    try {
      await widget.onUpdateUser!(_nameController.text);
      setState(() {
        _editingName = false;
      });
    } catch (e) {
      if (mounted) {
        CustomModal.show(
          context,
          text: 'Erro ao atualizar dados: $e',
          buttonText: 'Tentar novamente',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _nameController.text = widget.name;
      _editingName = false;
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
                      if (!_editingName)
                        IconButton(
                          onPressed: () => setState(() => _editingName = true),
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF4F82B2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_editingName)
                    TextField(
                      controller: _nameController,
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
                        widget.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Email é apenas visualização, não pode ser editado
                  const Text(
                    'Email:',
                    style: TextStyle(
                      color: Color(0xFF595959),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFFF5F5F5), // Fundo cinza para indicar que é só leitura
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.email,
                            style: const TextStyle(fontSize: 16, color: Color(0xFF595959)),
                          ),
                        ),
                        const Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: Color(0xFF999999),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'O email não pode ser alterado',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_editingName)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loading ? null : _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFA67F52),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _loading
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
                            onPressed: _loading ? null : _cancelEdit,
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
                  const SizedBox(height: 32),
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
