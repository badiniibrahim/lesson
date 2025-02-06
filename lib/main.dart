import 'package:flutter/material.dart';
import 'package:lesson/app/app.dart';
import 'package:lesson/app/routes/app_pages.dart';
import 'package:lesson/initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Initializer.init();

  final String initialRoute = await Routes.INITIAL;

  runApp(App(
    initialRoute: initialRoute,
  ));
}
