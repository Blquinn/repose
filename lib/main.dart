import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';
import 'package:repose/models.dart';
import 'package:repose/state.dart';
import 'package:repose/theme.dart';
import 'package:repose/util/humanize.dart';
import 'package:stockholm/stockholm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: NThemeData.light(
        accentColor:
            themeColorToStockholmColor(ThemeColor.blue, Brightness.light),
      ),
      darkTheme: NThemeData.dark(
        accentColor:
            themeColorToStockholmColor(ThemeColor.blue, Brightness.dark),
      ),
      builder: (context, child) {
        var query = MediaQuery.of(context);

        final scaler =
            query.textScaler.clamp(minScaleFactor: 1.1, maxScaleFactor: 2.0);

        return MediaQuery(
          data: query.copyWith(textScaler: scaler),
          child: child!,
        );
      },
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Toolbar(),
      ),
      body: RequestResponseContainer(),
    );
  }
}

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StockholmToolbar(
      children: [
        StockholmToolbarButton(
          icon: Icons.close,
          onPressed: () {},
        ),
        const StockholmToolbarDivider(),
        StockholmToolbarButton(
          icon: Icons.open_in_browser,
          onPressed: () {},
        ),
        const Spacer(),
        StockholmToolbarButton(
          icon: Icons.close,
          onPressed: () {},
        ),
      ],
    );
  }
}

class RequestResponseContainer extends HookWidget {
  const RequestResponseContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final urlController = useTextEditingController(
        text: "https://jsonplaceholder.typicode.com/comments");

    return BlocProvider(
      create: (context) => RequestStateCubit(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: StockholmTextField(
                    controller: urlController,
                    placeholder: "URL",
                  ),
                ),
                const SizedBox(width: 8),
                Builder(builder: (context) {
                  final requestStateCubit = context.read<RequestStateCubit>();
                  return StockholmButton(
                    large: true,
                    onPressed: () async {
                      await requestStateCubit
                          .performRequest(urlController.text);
                    },
                    child: const Row(
                      children: [
                        Text("Send"),
                        SizedBox(width: 4),
                        Icon(Icons.send, size: 16.0),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: ResponseView()),
          ],
        ),
      ),
    );
  }
}

class ResponseView extends HookWidget {
  ResponseView({
    super.key,
  });

  final CodeLineEditingController responseEditingController =
      CodeLineEditingController();

  @override
  Widget build(BuildContext context) {
    final requestStateCubit = context.read<RequestStateCubit>();
    final requestState = useBlocBuilder(requestStateCubit);

    final theme = Theme.of(context);

    switch (requestState) {
      case Initial():
        responseEditingController.text = "";
        return const Text("No response.");
      case Loading():
        responseEditingController.text = "";
        return const StockholmActivityIndicator();
      case Error(message: var errorMessage):
        var errorTextStyle = theme.textTheme.bodyMedium!
            .copyWith(color: theme.colorScheme.error);
        return Text("Error: $errorMessage", style: errorTextStyle);
      case Loaded(response: var res):
        responseEditingController.text = res.response.body;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Status: ${res.response.statusCode} ${res.response.reasonPhrase ?? ""}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "Time: ${humanizeDuration(res.timing)}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "Size: ${humanizeBytes(res.response.contentLength ?? 0)}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: CodeEditor(
                style: CodeEditorStyle(
                  fontFamily: "NotoSansMono",
                  fontSize: theme.textTheme.bodyMedium!.fontSize!,
                  codeTheme: CodeHighlightTheme(
                    languages: {
                      'json': CodeHighlightThemeMode(mode: langJson),
                      // 'xml': CodeHighlightThemeMode(mode: langXml),
                    },
                    theme: atomOneDarkTheme,
                  ),
                ),
                controller: responseEditingController,
                // wordWrap: false,
                wordWrap: true,
                readOnly: true,
                indicatorBuilder: (
                  context,
                  editingController,
                  chunkController,
                  notifier,
                ) {
                  return Row(
                    children: [
                      DefaultCodeLineNumber(
                        controller: editingController,
                        notifier: notifier,
                      ),
                      DefaultCodeChunkIndicator(
                        width: 20,
                        controller: chunkController,
                        notifier: notifier,
                      )
                    ],
                  );
                },
                // findBuilder: (context, controller, readOnly) => CodeFindPanelView(controller: controller, readOnly: readOnly),
                // toolbarController: const ContextMenuControllerImpl(),
                sperator: Container(width: 1, color: Colors.blue),
              ),
            ),
          ],
        );
    }
  }
}

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Center(
        child: Text("Request Editor"),
      ),
    );
  }
}
