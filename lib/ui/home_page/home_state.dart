import 'file:///D:/FlutterProjects/auth_task/lib/model/user_entity.dart';

abstract class HomeState {}

class HomeStartState extends HomeState {}

class HomeUserFetchedState extends HomeState {
  final UserEntity user;

  HomeUserFetchedState({this.user});
}

class HomeExitState extends HomeState {}


class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState(this.message);
}