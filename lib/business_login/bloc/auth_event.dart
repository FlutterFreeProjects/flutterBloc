part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}
//  User signing in with email and password 
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

// User signing up with email and password 
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
}

// User signing in with google 
class GoogleSignInRequested extends AuthEvent {}

// User signing out 
class SignOutRequested extends AuthEvent {}