import 'package:flutter/material.dart';
import 'package:ft_hangout/data/repositories/sms.dart';
import 'package:ft_hangout/providers/background.dart';
import 'package:ft_hangout/providers/color.dart';
import 'package:ft_hangout/providers/localizations.dart';
import 'package:ft_hangout/widgets/homepage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final dbPath = await getDatabasesPath();
  // await deleteDatabase(join(dbPath, 'contacts.db'));

  runApp(
    LocalizationProvider(
      initialLanguageCode: 'en',
      child: ColorInheritedWidget(
        colorProvider: ColorProvider(),
        child: BackgroundInherited(
          provider: BackgroundProvider(),
          child: const MaterialApp(home: Homepage()),
        ),
      ),
    ),
  );
}
