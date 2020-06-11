import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:repose/bloc/models.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

@immutable
class ActiveRequestListState extends Equatable {
  final List<RequestModels> requests;
  final RequestModels activeRequest;

  ActiveRequestListState({
    @required this.requests,
    @required this.activeRequest,
  });

  ActiveRequestListState copyWith({List<RequestModels> requests, RequestModels activeRequest}) {
    return ActiveRequestListState(
      requests: requests ?? this.requests,
      activeRequest: activeRequest ?? this.activeRequest,
    );
  }

  // TODO: Will this ever get updated?
  @override
  List<Object> get props => [requests, activeRequest];
}

abstract class ActiveRequestListEvent {}

class UrlChangedEvent extends ActiveRequestListEvent {
  String newUrl;

  UrlChangedEvent(this.newUrl);

  @override
  List<Object> get props => [newUrl];
}

class MethodChangedEvent extends ActiveRequestListEvent {
  HttpMethod newMethod;

  MethodChangedEvent(this.newMethod);

  @override
  List<Object> get props => [newMethod];
}

class InitiateRequestEvent extends ActiveRequestListEvent {
  @override
  List<Object> get props => [];
}

class ActiveRequestsListBloc extends Bloc<ActiveRequestListEvent, ActiveRequestListState> {
  @override
  ActiveRequestListState get initialState => ActiveRequestListState(
      requests: [
        RequestModels(method: HttpMethod.GET, url: 'https://google.com', response: ''),
        RequestModels(method: HttpMethod.GET, url: 'https://yahoo.com', response: ''),
      ],
      activeRequest: null,
  );

  @override
  Stream<ActiveRequestListState> mapEventToState(event) async* {
    if (event is UrlChangedEvent) {
      yield state.copyWith(activeRequest: state.activeRequest.copyWith(url: event.newUrl));
    } else if (event is MethodChangedEvent) {
      yield state.copyWith(activeRequest: state.activeRequest.copyWith(method: event.newMethod));
    } else if (event is InitiateRequestEvent) {
      final res = await _doRequest();
      yield state.copyWith(activeRequest: state.activeRequest.copyWith(response: res));
    } else {
      debugPrint('Got unhandled event.');
    }
  }

  Future<String> _doRequest() async {
    debugPrint('Sending request.');
    try {
      http.Response res;
      switch (state.activeRequest.method) {
        case HttpMethod.GET:
          res = await http.get(state.activeRequest.url);
          break;
        case HttpMethod.POST:
          res = await http.post(state.activeRequest.url);
          break;
        case HttpMethod.PUT:
          res = await http.put(state.activeRequest.url);
          break;
        case HttpMethod.PATCH:
          res = await http.patch(state.activeRequest.url);
          break;
        case HttpMethod.DELETE:
          res = await http.delete(state.activeRequest.url);
          break;
        case HttpMethod.HEAD:
          res = await http.head(state.activeRequest.url);
          break;
      }

      String responseText;
      var contentType = res.headers['content-type'];
      if (contentType.isNotEmpty) {
        contentType = contentType.split(';')[0];
      }

      switch (contentType) {
        case "application/json":
          final json = jsonDecode(res.body);
          responseText = JsonEncoder.withIndent('  ').convert(json);
          break;
        case "application/xml":
        case "text/xml":
          final xmlDocument = xml.XmlDocument.parse(res.body);
          responseText = xmlDocument.toXmlString(pretty: true, indent: '  ');
          break;
        default:
          debugPrint('Got unhandled content-type $contentType');
          responseText = res.body;
          break;
      }

      debugPrint('Request completed.');
      return responseText;
    } on Exception catch (e) {
      debugPrint('Request failed $e.');
      return 'Request failed: $e';
    }
  }
}
