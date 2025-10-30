import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responde_ai/view/questions/widgets/widgets.dart';
import '../../bloc/question_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../model/question.dart';

class QuestionsView extends StatefulWidget {
  const QuestionsView({super.key});

  @override
  State<QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isLoggedIn = authState is Authenticated;

        return BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            if (state is QuestionLoadingState) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is QuestionErrorState) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Erro: ${state.message}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<QuestionBloc>().add(LoadQuestionsEvent());
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final questions = (state is QuestionLoadedState) ? state.questions : <Question>[];
            final unansweredQuestions = questions.where((q) => q.answer == null).toList();
            final answeredQuestions = questions.where((q) => q.answer != null).toList();

            return Scaffold(
              floatingActionButton: isLoggedIn ? const AskButton() : null,
              backgroundColor: const Color(0xFFE8E8E8),
              appBar: AppBar(
                backgroundColor: const Color(0xFF4F82B2),
                elevation: 0,
                automaticallyImplyLeading: false,
                title: const Text(
                  'Perguntas',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(
                      text: 'Não Respondidas (${unansweredQuestions.length})',
                    ),
                    Tab(
                      text: 'Respondidas (${answeredQuestions.length})',
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  if (!isLoggedIn)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Faça login para criar perguntas e responder questões.',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildQuestionList(unansweredQuestions, false, isLoggedIn, authState),
                      _buildQuestionList(answeredQuestions, true, isLoggedIn, authState),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
    );
  }

  Widget _buildQuestionList(List<Question> questions, bool answered, bool isLoggedIn, AuthState authState) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: QuestionAnswerCard(
            question: question,
            onAnswer: isLoggedIn && !answered
                ? (answer) {
                    final user = (authState as Authenticated).user;
                    context.read<QuestionBloc>().add(AnswerQuestionEvent(
                      questionId: question.id,
                      answer: answer,
                      userId: user.uid,
                    ));
                  }
                : null,
          ),
        );
      },
    );
  }
}