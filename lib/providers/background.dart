import 'package:flutter/material.dart';

class BackgroundProvider extends ChangeNotifier {
  DateTime? lastBackgroundDate;

  void setBackgroundDate(DateTime date) {
    lastBackgroundDate = date;
    notifyListeners();
  }
}

class BackgroundInherited extends InheritedWidget {
  final BackgroundProvider provider;

  const BackgroundInherited({
    required super.child,
    required this.provider,
    super.key,
  });

  static BackgroundProvider of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<BackgroundInherited>()!
          .provider;

  @override
  bool updateShouldNotify(BackgroundInherited oldWidget) =>
      oldWidget.provider.lastBackgroundDate != provider.lastBackgroundDate;
}

extension BgExt on BuildContext {
  BackgroundProvider get background => BackgroundInherited.of(this);
}
