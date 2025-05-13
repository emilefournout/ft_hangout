import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier {
  Color _appBarColor = Colors.blue;

  Color get appBarColor => _appBarColor;

  void setAppBarColor(Color newColor) {
    _appBarColor = newColor;
    notifyListeners();
  }
}

class ColorInheritedWidget extends InheritedNotifier<ColorProvider> {
  const ColorInheritedWidget({
    super.key,
    required ColorProvider colorProvider,
    required Widget child,
  }) : super(notifier: colorProvider, child: child);

  static ColorProvider of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ColorInheritedWidget>()!
          .notifier!;
}

extension ColorExt on BuildContext {
  ColorProvider get color => ColorInheritedWidget.of(this);
}
