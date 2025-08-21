import 'package:bus_theme/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bus_theme/dashboards/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DevicePreview(builder: (context) => BusTrackingApp()));
}

class BusTrackingApp extends StatelessWidget {
  const BusTrackingApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    useInheritedMediaQuery: true,
    locale: DevicePreview.locale(context),
    builder: DevicePreview.appBuilder,
    initialRoute: Routes.onboarding,
    routes: Routes.map,
  );
}
