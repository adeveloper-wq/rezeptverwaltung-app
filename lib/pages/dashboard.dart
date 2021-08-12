import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/auth_refresh_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  User user;
  @override
  void initState() {
    user = context.read<UserProvider>().user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DASHBOARD PAGE"),
        elevation: 0.1,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 100,),
          Center(child: Text(user != null ? user.email : '')),
        ],
      ),
    );
  }
}