import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multi_split_view/multi_split_view.dart';
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
      debugShowCheckedModeBanner: false,
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
    return BlocProvider(
      create: (context) => RequestStateCubit(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const UrlBar(),
            const SizedBox(height: 8),
            Expanded(child: RequestLayoutSwitcher()),
          ],
        ),
      ),
    );
  }
}

class RequestLayoutSwitcher extends HookWidget {
  RequestLayoutSwitcher({super.key});

  final MultiSplitViewController _controller = MultiSplitViewController();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _controller.areas = [
        Area(
          min: 0.2,
          builder: (context, area) => const RequestEditor(),
        ),
        Area(
          min: 0.2,
          builder: (context, area) => const ResponseView(),
        ),
      ];

      return _controller.dispose;
    }, [_controller]);

    useListenable(_controller);

    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerHandleBuffer: 4.0,
        dividerThickness: 1.0,
        dividerPainter: DividerPainters.grooved1(
          size: 25.0,
          highlightedSize: 25.0,
          thickness: 2,
          highlightedThickness: 4,
          animationDuration: const Duration(milliseconds: 100),
          color: Theme.of(context).dividerColor,
          highlightedColor: Theme.of(context).dividerColor,
          backgroundColor: Theme.of(context).dividerColor.withAlpha(20),
          highlightedBackgroundColor:
              Theme.of(context).dividerColor.withAlpha(20),
        ),
      ),
      child: MultiSplitView(
        controller: _controller,
        axis: Axis.horizontal,
        // resizable: true,
        // pushDividers: false,
        builder: (context, area) => area.builder!.call(context, area),
      ),
    );
  }
}

class UrlBar extends HookWidget {
  const UrlBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final urlController = useTextEditingController(
        text: "https://jsonplaceholder.typicode.com/posts");

    return Row(
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
              await requestStateCubit.performRequest(urlController.text);
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
    );
  }
}

class ResponseView extends HookWidget {
  const ResponseView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final requestState = useBlocBuilder(context.read<RequestStateCubit>());

    final theme = Theme.of(context);

    switch (requestState) {
      case Initial():
        return const Center(child: Text("No response."));
      case Loading():
        return const StockholmActivityIndicator();
      case Error(message: var errorMessage):
        var errorTextStyle = theme.textTheme.bodyMedium!
            .copyWith(color: theme.colorScheme.error);
        return Text("Error: $errorMessage", style: errorTextStyle);
      case Loaded(response: var res):
        return RealizedResponseView(res: res);
    }
  }
}

class RealizedResponseView extends HookWidget {
  RealizedResponseView({
    super.key,
    required this.res,
  });

  final CodeLineEditingController responseEditingController =
      CodeLineEditingController();

  final ResponseDetail res;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      responseEditingController.text = res.response.body;
      return responseEditingController.dispose;
    });

    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Status: ${res.response.statusCode} ${res.response.reasonPhrase ?? ""}",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Time: ${humanizeDuration(res.timing)}",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Size: ${humanizeBytes(res.response.contentLength ?? 0)}",
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: CodeEditor(
            style: CodeEditorStyle(
              fontFamily: "NotoSansMono",
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize!,
              codeTheme: CodeHighlightTheme(
                languages: {
                  'json': CodeHighlightThemeMode(mode: langJson),
                  // 'xml': CodeHighlightThemeMode(mode: langXml),
                },
                theme: atomOneDarkTheme,
              ),
            ),
            controller: responseEditingController,
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
            sperator: Container(
              width: theme.dividerTheme.thickness ?? 1.0,
              color: theme.dividerColor,
            ),
          ),
        ),
      ],
    );
  }
}

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Request Editor"),
    );
  }
}
