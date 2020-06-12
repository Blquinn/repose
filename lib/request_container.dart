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
  ActiveRequestsListBloc _bloc = ActiveRequestsListBloc();

  final responseTextScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ActiveRequestsListBloc>(context);
    return BlocConsumer<ActiveRequestsListBloc, ActiveRequestsListState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActiveRequestsTabs(),
            ..._buildRequestEditor(bloc, state),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRequestEditor(ActiveRequestsListBloc bloc, ActiveRequestsListState state) {
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
  @override
  State<StatefulWidget> createState() {
    return _ActiveRequestsTabsState();
  }
}

class _ActiveRequestsTabsState extends State<ActiveRequestsTabs>
    with TickerProviderStateMixin {
  TabController _activeRequestsTabController;

  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ActiveRequestsListBloc>(context);
    var theme = Theme.of(context);
    return BlocConsumer<ActiveRequestsListBloc, ActiveRequestsListState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        return DynamicTabBar(
          itemCount: state.requests.length,
          tabBuilder: (context, idx) {
            var request = state.requests[idx];
            return Row(
              children: [
                Text(request.url,
                    style: theme.textTheme.subtitle2,
                    overflow: TextOverflow.clip),
                IconButton(
                  splashRadius: 16,
                  color: Colors.black54,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    debugPrint('Close tab button pressed.');
                  },
                ),
              ],
            );
          },
        );
      }
    );
  }
}
