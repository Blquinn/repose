import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repose/bloc/active_requests_bloc.dart';

import 'bloc/models.dart';

class RequestContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RequestContainerState();
  }
}

class RequestContainerState extends State<RequestContainer> {
  ActiveRequestsListBloc _bloc = ActiveRequestsListBloc();

  final responseTextScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ActiveRequestsListBloc>(context);

    return BlocProvider.value(
      value: bloc,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActiveRequestsTabs(numTabs: bloc.state.requests.length),
            ..._buildRequestEditor(bloc),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRequestEditor(ActiveRequestsListBloc bloc) {
    return bloc.state.activeRequest == null
        ? [Expanded(child: Text('No request selected'))]
        : [
            Row(
              children: [
                DropdownButton(
                  value: bloc.state.activeRequest.method,
                  items: HttpMethod.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toString().split('.').last),
                          ))
                      .toList(),
                  onChanged: (val) => _bloc.add(MethodChangedEvent(val)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      onChanged: (val) => _bloc.add(UrlChangedEvent(val)),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text('Send Request'),
                  onPressed: () => _bloc.add(InitiateRequestEvent()),
                ),
              ],
            ),
            Expanded(
              child: CupertinoScrollbar(
                controller: responseTextScrollController,
                child: SingleChildScrollView(
                  controller: responseTextScrollController,
                  child: Text(bloc.state.activeRequest.response == ''
                      ? 'No Response'
                      : bloc.state.activeRequest.response),
                ),
              ),
            ),
          ];
  }
}

class ActiveRequestsTabs extends StatefulWidget {
  int numTabs;

  ActiveRequestsTabs({
    @required this.numTabs,
  });

  @override
  State<StatefulWidget> createState() {
    return ActiveRequestsTabsState(numTabs: this.numTabs);
  }
}

class ActiveRequestsTabsState extends State<ActiveRequestsTabs>
    with TickerProviderStateMixin {
  int numTabs;
  TabController _activeRequestsTabController;

  ActiveRequestsTabsState({
    @required this.numTabs,
  });

  @override
  void initState() {
    super.initState();
    _activeRequestsTabController =
        TabController(length: this.numTabs, vsync: this);
  }

  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ActiveRequestsListBloc>(context);
    var theme = Theme.of(context);
    return BlocProvider.value(
      value: bloc,
      child: TabBar(
        isScrollable: true,
        controller: _activeRequestsTabController,
        tabs: bloc.state.requests.map((r) =>
            Row(
              children: [
                Text(r.url, style: theme.textTheme.subtitle2, overflow: TextOverflow.clip),
                IconButton(
                  icon: Icon(Icons.close),
                ),
              ],
            )
        ).toList(),
      ),
    );
  }
}
