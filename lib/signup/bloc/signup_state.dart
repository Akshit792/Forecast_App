abstract class SignUpState {}

class InitialSignUpState extends SignUpState {}

class LoadingSignUpState extends SignUpState {}

class LoadedSignUpState extends SignUpState {}

class ValidateSignUpState extends SignUpState {}

class ErrorSignUpState extends SignUpState {
  final String errorMessage;

  ErrorSignUpState({required this.errorMessage});
}
