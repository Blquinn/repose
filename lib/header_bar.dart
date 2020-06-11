import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repose/bloc/active_requests_bloc.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var requestListBloc = BlocProvider.of<ActiveRequestsListBloc>(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        color: Color.fromRGBO(30, 30, 30, 1),
        child: Row(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: FlatButton(
                    child: Text("New"),
                    color: Color.fromRGBO(242, 107, 48, 1),
                    onPressed: () {
                      debugPrint('New request button pressed.');
//                      requestListBloc.add(N)
                    },
                  ),
                ),
              ],
            ),
            Row(),
            Row(),
          ],
        ),
      ),
    );
  }
}
