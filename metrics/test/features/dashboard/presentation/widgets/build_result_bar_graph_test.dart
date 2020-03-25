import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/domain/entities/core/build_status.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_bar.dart';

void main() {
  const buildResults = BuildResultBarGraphTestbed.buildResultBarTestData;

  testWidgets('Displays title text', (WidgetTester tester) async {
    const title = 'Some title';

    await tester.pumpWidget(const BuildResultBarGraphTestbed(title: title));

    expect(find.text(title), findsOneWidget);
  });

  testWidgets(
    'Applies the text style to the title',
    (WidgetTester tester) async {
      const title = 'title';
      const titleStyle = TextStyle(color: Colors.red);

      await tester.pumpWidget(const BuildResultBarGraphTestbed(
        title: title,
        titleStyle: titleStyle,
      ));

      final titleWidget = tester.widget<Text>(find.text(title));

      expect(titleWidget.style, titleStyle);
    },
  );

  testWidgets(
    "Can't create widget without title",
    (WidgetTester tester) async {
      await tester.pumpWidget(const BuildResultBarGraphTestbed(title: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't create widget without data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const BuildResultBarGraphTestbed(data: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Creates the number of bars equal to the number of given BuildResultBarData",
    (WidgetTester tester) async {
      await tester.pumpWidget(const BuildResultBarGraphTestbed());

      final barWidgets = tester.widgetList(find.descendant(
        of: find.byType(LayoutBuilder),
        matching: find.byType(ColoredBar),
      ));

      expect(barWidgets.length, buildResults.length);
    },
  );

  testWidgets(
    "Creates bars with colors from MetricsTheme corresponding to build status",
    (WidgetTester tester) async {
      const primaryColor = Colors.green;
      const errorColor = Colors.red;

      const themeData = BuildResultsThemeData(
        successfulColor: primaryColor,
        failedColor: errorColor,
        canceledColor: errorColor,
      );
      await tester.pumpWidget(const BuildResultBarGraphTestbed(
        theme: MetricsThemeData(
          buildResultTheme: themeData,
        ),
      ));

      final barWidgets = tester
          .widgetList<ColoredBar>(find.descendant(
            of: find.byType(LayoutBuilder),
            matching: find.byType(ColoredBar),
          ))
          .toList();

      for (int i = 0; i < buildResults.length; i++) {
        final barWidget = barWidgets[i];
        final buildResult = buildResults[i];

        Color expectedBarColor;

        switch (buildResult.buildStatus) {
          case BuildStatus.successful:
            expectedBarColor = themeData.successfulColor;
            break;
          case BuildStatus.cancelled:
            expectedBarColor = themeData.canceledColor;
            break;
          case BuildStatus.failed:
            expectedBarColor = themeData.failedColor;
            break;
        }

        expect(barWidget.color, expectedBarColor);
      }
    },
  );

  testWidgets(
    "Creates placeholder bars if the number of build results is less than the max number of build results",
    (WidgetTester tester) async {
      final numberOfBars = buildResults.length + 1;

      await tester.pumpWidget(BuildResultBarGraphTestbed(
        numberOfBars: numberOfBars,
      ));

      final missingBuildResultsCount = numberOfBars - buildResults.length;

      final placeholderBuildBars = tester.widgetList(
        find.byType(PlaceholderBar),
      );

      expect(placeholderBuildBars.length, missingBuildResultsCount);
    },
  );

  testWidgets(
    "Trims the bars data from the begging to match the given number of bars",
    (WidgetTester tester) async {
      const numberOfBars = 2;

      await tester.pumpWidget(const BuildResultBarGraphTestbed(
        numberOfBars: numberOfBars,
      ));

      final trimmedData =
          buildResults.sublist(buildResults.length - numberOfBars);

      final barGraphWidget = tester.widget<BarGraph>(find.byWidgetPredicate(
        (widget) => widget is BarGraph,
      ));

      final barGraphData = barGraphWidget.data;

      expect(barGraphData.length, numberOfBars);

      expect(barGraphData, equals(trimmedData));
    },
  );

  testWidgets(
    "Shows the placeholder bar if the build result status is null",
    (WidgetTester tester) async {
      const testData = [
        BuildResultBarData(
          value: 20,
        )
      ];

      await tester.pumpWidget(BuildResultBarGraphTestbed(
        data: testData,
        numberOfBars: testData.length,
      ));

      expect(find.byType(PlaceholderBar), findsOneWidget);
    },
  );
}

class BuildResultBarGraphTestbed extends StatelessWidget {
  static const buildResultBarTestData = [
    BuildResultBarData(
      buildStatus: BuildStatus.successful,
      value: 5,
    ),
    BuildResultBarData(
      buildStatus: BuildStatus.failed,
      value: 2,
    ),
    BuildResultBarData(
      buildStatus: BuildStatus.cancelled,
      value: 8,
    ),
  ];

  final String title;
  final TextStyle titleStyle;
  final List<BuildResultBarData> data;
  final MetricsThemeData theme;
  final int numberOfBars;

  const BuildResultBarGraphTestbed({
    Key key,
    this.title = "Build result graph",
    this.data = buildResultBarTestData,
    this.titleStyle,
    this.theme = const MetricsThemeData(),
    this.numberOfBars = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MetricsTheme(
        data: theme,
        child: Scaffold(
          body: Center(
            child: BuildResultBarGraph(
              data: data,
              title: title,
              titleStyle: titleStyle,
              numberOfBars: numberOfBars,
            ),
          ),
        ),
      ),
    );
  }
}