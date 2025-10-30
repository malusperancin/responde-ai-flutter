import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/question_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../model/question.dart';
import '../shared/shared.dart';

class NewQuestionView extends StatefulWidget {
  const NewQuestionView({super.key});

  @override
  State<NewQuestionView> createState() => _NewQuestionViewState();
}

class _NewQuestionViewState extends State<NewQuestionView> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitQuestion() {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! Authenticated) {
      CustomModal.show(
        context,
        text: 'Você precisa estar logado para fazer uma pergunta.',
        buttonText: 'OK',
      );
      return;
    }

    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      CustomModal.show(
        context,
        text: 'Por favor, descreva sua pergunta.',
        buttonText: 'OK',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final question = Question(
        id: '',
        userId: authState.user.uid,
        date: '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
        time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        description: description,
        timestamp: now,
      );

      context.read<QuestionBloc>().add(SubmitQuestionEvent(question: question));
    } catch (e) {
      CustomModal.show(
        context,
        text: 'Erro inesperado. Tente novamente.',
        buttonText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isLoggedIn = authState is Authenticated;

        return BlocListener<QuestionBloc, QuestionState>(
      listener: (context, state) {
        if (state is QuestionSuccessState) {
          setState(() {
            _isLoading = false;
          });
          CustomModal.show(
            context,
            text: 'Pergunta enviada com sucesso!',
            buttonText: 'OK',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              _descriptionController.clear();
            },
          );
        } else if (state is QuestionErrorState) {
          setState(() {
            _isLoading = false;
          });
          CustomModal.show(
            context,
            text: 'Erro ao enviar pergunta: ${state.message}',
            buttonText: 'OK',
          );
        } else if (state is QuestionLoadingState) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Nova Pergunta', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF4F82B2),
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8),
                  child: Text(
                    'Qual a sua pergunta?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF595959),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    minLines: 6,
                    maxLines: 10,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Escreva aqui sua pergunta com detalhes.',
                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: 380,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F82B2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Enviar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (!isLoggedIn)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Você precisa estar logado para criar uma pergunta.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
      },
    );
  }
}
