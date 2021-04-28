abstract class LoginState{}

class StartState extends LoginState {}

class ProgressIndicatorState extends LoginState {}

class LoginSuccessfulState extends LoginState {}

class CredentialState extends LoginState {
  String login;
  String password;
  bool isRememberChecked;

  CredentialState({this.login, this.password, this.isRememberChecked});
}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}