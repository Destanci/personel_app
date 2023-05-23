import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personel_app/managers/employee_manager.dart';
import 'package:personel_app/theme.dart';
import 'package:personel_app/views/main_page.dart';
import 'package:provider/provider.dart';

import 'managers/json_employee_reader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

// ! Remove after the release
  HttpOverrides.global = MyHttpOverrides();

  JEmployeeReader().read();

  runApp(const MainApp());
}

// ! Remove after the release
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (kDebugMode) {
      developer.log('--- APPLICATION START DEBUG MODE ---');
      return super.createHttpClient(context)
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    } else {
      developer.log('--- APPLICATION START NON-DEBUG MODE ---');
      return super.createHttpClient(context);
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: EmployeeManager()),
      ],
      child: MaterialApp(
        title: 'Personel App Demo',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const MainPage(),
        },
      ),
    );
  }
}
