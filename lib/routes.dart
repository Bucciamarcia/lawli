import 'package:flutter/material.dart';
import 'home/home.dart';
import 'dashboard/dashboard.dart';
import 'dashboard/uploadfile/uploadfile.dart';
import 'dashboard/document/document.dart';
import 'clients/clients.dart';
import 'clients/client/client.dart';
import "home/login/login.dart";
import "home/recent/recent.dart";
import "cases/cases.dart";

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => HomeScreen(),
  '/dashboard': (BuildContext context) => DashboardScreen(),
  'dashboard/uploadfile': (BuildContext context) => UploadFileScreen(),
  'dashboard/document': (BuildContext context) => DocumentScreen(),
  '/clients': (BuildContext context) => ClientsScreen(),
  'clients/client': (BuildContext context) => ClientScreen(),
  '/login': (BuildContext context) => LoginScreen(),
  '/recent': (BuildContext context) => RecentScreen(),
  '/cases': (BuildContext context) => CasesScreen(),
};