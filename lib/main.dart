import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(
      const NumberManagerWidget(
        updateMs: 1000,
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inherited Model Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class NumberManagerWidget extends StatefulWidget {
  final int updateMs;
  final Widget child;

  const NumberManagerWidget(
      {super.key, required this.child, required this.updateMs})
      : assert(updateMs > 0);

  @override
  State<StatefulWidget> createState() => NumberManagerWidgetState();
}

class NumberManagerWidgetState extends State<NumberManagerWidget> {
  Timer? updateTimer;
  late int firstTick, secondTick, thirdTick;

  @override
  void initState() {
    super.initState();
    firstTick = secondTick = thirdTick = 0;
    resetTimer();
  }

  @override
  void didUpdateWidget(NumberManagerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetTimer();
  }

  void resetTimer() {
    updateTimer?.cancel();
    updateTimer = Timer.periodic(
      Duration(milliseconds: widget.updateMs),
      (Timer t) {
        setState(() {
          firstTick++;
          if (firstTick % 2 == 0) {
            secondTick++;
            if (secondTick % 2 == 0) {
              thirdTick++;
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    updateTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NumberModel(
      firstValue: firstTick,
      secondValue: secondTick,
      thirdValue: thirdTick,
      child: widget.child,
    );
  }
}

enum NumberType {
  first,
  second,
  third,
}

class NumberModel extends InheritedModel<NumberType> {
  final int firstValue, secondValue, thirdValue;

  const NumberModel({
    super.key,
    required this.firstValue,
    required this.secondValue,
    required this.thirdValue,
    required Widget child,
  }) : super(child: child);

  static NumberModel? of(BuildContext context, {NumberType? aspect}) {
    return InheritedModel.inheritFrom<NumberModel>(context, aspect: aspect);
  }

  Widget getLabeledText(NumberType type) {
    switch (type) {
      case NumberType.first:
        return Text('First Number: $firstValue');
      case NumberType.second:
        return Text('Second Number: $secondValue');
      case NumberType.third:
        return Text('Third Number: $thirdValue');
      default:
        return Text('Unknown Number Type $type');
    }
  }

  @override
  bool updateShouldNotify(NumberModel oldWidget) {
    return firstValue != oldWidget.firstValue ||
        secondValue != oldWidget.secondValue ||
        thirdValue != oldWidget.thirdValue;
  }

  @override
  bool updateShouldNotifyDependent(
      NumberModel oldWidget, Set<NumberType> dependencies) {
    return (dependencies.contains(NumberType.first) &&
            oldWidget.firstValue != firstValue) ||
        (dependencies.contains(NumberType.second) &&
            oldWidget.secondValue != secondValue) ||
        (dependencies.contains(NumberType.third) &&
            oldWidget.thirdValue != thirdValue);
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inherited Model vs Inherited Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Inherited Model Views'),
                InheritedModelView(type: NumberType.first),
                InheritedModelView(type: NumberType.second),
                InheritedModelView(type: NumberType.third),
                const SizedBox(height: 25.0),
                const Text('Inherited Widget Views'),
                InheritedWidgetView(type: NumberType.first),
                InheritedWidgetView(type: NumberType.second),
                InheritedWidgetView(type: NumberType.third),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColorRegistry {
  final List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  int _idx = 0;

  Color nextColor() {
    if (_idx >= colors.length) {
      _idx = 0;
    }
    return colors[_idx++];
  }
}

class _ColoredBox extends StatelessWidget {
  final Color color;
  final Widget child;

  const _ColoredBox({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}

class InheritedModelView extends StatelessWidget {
  final ColorRegistry r = ColorRegistry();

  final NumberType type;

  InheritedModelView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final NumberModel? model = NumberModel.of(context, aspect: type);

    return _ColoredBox(
      color: r.nextColor(),
      child: model!.getLabeledText(type),
    );
  }
}

class InheritedWidgetView extends StatelessWidget {
  final ColorRegistry r = ColorRegistry();

  final NumberType type;

  InheritedWidgetView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final NumberModel? view = NumberModel.of(context);

    return _ColoredBox(
      color: r.nextColor(),
      child: view!.getLabeledText(type),
    );
  }
}
