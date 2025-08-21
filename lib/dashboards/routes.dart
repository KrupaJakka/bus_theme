import 'package:bus_theme/dashboards/admin/Adminshell.dart';
import 'package:bus_theme/screens/Onboardingscreen.dart';
import 'package:bus_theme/dashboards/driver/drivershell.dart';
import 'package:bus_theme/dashboards/parent/parent_shell.dart';
import 'package:bus_theme/screens/role_selection.dart';
import 'package:bus_theme/dashboards/student/student_shell.dart';
import 'package:flutter/material.dart';

class Routes {
  static const onboarding = '/';
  static const roles = '/roles';
  static const student = '/student';
  static const parent = '/parent';
  static const driver = '/driver';
  static const admin = '/admin';

  static final map = <String, WidgetBuilder>{
    onboarding: (_) => const OnboardingScreen(),
    roles: (_) => const RoleSelectionScreen(),
    student: (_) => const StudentShell(),
    parent: (_) => const ParentShell(),
    driver: (_) => const DriverProfileScreen(),
    admin: (_) => const AdminShell(),
  };
}
