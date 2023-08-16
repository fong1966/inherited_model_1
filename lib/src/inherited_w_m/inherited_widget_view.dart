part of 'inherited_widget_model.dart';

class InheritedWidgetView extends StatelessWidget {
  final ColorRegistry colorRegistry = ColorRegistry();

  final AspectType aspectType;

  InheritedWidgetView({super.key, required this.aspectType});

  @override
  Widget build(BuildContext context) {
    final MyInheritedModel? view = MyInheritedModel.of(context);

    return _ColoredBox(
      color: colorRegistry.nextColor(),
      child: view!.getLabeledText(aspectType),
    );
  }
}
