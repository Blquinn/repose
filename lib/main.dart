import 'dart:convert';

import 'package:xml/xml.dart' as xml;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repose/split_view.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repose',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Repose'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        HeaderBar(),
        Expanded(
          child: VerticalSplitView(
            ratio: 0.2,
            left: RequestMenu(),
            right: RequestContainer(),
          ),
        )
      ]),
    );
  }
}

class RequestMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RequestMenuState();
  }
}

class RequestMenuState extends State<RequestMenu> {
  List<String> _requests = ['https://google.com', 'https://foo.com'];

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView.builder(
        itemBuilder: (_, idx) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_requests[idx]),
          );
        },
        itemCount: _requests.length,
      ),
    );
  }
}

class RequestContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RequestContainerState();
  }
}

class RequestContainerState extends State<RequestContainer> {
  String _response = '';

  final responseTextScrollController = ScrollController();
  final TextEditingController _requestUrlController = TextEditingController();

  final List<String> _methods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];
  String _activeMethod = 'GET';

  @override
  void initState() {
    super.initState();
    _requestUrlController.text = 'https://jsonplaceholder.typicode.com/todos';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              DropdownButton(
                value: _activeMethod,
                items: _methods.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  setState(() {
                    _activeMethod = val;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextField(
                    controller: _requestUrlController,
                  ),
                ),
              ),
              FlatButton(
                child: Text('Send Request'),
                onPressed: _onSendRequest,
              ),
            ],
          ),
        ),
        Expanded(
          child: CupertinoScrollbar(
            controller: responseTextScrollController,
            child: SingleChildScrollView(
              controller: responseTextScrollController,
              child: Text(_response == '' ? 'No Response' : _response),
            ),
          ),
        ),
      ],
    );
  }

  void _onSendRequest() async {
    debugPrint('Sending request.');
    try {
      final res = await http.get(_requestUrlController.text);

      String responseText;
      var contentType = res.headers['content-type'];
      if (contentType.isNotEmpty) {
        contentType = contentType.split(';')[0];
      }

      switch (contentType) {
        case "application/json":
          final json = jsonDecode(res.body);
          responseText = JsonEncoder.withIndent('  ').convert(json);
          break;
        case "application/xml":
        case "text/xml":
          final xmlDocument = xml.XmlDocument.parse(res.body);
          responseText = xmlDocument.toXmlString(pretty: true, indent: '  ');
          break;
        default:
          debugPrint('Got unhandled content-type $contentType');
          responseText = res.body;
          break;
      }

      debugPrint('Request completed.');
      setState(() {
        _response = responseText;
      });
    } on Exception catch (e) {
      debugPrint('Request failed $e.');
    }
  }
}

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
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
