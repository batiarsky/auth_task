import 'package:auth_task/db/database.dart';
import 'file:///D:/FlutterProjects/auth_task/lib/model/user_entity.dart';
import 'package:auth_task/ui/home_page/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final DBProvider _dbProvider = DBProvider();

  HomeCubit() : super(HomeStartState());
  UserEntity _user;

  getUser() async {
    try {
      _user = await _dbProvider.getUser();
      emit(HomeUserFetchedState(user: _user));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  backToAuth() async {
    try {
      final int _deletedRow = await _dbProvider.updateUser(_user);
      if (_deletedRow != null) {
        emit(HomeExitState());
      } else {
        emit(HomeErrorState("User token was not removed"));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
