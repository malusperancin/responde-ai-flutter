import 'package:responde_ai/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../provider/firestore_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  AuthBloc() : super(Unauthenticated()) {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _loadUser(currentUser);
    }

    _auth.authStateChanges().listen((firebase_auth.User? user) {
      if (user == null) {
        add(AuthServerEvent(null));
      } else {
        _loadUser(user);
      }
    });

    on<RegisterUser>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        await userCredential.user?.updateDisplayName(event.name);
        await userCredential.user?.reload();
        
        final userToLogin = User.login(
          uid: userCredential.user!.uid,
          email: userCredential.user?.email ?? '',
          name: event.name,
        );

        await FirestoreProvider.helper.saveUser(userToLogin);
        emit(Authenticated(user: userToLogin));

      } on firebase_auth.FirebaseAuthException catch (e) {
        emit(AuthError(message: _getErrorMessage(e.code)));
      } catch (e) {
        emit(AuthError(message: 'Erro ao criar conta: $e'));
      }
    });

    on<LoginUser>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        
        final user = await FirestoreProvider.helper.getUser(userCredential.user!.uid);
        
        if (user != null && user.name.isNotEmpty) {
          emit(Authenticated(user: user));
        } else {
          final displayName = userCredential.user?.displayName ?? '';
          final userAuth = User.login(
            uid: userCredential.user!.uid,
            email: userCredential.user?.email ?? '',
            name: displayName.isEmpty && user != null ? user.name : displayName,
          );

          if (user == null || user.name.isEmpty) {
            await FirestoreProvider.helper.saveUser(userAuth);
          }
          
          emit(Authenticated(user: userAuth));
        }
        
      } on firebase_auth.FirebaseAuthException catch (e) {
        emit(AuthError(message: _getErrorMessage(e.code)));
      } catch (e) {
        emit(AuthError(message: 'Erro ao fazer login: $e'));
      }
    });

    on<Logout>((event, emit) async {
      await _auth.signOut();
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = _auth.currentUser;
        if (user == null) {
          emit(AuthError(message: 'Usuário não autenticado'));
          return;
        }

        if (event.name != null) {
          await user.updateDisplayName(event.name);
        }

        await user.reload();
        final updatedUser = _auth.currentUser;
        
        final currentUser = await FirestoreProvider.helper.getUser(updatedUser!.uid);
        
        final data = <String, dynamic>{};
        if (event.name != null) data['name'] = event.name;
        
        await FirestoreProvider.helper.updateUser(updatedUser.uid, data);
        
        final updatedUserData = User.login(
          uid: currentUser!.uid,
          email: currentUser.email,
          name: event.name ?? currentUser.name,
        );
        add(AuthServerEvent(updatedUserData));
        
        emit(AuthSuccess(message: 'Perfil atualizado com sucesso!'));
      } on firebase_auth.FirebaseAuthException catch (e) {
        emit(AuthError(message: _getErrorMessage(e.code)));
      } catch (e) {
        emit(AuthError(message: 'Erro ao atualizar perfil: $e'));
      }
    });

    on<AuthServerEvent>((event, emit) {
      if (event.user == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(user: event.user!));
      }
    });
  }

  Future<void> _loadUser(firebase_auth.User firebaseUser) async {
    try {
      final user = await FirestoreProvider.helper.getUser(firebaseUser.uid);
      
      if (user != null && user.name.isNotEmpty) {
        add(AuthServerEvent(user));
      } else {
        final displayName = firebaseUser.displayName ?? '';
        final userAuth = User.login(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: displayName.isEmpty && user != null ? user.name : displayName,
        );
        
        if (user == null || user.name.isEmpty) {
          await FirestoreProvider.helper.saveUser(userAuth);
        }
        
        add(AuthServerEvent(userAuth));
      }
    } catch (e) {
      final userAuth = User.login(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? '',
      );
      add(AuthServerEvent(userAuth));
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este email já está em uso.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Email ou senha incorretos.';
      case 'invalid-credential':
        return 'Email ou senha incorretos.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      default:
        return 'Erro ao processar sua solicitação. Tente novamente.';
    }
  }
}

abstract class AuthEvent {}

class RegisterUser extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterUser({
    required this.name,
    required this.email,
    required this.password,
  });
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  LoginUser({required this.email, required this.password});
}

class Logout extends AuthEvent {}

class UpdateUserProfile extends AuthEvent {
  final String? name;
  final String? email;

  UpdateUserProfile({this.name, this.email});
}

class AuthServerEvent extends AuthEvent {
  final User? user;
  AuthServerEvent(this.user);
}

/*
 Estados
*/

abstract class AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated({required this.user});
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess({required this.message});
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
