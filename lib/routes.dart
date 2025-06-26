import 'package:bus_theme/Adminshell.dart';
import 'package:bus_theme/Onboardingscreen.dart';
import 'package:bus_theme/drivershell.dart';
import 'package:bus_theme/parent_shell.dart';
import 'package:bus_theme/role_selection.dart';
import 'package:bus_theme/student_shell.dart';
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
    driver: (_) => const DriverShell(),
    admin: (_) => const AdminShell(),
  };
}
