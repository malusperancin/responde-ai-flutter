import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responde_ai/bloc/auth_bloc.dart';
import 'profile_logged_out_view.dart';
import 'profile_login_view.dart';
import 'profile_sign_up_view.dart';
import 'profile_logged_in_view.dart';
import '../shared/shared.dart';

enum ProfileState {
  loggedOut,
  login,
  signUp,
  loggedIn,
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileState _estado = ProfileState.loggedOut;

  void _switchToLogin() {
    setState(() {
      _estado = ProfileState.login;
    });
  }

  void _switchToSignUp() {
    setState(() {
      _estado = ProfileState.signUp;
    });
  }

  void _performLogin(String email, String password) {
    context.read<AuthBloc>().add(LoginUser(email: email, password: password));
  }

  void _performSignUp(String name, String email, String password) {
    context.read<AuthBloc>().add(
      RegisterUser(name: name, email: email, password: password),
    );
  }

  void _logout() {
    context.read<AuthBloc>().add(Logout());
    setState(() {
      _estado = ProfileState.loggedOut;
    });
  }

  void _updateUser(String name) {
    context.read<AuthBloc>().add(
      UpdateUserProfile(name: name),
    );
  }

  void _showError(String message) {
    CustomModal.show(
      context,
      text: message,
      buttonText: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() {
            _estado = ProfileState.loggedIn;
          });
        } else if (state is Unauthenticated) {
          setState(() {
            _estado = ProfileState.loggedOut;
          });
        } else if (state is AuthError) {
          CustomModal.show(
            context,
            text: state.message,
            buttonText: 'OK',
          );
        } else if (state is AuthSuccess) {
          CustomModal.show(
            context,
            text: state.message,
            buttonText: 'OK',
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is Authenticated) {
            return ProfileLoggedInView(
              name: state.user.name,
              email: state.user.email,
              onLogout: _logout,
              onUpdateUser: _updateUser,
            );
          }

          switch (_estado) {
            case ProfileState.loggedOut:
              return ProfileLoggedOutView(
                onLoginPressed: _switchToLogin,
                onSignUpPressed: _switchToSignUp,
              );
            case ProfileState.login:
              return ProfileLoginView(
                onLoginSuccess: _performLogin,
                onLoginError: _showError,
              );
            case ProfileState.signUp:
              return ProfileSignUpView(
                onSignUpSuccess: _performSignUp,
                onSignUpError: _showError,
              );
            case ProfileState.loggedIn:
              return ProfileLoggedOutView(
                onLoginPressed: _switchToLogin,
                onSignUpPressed: _switchToSignUp,
              );
          }
        },
      ),
    );
  }
}