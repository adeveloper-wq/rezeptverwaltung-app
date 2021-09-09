import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/group_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';
import 'package:rezeptverwaltung/util/widgets.dart';

class GroupSettings extends StatefulWidget {
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  final _formKeySearch = new GlobalKey<FormState>();
  final _formKeyJoin = new GlobalKey<FormState>();

  String _groupName;
  String _password;

  Map<String,dynamic> _foundGroup;
  List<dynamic> _userGroups;

  void getGroups() {
    final Future<Map<String, dynamic>> successfulMessage =
    context.read<GroupProvider>().getGroups();

    successfulMessage.then((response) {
      if (response['status']) {
        _userGroups = response['data'];
        print("üüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüü");
        print(_userGroups);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.getGroups();
  }

  @override
  Widget build(BuildContext context) {
    final groupNameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Bitte Gruppennamen eingeben" : null,
      onSaved: (value) => _groupName = value,
      decoration: buildInputDecoration("Gruppenname", Icons.group),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Bitte Passwort eingeben" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Passwort", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Lädt ... Bitte warten")
      ],
    );

    var joinGroup = () {
      final form = _formKeyJoin.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
        context.read<GroupProvider>().joinGroup(_password, _foundGroup['G_ID']);

        successfulMessage.then((response) {
          if (response['status']) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte alles richtig ausfüllen.')));
      }
    };

    var startSearch = () {
      final form = _formKeySearch.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
        context.read<GroupProvider>().getGroup(_groupName);

        successfulMessage.then((response) {
          if (response['status']) {
            _foundGroup = response['data'];
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte alles richtig ausfüllen.')));
      }
    };

    Future<void> _displayTextInputDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Gruppe: " + _foundGroup['name']),
              content:  Form(
                  key: _formKeyJoin,
                  child: Column(
                    children: [
                      Text("Hinweis: " + _foundGroup['hinweis']),
                      passwordField,
                      SizedBox(height: 20,),
                      context.watch<GroupProvider>().stateJoining == GroupJoiningLoadingStatus.Loading
                          ? loading
                          : longButtons("Beitreten", joinGroup),
                    ],
                  )
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('Abbrechen'),
                  onPressed: () {
                    setState(() {

                      Navigator.pop(context);
                    });
                  },
                ),

              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Gruppenverwaltung"),
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
          if(_userGroups != null)
             // Handle your callback
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(var item in _userGroups )
                        InkWell(onTap: () {},child: Text(item['name'])),
                    ],
                  ),
            ),
          Form(
            key: _formKeySearch,
            child: Column(
              children: [
                groupNameField,
                SizedBox(height: 20,),
                context.watch<GroupProvider>().state == GroupLoadingStatus.Loading
                    ? loading
                    : longButtons("Suche", startSearch),
              ],
            ),
          ),
          if(_foundGroup != null)
            InkWell(
                onTap: () {
                  _displayTextInputDialog(context);
                }, // Handle your callback
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_foundGroup['name']),
                    ],
                  ),
                )
            )
        ]
      )
    );
  }
}