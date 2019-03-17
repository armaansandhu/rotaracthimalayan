import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class MeetingBloc {
  final _repository = Repository();
  final _documentFetcher = PublishSubject();

  get notificationDocumentStream => _documentFetcher.stream;

  fetchNotificationDocuments(String reference) async {
    var documents = await _repository.fetchMeetingData(reference);
    _documentFetcher.sink.add(documents);
  }

  dispose() async {
    await _documentFetcher.drain();
    _documentFetcher.close();
  }
}

final meetingBloc = MeetingBloc();
