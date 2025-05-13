import 'package:flutter/material.dart';
import '../data/repositories/localization.dart';

class LocalizationProvider extends StatefulWidget {
  final Widget child;
  final String initialLanguageCode;

  const LocalizationProvider({
    required this.child,
    this.initialLanguageCode = 'en',
    super.key,
  });

  @override
  State<LocalizationProvider> createState() => LocalizationProviderState();
}

class LocalizationProviderState extends State<LocalizationProvider> {
  late LocalizationRepo localization;

  @override
  void initState() {
    super.initState();
    localization = LocalizationRepo()..setLanguage(widget.initialLanguageCode);
    localization.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return InheritedLocalization(
      localization: localization,
      child: widget.child,
    );
  }
}

class InheritedLocalization extends InheritedWidget {
  final LocalizationRepo localization;

  const InheritedLocalization({
    required super.child,
    required this.localization,
  });

  static LocalizationRepo of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<InheritedLocalization>()!
          .localization;

  @override
  bool updateShouldNotify(InheritedLocalization oldWidget) => true;
}

extension LocalizationExtension on BuildContext {
  String getText(String key) => InheritedLocalization.of(this).getText(key);
  LocalizationRepo get localization => InheritedLocalization.of(this);
}
