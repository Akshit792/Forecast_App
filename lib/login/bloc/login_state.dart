abstract class LoginState {}

class InitialLoginState extends LoginState {}

class ValidateLoginState extends LoginState {}

class CheckDataLoginState extends LoginState {}

class ErrorLoginState extends LoginState {
  final String errorMessage;

  ErrorLoginState({required this.errorMessage});
}
