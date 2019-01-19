import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user.dart';
import '../resources/repository.dart';

class UserBloc {
  final _repository = Repository();
  final _userInfoFetcher = PublishSubject<User>();

  Observable<User> get userStream => _userInfoFetcher.stream;

  fetchUserInfo(BuildContext context) async {
    User userModel = await _repository.fetchUserInfo(context);
    _userInfoFetcher.sink.add(userModel);
  }



  dispose() {
    _userInfoFetcher.close();
  }

}

final userBloc = UserBloc();
