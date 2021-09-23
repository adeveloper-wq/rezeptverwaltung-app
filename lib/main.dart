import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/pages/dashboard.dart';
import 'package:rezeptverwaltung/pages/group_settings.dart';
import 'package:rezeptverwaltung/pages/login.dart';
import 'package:rezeptverwaltung/pages/new_receipt.dart';
import 'package:rezeptverwaltung/pages/receipt.dart';
import 'package:rezeptverwaltung/pages/register.dart';
import 'package:rezeptverwaltung/pages/settings.dart';
import 'package:rezeptverwaltung/providers/auth_provider.dart';
import 'package:rezeptverwaltung/providers/auth_refresh_provider.dart';
import 'package:rezeptverwaltung/providers/group_provider.dart';
import 'package:rezeptverwaltung/providers/receipt_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthRefreshProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => GroupProvider()),
          ChangeNotifierProvider(create: (_) => ReceiptProvider()),
        ],
        child: MyAppStateful()
    );
  }
}

class MyAppStateful extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppStateful>{
  @override
  void initState() {
    context.read<AuthRefreshProvider>().refresh(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: context.watch<AuthRefreshProvider>().state == StatusRefresh.Loading ?
                    CircularProgressIndicator() :
                      context.watch<AuthRefreshProvider>().state == StatusRefresh.LoggedIn ?
                        DashBoard() :
                          Login(),
          routes: {
            '/dashboard': (context) => DashBoard(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
            '/settings': (context) => Settings(),
            '/group_settings': (context) => GroupSettings(),
          }
    );
  }
}