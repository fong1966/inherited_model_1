part of 'color_box.dart';

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
