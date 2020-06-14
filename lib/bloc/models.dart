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
class KeyValueModel extends Equatable {
  final String key;
  final String value;
  final String description;

  KeyValueModel(this.key, this.value, this.description);

  KeyValueModel copyWith({
    String key,
    String value,
    String description,
  }) => KeyValueModel(
    key ?? this.key,
    value ?? this.value,
    description ?? this.description,
  );

  @override
  List<Object> get props => [key, value, description];
}

@immutable
class RequestModel extends Equatable {
  String id;
  final HttpMethod method;
  final String url;
  final String name;
  final String response;
  List<KeyValueModel> params;
  List<KeyValueModel> headers;

  RequestModel({
    this.id,
    this.method = HttpMethod.GET,
    this.url = '',
    this.name = 'New Request',
    this.response = '',
    this.params,
    this.headers,
  }) {
    id = id ?? uuid.v1();
    params = params ?? [KeyValueModel('', '', '')];
    headers = headers ?? [KeyValueModel('', '', '')];
  }

  RequestModel copyWith({
    String id,
    HttpMethod method,
    String name,
    String url,
    String response,
    List<KeyValueModel> params,
    List<KeyValueModel> headers,
  }) => RequestModel(
    id: id ?? this.id,
    method: method ?? this.method,
    url: url ?? this.url,
    name: name ?? this.name,
    response: response ?? this.response,
    params: params ?? this.params,
    headers: headers ?? this.headers,
  );

  @override
  List<Object> get props => [id, method, url, name, response, params, headers];
}
