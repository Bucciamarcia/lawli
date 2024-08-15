import 'package:flutter/material.dart';
import 'package:lawli/trascrizione_audio/trascrizione_audio.dart';
import 'dashboard/document/view/view_document.dart';
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
import "ricerca_sentenze/ricerca_sentenze.dart";
import "template/template.dart";
import "account/account.dart";
import "home/guestlogin.dart";

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
  '/dashboard/document/update': (BuildContext context) => const ViewDocumentScreen(),
  '/ricerca_sentenze': (BuildContext context) => const RicercaSentenzeScreen(),
  '/trascrizione_audio': (BuildContext context) => const TrascrizioneAudioScreen(),
  '/template': (BuildContext context) => const TemplateScreen(),
  '/account': (BuildContext context) => const AccountScreen(),
  '/guestlogin': (BuildContext context) => const GuestLogin(),
};

