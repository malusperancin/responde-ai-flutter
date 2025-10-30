import 'package:bloc/bloc.dart';
import '../model/pergunta.dart';
import '../provider/firestore_provider.dart';

class PerguntaBloc extends Bloc<PerguntaEvent, PerguntaState> {
  PerguntaBloc()
      : super(
          PerguntaLoadedState([]),
        ) {
    FirestoreProvider.helper.perguntasStream.listen((List<Pergunta> event) {
      add(PerguntasFromBackendEvent(perguntaList: event));
    });

    on<SubmitPerguntaEvent>((SubmitPerguntaEvent event, emit) async {
      emit(PerguntaLoadingState());
      try {
        await FirestoreProvider.helper.insertPergunta(event.pergunta);
        emit(PerguntaSuccessState());
      } catch (e) {
        emit(PerguntaErrorState('Erro ao enviar pergunta: $e'));
      }
    });

    on<PerguntasFromBackendEvent>((event, emit) {
      emit(PerguntaLoadedState(event.perguntaList));
    });

    on<ResponderPerguntaEvent>((event, emit) async {
      emit(PerguntaLoadingState());
      try {
        await FirestoreProvider.helper.responderPergunta(
          event.perguntaId, 
          event.resposta,
          event.usuarioId,
        );
        emit(PerguntaSuccessState());
      } catch (e) {
        emit(PerguntaErrorState('Erro ao responder pergunta: $e'));
      }
    });

    on<LoadPerguntasEvent>((event, emit) async {
      emit(PerguntaLoadingState());
      try {
        await FirestoreProvider.helper.loadPerguntas();
      } catch (e) {
        emit(PerguntaErrorState('Erro ao carregar perguntas: $e'));
      }
    });
  }
}

/*
 Eventos
*/
abstract class PerguntaEvent {}

class SubmitPerguntaEvent extends PerguntaEvent {
  Pergunta pergunta;
  SubmitPerguntaEvent({required this.pergunta});
}

class PerguntasFromBackendEvent extends PerguntaEvent {
  List<Pergunta> perguntaList;
  PerguntasFromBackendEvent({required this.perguntaList});
}

class ResponderPerguntaEvent extends PerguntaEvent {
  String perguntaId;
  String resposta;
  int usuarioId;
  ResponderPerguntaEvent({
    required this.perguntaId,
    required this.resposta,
    required this.usuarioId,
  });
}

class LoadPerguntasEvent extends PerguntaEvent {}

/*
 Estados
*/
abstract class PerguntaState {}

class PerguntaLoadingState extends PerguntaState {}

class PerguntaLoadedState extends PerguntaState {
  List<Pergunta> perguntaList;
  PerguntaLoadedState(this.perguntaList);
}

class PerguntaSuccessState extends PerguntaState {}

class PerguntaErrorState extends PerguntaState {
  String message;
  PerguntaErrorState(this.message);
}