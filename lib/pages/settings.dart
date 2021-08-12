import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
        title: Text("Einstellungen"),
        elevation: 0.1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/group_settings');
            }, // Handle your callback
            child: Container(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Gruppenverwaltung"),
                    Text("Gruppen beitreten oder verlassen")
                  ],
              ),
            )
          ),
          SizedBox(height: 100,),
          Center(child: Text(user != null ? user.email : '')),
          SizedBox(height: 100),
          RaisedButton(
            onPressed: (){
              UserPreferences().removeUser();
              context.read<UserProvider>().setUser(null);
              Navigator.pop(context);
            },
            child: Text("Logout"),
            color: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }
}