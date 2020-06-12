import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repose/bloc/active_requests_bloc.dart';
import 'package:repose/widgets/dynamic_tab_view.dart';

import 'bloc/models.dart';

class RequestContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RequestContainerState();
  }
}

class _RequestContainerState extends State<RequestContainer> {
  final _responseTextScrollController = ScrollController();
  final _urlTextController = TextEditingController();
  final _nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ActiveRequestsTabs(),
          _buildRequestEditor(context),
        ],
      ),
    );
  }

  Widget _buildRequestEditor(BuildContext context) {
    var bloc = context.bloc<ActiveRequestsListBloc>();
    return BlocConsumer<ActiveRequestsListBloc, ActiveRequestsListState>(
      bloc: bloc,
      // Only trigger listener when active request changes.
      listenWhen: (oldState, newState) => oldState.activeRequest.id != newState.activeRequest.id,
      listener: (context, state) {
        _urlTextController.text = state.activeRequest.url;
        _nameTextController.text = state.activeRequest.name;
      },
      builder: (context, state) => Expanded(
        child: state.activeRequest == null
            ? Text('No request selected')
            : Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Request Name'),
                    controller: _nameTextController,
                    onChanged: (val) => bloc.add(NameChangedEvent(val)),
                    onSubmitted: (val) => bloc.add(RequestNameSubmittedEvent(state.activeRequest)),
                  ),
                  Row(
                    children: [
                      DropdownButton(
                        value: state.activeRequest.method,
                        items: HttpMethod.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString().split('.').last),
                                ))
                            .toList(),
                        onChanged: (val) => bloc.add(MethodChangedEvent(val)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            decoration: InputDecoration(hintText: 'Url'),
                            controller: _urlTextController,
                            onChanged: (val) => bloc.add(UrlChangedEvent(val)),
                          ),
                        ),
                      ),
                      FlatButton(
                        child: Text('Send Request'),
                        onPressed: () => bloc.add(InitiateRequestEvent()),
                      ),
                    ],
                  ),
                  Expanded(
                    child: CupertinoScrollbar(
                      controller: _responseTextScrollController,
                      child: SingleChildScrollView(
                        controller: _responseTextScrollController,
                        child: Text(state.activeRequest.response == ''
                            ? 'No Response'
                            : state.activeRequest.response),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ActiveRequestsTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActiveRequestsTabsState();
  }
}

class _ActiveRequestsTabsState extends State<ActiveRequestsTabs> {
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ActiveRequestsListBloc>(context);
    var theme = Theme.of(context);
    return BlocBuilder<ActiveRequestsListBloc, ActiveRequestsListState>(
        bloc: bloc,
        builder: (context, state) {
          return DynamicTabBar(
            itemCount: state.requests.length,
            onPositionChange: (idx) {
              bloc.add(RequestSelectedEvent(state.requests[idx]));
            },
            tabBuilder: (context, idx) {
              var request = state.requests[idx];
              return SizedBox.fromSize(
                size: Size(150, 40),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          '${request.method.name} ${request.name.isEmpty ? request.url : request.name}',
                          style: theme.textTheme.subtitle2,
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                      splashRadius: 16,
                      color: Colors.black54,
                      icon: Icon(Icons.close),
                      onPressed: () {
                        debugPrint('Close tab button pressed.');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
