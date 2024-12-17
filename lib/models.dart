import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;

part 'models.freezed.dart';

sealed class RequestState {}

class Initial extends RequestState {}

class Loading extends RequestState {}

class Error extends RequestState {
  final String message;

  Error(this.message);
}

class Loaded extends RequestState {
  final ResponseDetail response;

  Loaded(this.response);
}

@freezed
class ResponseDetail with _$ResponseDetail {
  const factory ResponseDetail({
    required http.Response response,
    required Duration timing,
  }) = _ResponseDetail;
}

@freezed
class AppLayout with _$AppLayout {
  const factory AppLayout({
    required Axis requestResponseViewAxis,
  }) = _AppLayout;
}
