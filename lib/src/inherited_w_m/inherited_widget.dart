part of 'inherited_widget_model.dart';

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
