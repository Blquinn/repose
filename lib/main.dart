import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repose/bloc/active_requests_bloc.dart';
import 'package:repose/request_container.dart';
import 'package:repose/request_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repose/widgets/split_view.dart';

import 'header_bar.dart';

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
      home: HomePage(title: 'Repose'),
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
