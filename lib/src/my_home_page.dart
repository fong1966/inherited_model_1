import '/src/inherited_w_m/inherited_widget_model.dart';

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
