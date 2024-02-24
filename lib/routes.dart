import 'package:flutter/material.dart';
import 'home/home.dart';
import 'dashboard/dashboard.dart';
import 'dashboard/uploadfile/uploadfile.dart';
import 'dashboard/document/document.dart';
import 'assistiti/assistiti.dart';
import 'assistiti/assistito/assistito.dart';
import "home/login/login.dart";
import "home/recent/recent.dart";
import "cases/cases.dart";
import "assistiti/nuovo.dart";

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const HomeScreen(),
  '/dashboard': (BuildContext context) => const DashboardScreen(),
  'dashboard/uploadfile': (BuildContext context) => const UploadFileScreen(),
  'dashboard/document': (BuildContext context) => const DocumentScreen(),
  '/assistiti': (BuildContext context) => const AssistitiScreen(),
  'assistiti/assistito': (BuildContext context) => const ClientScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/recent': (BuildContext context) => const RecentScreen(),
  '/cases': (BuildContext context) => const CasesScreen(),
  '/assistiti/nuovo': (BuildContext context) => const NuovoAssistitoScreen(),
};