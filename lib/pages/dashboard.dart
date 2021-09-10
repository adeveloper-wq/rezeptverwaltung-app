import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/auth_refresh_provider.dart';
import 'package:rezeptverwaltung/providers/group_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  User user;
  List<dynamic> _userGroups;

  int _activeGroupId;

  void getGroups() {
    final Future<Map<String, dynamic>> successfulMessage =
        context.read<GroupProvider>().getGroups();

    successfulMessage.then((response) {
      if (response['status']) {
        setState(() {
          _userGroups = response['data'];
        });
        setState(() {
          _activeGroupId = _userGroups[0]['G_ID'];
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['message'])));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    user = context.read<UserProvider>().user;
    this.getGroups();
  }

  @override
  Widget build(BuildContext context) {
    var setActiveGroup = (int id) {
      setState(() {
        _activeGroupId = id;
      });
    };

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
          if (_userGroups != null)
            // Handle your callback
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in _userGroups)
                    InkWell(
                        onTap: () {
                          setActiveGroup(item['G_ID']);
                        },
                        child: Text(
                          item['name'],
                          style: TextStyle(
                              backgroundColor: _activeGroupId == item['G_ID']
                                  ? Colors.grey
                                  : Colors.transparent),
                        )),
                ],
              ),
            ),
          SizedBox(
            height: 20,
          ),
          Center(child: Text(user != null ? user.email : '')),
        ],
      ),
    );
  }
}
