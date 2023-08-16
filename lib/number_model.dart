part of 'color_box.dart';

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
  bool updateShouldNotify(covariant NumberModel oldWidget) {
    return firstValue != oldWidget.firstValue ||
        secondValue != oldWidget.secondValue ||
        thirdValue != oldWidget.thirdValue;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant NumberModel oldWidget, Set<NumberType> dependencies) {
    return (dependencies.contains(NumberType.first) &&
            oldWidget.firstValue != firstValue) ||
        (dependencies.contains(NumberType.second) &&
            oldWidget.secondValue != secondValue) ||
        (dependencies.contains(NumberType.third) &&
            oldWidget.thirdValue != thirdValue);
  }
}
