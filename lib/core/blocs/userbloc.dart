import 'package:flutter/material.dart';
import 'package:rotaract_app/core/models/userInfo.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class UserBloc {
  final _repository = Repository();
  final _userInfoFetcher = PublishSubject<BasicUser>();

  Observable<BasicUser> get userStream => _userInfoFetcher.stream;

  fetchUserInfo(BuildContext context) async {
    BasicUser userModel = await _repository.fetchUserInfo(context);
    _userInfoFetcher.sink.add(userModel);
  }

  dispose() {
    _userInfoFetcher.close();
  }
}

final UserBloc userBloc = UserBloc();
