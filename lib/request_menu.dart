import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RequestMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RequestMenuState();
  }
}

class RequestMenuState extends State<RequestMenu> {
  int _activeRequest = 0;
  List<String> _requests = ['https://google.com', 'https://foo.com'];

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView.builder(
        itemBuilder: (_, idx) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: ButtonTheme(
              height: 50,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    _activeRequest = idx;
                  });
                },
                color: idx == _activeRequest ? Colors.grey : Colors.transparent,
                child: Text(_requests[idx]),
              ),
            ),
          );
        },
        itemCount: _requests.length,
      ),
    );
  }
}
