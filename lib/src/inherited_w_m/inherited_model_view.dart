part of 'inherited_widget_model.dart';

class InheritedModelView extends StatelessWidget {
  final ColorRegistry r = ColorRegistry();

  final AspectType aspectType;

  InheritedModelView({super.key, required this.aspectType});

  @override
  Widget build(BuildContext context) {
    final MyInheritedModel? model =
        MyInheritedModel.of(context, aspect: aspectType);

    return _ColoredBox(
      color: r.nextColor(),
      child: model!.getLabeledText(aspectType),
    );
  }
}
