import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/models/paged_request_model.dart';
import 'managers/api_manager.dart';
import 'managers/department_manager.dart';
import 'managers/employee_manager.dart';
import 'managers/position_manager.dart';
import 'theme.dart';
import 'views/main_page/main_page.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

// ! Remove after the release
  HttpOverrides.global = MyHttpOverrides();

  // JEmployeeReader().read();
  ApiManager().getEmployees(PagedRequest(start: 0, length: 10)).whenComplete(() => ApiManager().syncOtherData());

  runApp(const MainApp());
}

// ! Remove after the release
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (kDebugMode) {
      return super.createHttpClient(context)
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    } else {
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
        ChangeNotifierProvider.value(value: DepartmentManager()),
        ChangeNotifierProvider.value(value: PositionManager()),
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
