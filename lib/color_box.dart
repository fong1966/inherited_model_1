library colorbox;

import 'package:flutter/material.dart';
export 'package:flutter/material.dart';

part 'inherited_model.dart';
part 'inherited_widget.dart';
part 'number_model.dart';

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
