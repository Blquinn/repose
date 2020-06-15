import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:repose/bloc/models.dart';

@immutable
class ActiveRequestsListState extends Equatable {
  final List<RequestModel> requests;

  ActiveRequestsListState({
    @required this.requests,
  });

  ActiveRequestsListState copyWith({List<RequestModel> requests}) {
    return ActiveRequestsListState(
      requests: requests ?? this.requests,
    );
  }

  @override
  List<Object> get props => [requests];
}

abstract class ActiveRequestListEvent {}

class AddNewRequestEvent extends ActiveRequestListEvent {}

class RemoveActiveRequestEvent extends ActiveRequestListEvent {
  RequestModel newRequest;

  RemoveActiveRequestEvent(this.newRequest);
}

class RequestNameSubmittedEvent extends ActiveRequestListEvent {
  RequestModel request;

  RequestNameSubmittedEvent(this.request);
}

class ActiveRequestsListBloc extends Bloc<ActiveRequestListEvent, ActiveRequestsListState> {
  @override
  ActiveRequestsListState get initialState {
    return ActiveRequestsListState(
      requests: [
        RequestModel(
          method: HttpMethod.POST,
          url: 'https://google.com',
          response: '',
        ),
        RequestModel(method: HttpMethod.GET, url: 'https://yahoo.com', response: ''),
      ],
    );
  }

  @override
  Stream<ActiveRequestsListState> mapEventToState(event) async* {
    if (event is AddNewRequestEvent) {
      yield state.copyWith(requests: [...state.requests, RequestModel(url: 'http://foo.com')]);
    } else if (event is RemoveActiveRequestEvent) {
      var requests = state.requests;
      requests.removeWhere((r) => r.id == event.newRequest.id);
      yield state.copyWith(
        requests: requests,
      );
    } else if (event is RequestNameSubmittedEvent) {
      yield state.copyWith(
          requests: state.requests
              .map((r) => r.id == event.request.id ? event.request.copyWith() : r)
              .toList());
    } else {
      debugPrint('Got unhandled event $event');
    }
  }
}
