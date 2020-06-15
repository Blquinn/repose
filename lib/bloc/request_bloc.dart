import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:repose/bloc/models.dart';
import 'package:xml/xml.dart' as xml;

abstract class RequestEditorEvent {}

class UrlChangedEvent extends RequestEditorEvent {
  String newUrl;

  UrlChangedEvent(this.newUrl);
}

class NameChangedEvent extends RequestEditorEvent {
  String newName;

  NameChangedEvent(this.newName);
}

class MethodChangedEvent extends RequestEditorEvent {
  HttpMethod newMethod;

  MethodChangedEvent(this.newMethod);
}

class InitiateRequestEvent extends RequestEditorEvent {}

class RequestBloc extends Bloc<RequestEditorEvent, RequestModel> {
  RequestModel request;

  RequestBloc(this.request);

  @override
  RequestModel get initialState => request;

  @override
  Stream<RequestModel> mapEventToState(event) async* {
    if (event is UrlChangedEvent) {
      yield state.copyWith(url: event.newUrl);
    } else if (event is MethodChangedEvent) {
      yield state.copyWith(method: event.newMethod);
    } else if (event is NameChangedEvent) {
      yield state.copyWith(name: event.newName);
    } else if (event is InitiateRequestEvent) {
      final res = await _doRequest();
      yield state.copyWith(response: res);
    } else {
      debugPrint('Received unexpected event $event');
    }
  }

  Future<String> _doRequest() async {
    debugPrint('Sending request.');
    try {
      http.Response res;
      switch (state.method) {
        case HttpMethod.GET:
          res = await http.get(state.url);
          break;
        case HttpMethod.POST:
          res = await http.post(state.url);
          break;
        case HttpMethod.PUT:
          res = await http.put(state.url);
          break;
        case HttpMethod.PATCH:
          res = await http.patch(state.url);
          break;
        case HttpMethod.DELETE:
          res = await http.delete(state.url);
          break;
        case HttpMethod.HEAD:
          res = await http.head(state.url);
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
