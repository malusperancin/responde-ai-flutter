import 'package:responde_ai/model/usuario.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(Unauthenticated()) {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        add(AuthServerEvent(null));
      } else {
        final usuario = Usuario.login(
          email: user.email ?? '',
        );
        add(AuthServerEvent(usuario));
      }
    });

    on<RegisterUser>((event, emit) {
      auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    });

    on<LoginUser>((event, emit) {
      auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    });

    on<Logout>((event, emit) {
      auth.signOut();
    });

    on<AuthServerEvent>((event, emit) {
      if (event.user == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(user: event.user!));
      }
    });
  }
}

abstract class AuthEvent {}

class RegisterUser extends AuthEvent {
  String email;
  String password;

  RegisterUser({required this.email, required this.password});
}

class LoginUser extends AuthEvent {
  String email;
  String password;

  LoginUser({required this.email, required this.password});
}

class LoginAnonymousUser extends AuthEvent {}

class Logout extends AuthEvent {}

class AuthServerEvent extends AuthEvent {
  final Usuario? user;
  AuthServerEvent(this.user);
}

/*
 Estados
*/

abstract class AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  Usuario user;
  Authenticated({required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
