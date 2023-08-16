part of 'inherited_widget_model.dart';

enum AspectType {
  first,
  second,
  third,
}

class MyInheritedModel extends InheritedModel<AspectType> {
  final int firstValue, secondValue, thirdValue;

  const MyInheritedModel({
    super.key,
    required this.firstValue,
    required this.secondValue,
    required this.thirdValue,
    required Widget child,
  }) : super(child: child);

  static MyInheritedModel? of(BuildContext context, {AspectType? aspect}) {
    return InheritedModel.inheritFrom<MyInheritedModel>(context,
        aspect: aspect);
  }

  Widget getLabeledText(AspectType aspectType) {
    switch (aspectType) {
      case AspectType.first:
        return Text('First Number: $firstValue');
      case AspectType.second:
        return Text('Second Number: $secondValue');
      case AspectType.third:
        return Text('Third Number: $thirdValue');
      default:
        return Text('Unknown Number Type $aspectType');
    }
  }

  @override
  bool updateShouldNotify(covariant MyInheritedModel oldWidget) {
    return firstValue != oldWidget.firstValue ||
        secondValue != oldWidget.secondValue ||
        thirdValue != oldWidget.thirdValue;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant MyInheritedModel oldWidget, Set<AspectType> dependencies) {
    return (dependencies.contains(AspectType.first) &&
            oldWidget.firstValue != firstValue) ||
        (dependencies.contains(AspectType.second) &&
            oldWidget.secondValue != secondValue) ||
        (dependencies.contains(AspectType.third) &&
            oldWidget.thirdValue != thirdValue);
  }
}
