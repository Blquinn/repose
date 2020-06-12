import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repose/bloc/active_requests_bloc.dart';
import 'package:repose/request_container.dart';
import 'package:repose/request_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repose/split_view.dart';

import 'header_bar.dart';

void main() {
  runApp(Repose());
}

class Repose extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MainWidget();
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() {
    return _MainWidgetState();
  }
}

class _MainWidgetState extends State<MainWidget> {
  // TODO: persist scale factor
  double _scaleFactor = 2.0;

  // Captures all key presses in the app.
  void onKeyPressed(RawKeyEvent key) {
    if (!key.isControlPressed) { return; }
    if (!(key is RawKeyDownEvent)) { return; }

    if (key.logicalKey == LogicalKeyboardKey.equal){
      debugPrint('Scaling app up.');
      setState(() {
        _scaleFactor += 0.1;
      });
    }

    if (key.logicalKey == LogicalKeyboardKey.minus){
      debugPrint('Scaling app down.');
      setState(() {
        _scaleFactor -= 0.1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var focusNode = FocusNode(debugLabel: 'KeyboardListener');
    return RawKeyboardListener(
      focusNode: focusNode,
      onKey: onKeyPressed,
      child: FakeDevicePixelRatio(
        child: MaterialApp(
          title: 'Repose',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(title: 'Repose'),
        ),
        fakeDevicePixelRatio: _scaleFactor, 
      ),
    );
  }

}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => ActiveRequestsListBloc())
      ],
      child: Scaffold(
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
      ),
    );
  }
}


class FakeDevicePixelRatio extends StatelessWidget {
  final num fakeDevicePixelRatio;
  final Widget child;

  FakeDevicePixelRatio({this.fakeDevicePixelRatio, this.child}) : assert(fakeDevicePixelRatio != null);

  @override
  Widget build(BuildContext context) {
    final ratio = fakeDevicePixelRatio / WidgetsBinding.instance.window.devicePixelRatio;
    
    return FractionallySizedBox(
      widthFactor: 1/ratio,
      heightFactor: 1/ratio,
      child: Transform.scale(
        scale: ratio,
        child: child
      )
    );
  }
}
