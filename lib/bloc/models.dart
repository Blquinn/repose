import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum HttpMethod {
  GET, POST, PUT, PATCH, DELETE, HEAD,
}

@immutable
class RequestModels extends Equatable {
  final HttpMethod method;
  final String url;
  final String response;

  RequestModels({
    @required this.method,
    @required this.url,
    @required this.response,
  });

  RequestModels copyWith({HttpMethod method, String url, String response}) {
    return RequestModels(
      method: method ?? this.method,
      url: url ?? this.url,
      response: response ?? this.response,
    );
  }

  @override
  List<Object> get props => [method, url, response];
}
