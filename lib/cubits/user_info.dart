import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentUserInfoCubit extends Cubit<CurrentUserInfoState> {
  CurrentUserInfoCubit() : super(CurrentUserInfoInitial());

  void onLoad(String userName) {
    emit(CurrentUserInfo(userName));
  }
}

@immutable
abstract class CurrentUserInfoState {}

class CurrentUserInfoInitial extends CurrentUserInfoState {}

class CurrentUserInfo extends CurrentUserInfoState {
  late String userName;

  CurrentUserInfo(this.userName);
}
