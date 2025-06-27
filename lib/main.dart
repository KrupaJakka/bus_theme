import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bus_theme/apptheme.dart';
import 'package:bus_theme/routes.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const BusTrackingApp(),
    ),
  );
}

class BusTrackingApp extends StatelessWidget {
  const BusTrackingApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    useInheritedMediaQuery: true,
    locale: DevicePreview.locale(context),
    builder: DevicePreview.appBuilder,
    theme: AppTheme.dark,
    initialRoute: Routes.onboarding,
    routes: Routes.map,
  );
}
