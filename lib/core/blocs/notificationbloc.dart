import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class NotificationBloc {
  final _repository = Repository();
  final _documentFetcher = PublishSubject();

  get notificationDocumentStream => _documentFetcher.stream;

  fetchNotificationDocuments(String user, String event) async {
    var documents = await _repository.fetchNotificationDocuments(user, event);
    _documentFetcher.sink.add(documents);
  }

  dispose() async{
    await _documentFetcher.drain();
    _documentFetcher.close();
  }

}

final notificationBloc = NotificationBloc();