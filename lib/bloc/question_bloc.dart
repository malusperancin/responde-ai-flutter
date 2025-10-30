import 'package:bloc/bloc.dart';
import '../model/question.dart';
import '../provider/firestore_provider.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionLoadedState([])) {
    FirestoreProvider.helper.questionsStream.listen((List<Question> event) {
      add(QuestionsFromBackendEvent(questions: event));
    });

    on<SubmitQuestionEvent>((event, emit) async {
      emit(QuestionLoadingState());
      try {
        await FirestoreProvider.helper.insertQuestion(event.question);
        emit(QuestionSuccessState());
      } catch (e) {
        emit(QuestionErrorState('Erro ao enviar pergunta: $e'));
      }
    });

    on<QuestionsFromBackendEvent>((event, emit) {
      emit(QuestionLoadedState(event.questions));
    });

    on<AnswerQuestionEvent>((event, emit) async {
      emit(QuestionLoadingState());
      try {
        await FirestoreProvider.helper.answerQuestion(
          event.questionId,
          event.answer,
          event.userId,
        );
        emit(QuestionSuccessState());
      } catch (e) {
        emit(QuestionErrorState('Erro ao responder pergunta: $e'));
      }
    });

    on<LoadQuestionsEvent>((event, emit) async {
      emit(QuestionLoadingState());
      try {
        await FirestoreProvider.helper.loadQuestions();
      } catch (e) {
        emit(QuestionErrorState('Erro ao carregar perguntas: $e'));
      }
    });
  }
}

abstract class QuestionEvent {}

class SubmitQuestionEvent extends QuestionEvent {
  final Question question;
  SubmitQuestionEvent({required this.question});
}

class QuestionsFromBackendEvent extends QuestionEvent {
  final List<Question> questions;
  QuestionsFromBackendEvent({required this.questions});
}

class AnswerQuestionEvent extends QuestionEvent {
  final String questionId;
  final String answer;
  final String userId;
  AnswerQuestionEvent({
    required this.questionId,
    required this.answer,
    required this.userId,
  });
}

class LoadQuestionsEvent extends QuestionEvent {}

abstract class QuestionState {}

class QuestionLoadingState extends QuestionState {}

class QuestionLoadedState extends QuestionState {
  final List<Question> questions;
  QuestionLoadedState(this.questions);
}

class QuestionSuccessState extends QuestionState {}

class QuestionErrorState extends QuestionState {
  final String message;
  QuestionErrorState(this.message);
}