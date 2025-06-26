import 'package:bus_theme/apptheme.dart';
import 'package:bus_theme/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(const BusTrackingApp());

class BusTrackingApp extends StatelessWidget {
  const BusTrackingApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    initialRoute: Routes.onboarding,
    routes: Routes.map,
  );
}
