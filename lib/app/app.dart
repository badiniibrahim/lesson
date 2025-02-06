import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lesson/app/routes/app_pages.dart';

import '../generated/locales.g.dart';

class App extends StatelessWidget {
  final String initialRoute;

  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Lesson",
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale("fr"),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      translationsKeys: AppTranslation.translations,
    );
  }
}
