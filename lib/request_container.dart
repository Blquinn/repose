import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repose/bloc/active_requests_bloc.dart';
import 'package:repose/bloc/request_bloc.dart' as rb;
import 'package:repose/widgets/dynamic_tab_view.dart';
import 'package:repose/widgets/key_value_table.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'bloc/models.dart';

class RequestContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<ActiveRequestsListBloc, ActiveRequestsListState>(
        builder: (context, state) => DynamicTabView(
          itemCount: state.requests.length,
          tabBuilder: (context, idx) => buildTabBar(context, state, idx),
          pageBuilder: (context, idx) => RequestWidget(
            request: state.requests[idx],
            child: RequestEditorContainer(),
          ),
        ),
      ),
    );
  }

  Widget buildTabBar(BuildContext context, ActiveRequestsListState state, int idx) {
    final theme = Theme.of(context);
    final request = state.requests[idx];
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
  }
}

class ActiveRequestsTabs extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ActiveRequestsListBloc>(context);
    final theme = Theme.of(context);
    return BlocBuilder<ActiveRequestsListBloc, ActiveRequestsListState>(
        bloc: bloc,
        builder: (context, state) {
          return DynamicTabBar(
            itemCount: state.requests.length,
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

class RequestEditorContainer extends StatelessWidget {
  final _nameTextController = TextEditingController();
  final _urlTextController = TextEditingController();
  final _requestEditingController = TextEditingController();
  final _requestEditingScrollController = ScrollController();
  final _responseTextScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final request = RequestWidget.of(context);

    final bloc = rb.RequestBloc(request.request);
    final activeRequestsBloc = context.bloc<ActiveRequestsListBloc>();

    _nameTextController.text = request.request.name;
    _urlTextController.text = request.request.url;

    return BlocBuilder<rb.RequestBloc, RequestModel>(
      bloc: bloc,
      builder: (context, state) => ListView(
        controller: _requestEditingScrollController,
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Request Name'),
            controller: _nameTextController,
            onChanged: (val) => bloc.add(rb.NameChangedEvent(val)),
            onSubmitted: (val) =>
                activeRequestsBloc.add(RequestNameSubmittedEvent(state.copyWith(name: val))),
          ),
          StickyHeader(
            header: buildRequestInfoBar(state, bloc, theme),
            content: SizedBox(
              height: 1000,
              child: Column(
                children: [
                  buildRequestEditor(state, theme),
                  buildResponseText(state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRequestInfoBar(RequestModel state, rb.RequestBloc bloc, ThemeData theme) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Row(
        children: [
          DropdownButton(
            value: state.method,
            items: HttpMethod.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toString().split('.').last),
                    ))
                .toList(),
            onChanged: (val) => bloc.add(rb.MethodChangedEvent(val)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Url'),
                controller: _urlTextController,
                onChanged: (val) => bloc.add(rb.UrlChangedEvent(val)),
              ),
            ),
          ),
          FlatButton(
            child: Text('Send Request'),
            onPressed: () => bloc.add(rb.InitiateRequestEvent()),
          ),
        ],
      ),
    );
  }

  Widget buildRequestEditor(RequestModel state, ThemeData theme) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 30,
            child: TabBar(
              tabs: [
                SizedBox(
                  height: 30,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Params', style: theme.textTheme.bodyText1)),
                ),
                SizedBox(
                  height: 30,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Headers', style: theme.textTheme.bodyText1)),
                ),
                SizedBox(
                  height: 30,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Body', style: theme.textTheme.bodyText1)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                KeyValueTable(params: state.params),
                KeyValueTable(params: state.headers),
                CupertinoTextField(
                  controller: _requestEditingController,
                  scrollController: _requestEditingScrollController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResponseText(RequestModel state) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 5),
        child: CupertinoScrollbar(
          controller: _responseTextScrollController,
          child: Text(state.response == '' ? 'No Response' : state.response),
        ),
      ),
    );
  }
}

class RequestWidget extends InheritedWidget {
  final RequestModel request;

  const RequestWidget({
    Key key,
    @required this.request,
    @required Widget child,
  })  : assert(request != null),
        super(key: key, child: child);

  static RequestWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RequestWidget>();
  }

  @override
  bool updateShouldNotify(RequestWidget old) => request.name != old.request.name;
}
