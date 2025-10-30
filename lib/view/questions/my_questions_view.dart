import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responde_ai/view/questions/widgets/widgets.dart';
import '../../bloc/question_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../model/question.dart';

class MyQuestionsView extends StatefulWidget {
  const MyQuestionsView({super.key});

  @override
  State<MyQuestionsView> createState() => _MyQuestionsViewState();
}

class _MyQuestionsViewState extends State<MyQuestionsView>
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

  List<Question> _filterMyQuestions(
    List<Question> allQuestions,
    bool answered,
    String? userId,
  ) {
    if (userId == null) return [];

    return allQuestions
        .where((question) => question.userId == userId)
        .where(
          (question) => answered
              ? question.answer != null
              : question.answer == null,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isLoggedIn = authState is Authenticated;

        if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: const Color(0xFFE8E8E8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4F82B2),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Minhas Perguntas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
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
                  child: Column(
                    children: [
                      const Icon(
                        Icons.login,
                        size: 64,
                        color: Color(0xFF4F82B2),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Faça login para ver suas perguntas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF595959),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Aqui você poderá acompanhar todas as suas perguntas e respostas organizadas em um só lugar.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocBuilder<QuestionBloc, QuestionState>(
      builder: (context, state) {
        if (state is QuestionLoadingState) {
          return Scaffold(
            backgroundColor: const Color(0xFFE8E8E8),
            appBar: AppBar(
              backgroundColor: const Color(0xFF4F82B2),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text(
                'Minhas Perguntas',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is QuestionErrorState) {
          return Scaffold(
            backgroundColor: const Color(0xFFE8E8E8),
            appBar: AppBar(
              backgroundColor: const Color(0xFF4F82B2),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text(
                'Minhas Perguntas',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
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

        final allQuestions = (state is QuestionLoadedState) ? state.questions : <Question>[];

        final authenticatedState = authState;
        final currentUserId = authenticatedState.user.uid;
        final unansweredQuestions = _filterMyQuestions(
          allQuestions,
          false,
          currentUserId,
        );
        final answeredQuestions = _filterMyQuestions(allQuestions, true, currentUserId);

        return Scaffold(
          floatingActionButton: isLoggedIn ? const AskButton() : null,
          backgroundColor: const Color(0xFFE8E8E8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF4F82B2),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Minhas Perguntas',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Não Respondidas (${unansweredQuestions.length})'),
                Tab(text: 'Respondidas (${answeredQuestions.length})'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildQuestionList(unansweredQuestions, false, isLoggedIn, authState),
              _buildQuestionList(answeredQuestions, true, isLoggedIn, authState),
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
          child: Column(
            children: [
              QuestionAnswerCard(
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
            ],
          ),
        );
      },
    );
  }
}
