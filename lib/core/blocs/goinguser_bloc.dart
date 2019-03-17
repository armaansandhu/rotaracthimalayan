import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class GoingListBloc {
  final _repository = Repository();
  final _documentFetcher = PublishSubject();

  get goingUserList => _documentFetcher.stream;

  fetchGoingUser(DocumentReference reference) async {
    List<String> documents = await _repository.fetchGoingList(reference);
    _documentFetcher.sink.add(documents);
  }

  dispose() async {
    await _documentFetcher.drain();
    _documentFetcher.close();
  }
}

final goingUserListBloc = GoingListBloc();
