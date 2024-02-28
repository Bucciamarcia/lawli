import 'package:flutter/material.dart';
import 'home/home.dart';
import 'dashboard/dashboard.dart';
import 'dashboard/uploadfile/uploadfile.dart';
import 'dashboard/document/document.dart';
import 'assistiti/assistiti.dart';
import "home/login/login.dart";
import "home/recent/recent.dart";
import 'pratiche/nuovo/nuovo.dart';
import "pratiche/pratiche.dart";
import "assistiti/nuovo/nuovo.dart";

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const HomeScreen(),
  '/dashboard': (BuildContext context) => const DashboardScreen(),
  '/dashboard/uploadfile': (BuildContext context) => const UploadFileScreen(),
  '/dashboard/document': (BuildContext context) => const DocumentScreen(),
  '/assistiti': (BuildContext context) => const AssistitiScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/recent': (BuildContext context) => const RecentScreen(),
  '/pratiche': (BuildContext context) => const PraticheScreen(),
  '/assistiti/nuovo': (BuildContext context) => const NuovoAssistitoScreen(),
  '/pratiche/nuovo': (BuildContext context) => const NuovaPraticaScreen(),
};
