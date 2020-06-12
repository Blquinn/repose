import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:repose/bloc/models.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

@immutable
class ActiveRequestsListState extends Equatable {
  final List<RequestModel> requests;
  final RequestModel activeRequest;

  ActiveRequestsListState({
    @required this.requests,
    @required this.activeRequest,
  });

  ActiveRequestsListState copyWith({List<RequestModel> requests, RequestModel activeRequest}) {
    return ActiveRequestsListState(
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

class NameChangedEvent extends ActiveRequestListEvent {
  String newName;

  NameChangedEvent(this.newName);

  @override
  List<Object> get props => [newName];
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

class AddNewRequestEvent extends ActiveRequestListEvent {
  @override
  List<Object> get props => [];
}

class RequestSelectedEvent extends ActiveRequestListEvent {
  RequestModel newRequest;

  RequestSelectedEvent(this.newRequest);

  @override
  List<Object> get props => [newRequest];
}

class RemoveActiveRequestEvent extends ActiveRequestListEvent {
  RequestModel newRequest;

  RemoveActiveRequestEvent(this.newRequest);

  @override
  List<Object> get props => [newRequest];
}

class RequestNameSubmittedEvent extends ActiveRequestListEvent {
  RequestModel request;
  RequestNameSubmittedEvent(this.request);
  @override
  List<Object> get props => [request];
}

class ActiveRequestsListBloc extends Bloc<ActiveRequestListEvent, ActiveRequestsListState> {
  @override
  ActiveRequestsListState get initialState {
    var r1 = RequestModel(method: HttpMethod.GET, url: 'https://google.com', response: '');

    return ActiveRequestsListState(
      requests: [
        r1,
        RequestModel(
            method: HttpMethod.GET, url: 'https://yahoo.com', response: ''),
      ],
      activeRequest: r1,
    );
  }

  @override
  Stream<ActiveRequestsListState> mapEventToState(event) async* {
    if (event is UrlChangedEvent) {
      yield state.copyWith(activeRequest: state.activeRequest.copyWith(url: event.newUrl));
    } else if (event is MethodChangedEvent) {
      yield state.copyWith(activeRequest: state.activeRequest.copyWith(method: event.newMethod));
    } else if (event is NameChangedEvent) {
      yield state.copyWith(activeRequest: state.activeRequest.copyWith(name: event.newName));
    } else if (event is InitiateRequestEvent) {
      final res = await _doRequest();
      yield state.copyWith(activeRequest: state.activeRequest.copyWith(response: res));
    } else if (event is AddNewRequestEvent) {
      yield state.copyWith(requests: [...state.requests, RequestModel(url: 'http://foo.com')]);
    } else if (event is RequestSelectedEvent) {
      var currentReq = state.activeRequest;
      yield state.copyWith(
        requests: state.requests.map((r) => r.id == currentReq.id ? currentReq.copyWith() : r).toList(),
        activeRequest: event.newRequest,
      );
    } else if (event is RemoveActiveRequestEvent) {
      var requests = state.requests;
      requests.removeWhere((r) => r.id == event.newRequest.id);
      yield state.copyWith(
        requests: requests,
      );
    } else if (event is RequestNameSubmittedEvent) {
      yield state.copyWith(
        requests: state.requests.map((r) => r.id == event.request.id ? event.request.copyWith() : r).toList()
      );
    } else {
      debugPrint('Got unhandled event $event');
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
