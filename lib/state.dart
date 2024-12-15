import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repose/models.dart';
import 'package:http/http.dart' as http;

class RequestStateCubit extends Cubit<RequestState> {
  RequestStateCubit() : super(Initial());

  Future<void> performRequest(String url) async {
    emit(Loading());

    try {
      var start = DateTime.now();

      var res = await http.get(Uri.parse(url));

      var elapsed = DateTime.now().difference(start);

      emit(Loaded(ResponseDetail(
        response: res,
        timing: elapsed,
      )));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
