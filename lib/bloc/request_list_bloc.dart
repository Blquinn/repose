import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:repose/bloc/models.dart';

@immutable
class CollectionTreeState extends Equatable {
  final List<RequestModels> requests;

  CollectionTreeState({
    @required this.requests,
  });

  // TODO: Will this ever get updated?
  @override
  List<Object> get props => [requests];
}

abstract class RequestListEvent {}

class RequestListBloc extends Bloc<RequestListEvent, CollectionTreeState> {
  @override
  CollectionTreeState get initialState => CollectionTreeState(requests: []);

  @override
  Stream<CollectionTreeState> mapEventToState(event) async* {
  }
}
