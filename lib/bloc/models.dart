import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum HttpMethod {
  GET, POST, PUT, PATCH, DELETE, HEAD,
}

@immutable
class RequestModel extends Equatable {
  final HttpMethod method;
  final String url;
  final String name;
  final String response;
//  final String responseContentType;

  RequestModel({
    this.method = HttpMethod.GET,
    this.url = '',
    this.name = 'New Request',
    this.response = '',
  });

  RequestModel copyWith({HttpMethod method, String name, String url, String response}) {
    return RequestModel(
      method: method ?? this.method,
      url: url ?? this.url,
      name: name ?? this.name,
      response: response ?? this.response,
    );
  }

  @override
  List<Object> get props => [method, url, name, response];
}
