import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum HttpMethod {
  GET, POST, PUT, PATCH, DELETE, HEAD,
}

extension HttpMethodNames on HttpMethod {
  String get name => this.toString().split('.').last;
}

@immutable
class RequestModel extends Equatable {
  String id;
  final HttpMethod method;
  final String url;
  final String name;
  final String response;

  RequestModel({
    this.id,
    this.method = HttpMethod.GET,
    this.url = '',
    this.name = 'New Request',
    this.response = '',
  }) {
    id = id ?? uuid.v1();
  }

  RequestModel copyWith({String id, HttpMethod method, String name, String url, String response}) {
    return RequestModel(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      name: name ?? this.name,
      response: response ?? this.response,
    );
  }

  @override
  List<Object> get props => [id, method, url, name, response];
}
