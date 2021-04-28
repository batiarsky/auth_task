import 'package:auth_task/db/database.dart';
import 'file:///D:/FlutterProjects/auth_task/lib/model/user_entity.dart';
import 'package:auth_task/services/login_service.dart';
import 'package:auth_task/ui/login_page/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final _loginService = LoginService();
  final DBProvider _dbProvider = DBProvider();

  LoginCubit() : super(StartState()) {
    checkUserAuthorization();
  }

  checkUserAuthorization() async {
    try {
      final user = await _dbProvider.getUser();
      if (user.token != null && user.token.isNotEmpty) {
        emit(LoginSuccessfulState());
        return;
      } else if (user.isRememberedCredentials == true) {
        emit(CredentialState(
            login: user.email,
            password: user.password,
            isRememberChecked: user.isRememberedCredentials));
      } else {
        emit(CredentialState(login: "", password: "", isRememberChecked: false));
      }
    } catch (e) {
      emit(LoginErrorState("Error during fetching user"));
    }
  }

  onSignIn(final String login, final String password,
      final bool isRememberChecked) async {
    try {
      emit(ProgressIndicatorState());
      final _authModel = await _loginService.onSignIn(login, password);
      final _userEntity = await _dbProvider.insertUser(UserEntity(
          email: login,
          password: password,
          token: _authModel.token,
          duration: _authModel.duration,
          isRememberedCredentials: isRememberChecked));
      if (_userEntity != null) {
        emit(LoginSuccessfulState());
      } else {
        emit(LoginErrorState("Error during saving user"));
      }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  updateUser(final bool isRememberChecked) async {
    final user = await _dbProvider.getUser();
    final email = user.email;
    final password = user.password;

    await _dbProvider.updateUser(UserEntity(
        email: email,
        password: password,
        token: user.token,
        duration: user.duration,
        isRememberedCredentials: isRememberChecked));
    emit(CredentialState(
        login: email,
        password: password,
        isRememberChecked: isRememberChecked));
  }
}
