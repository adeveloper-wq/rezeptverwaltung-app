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
  final formKey = new GlobalKey<FormState>();

  String _groupName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groupNameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Bitte Gruppennamen eingeben" : null,
      onSaved: (value) => _groupName = value,
      decoration: buildInputDecoration("Gruppenname", Icons.group),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Lädt ... Bitte warten")
      ],
    );

    var startSearch = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
        context.read<GroupProvider>().getGroup(_groupName);

        successfulMessage.then((response) {
          if (response['status']) {
            print("------------------------------------------------------------------------");
            print(response['data']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte alles richtig ausfüllen.')));
      }
    };

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
      body: Form(
        key: formKey,
        child: Column(
          children: [
            groupNameField,
            SizedBox(height: 100,),
            context.watch<GroupProvider>().state == GroupLoadingStatus.Loading
                ? loading
                : longButtons("Suche", startSearch),
          ],
        ),
      )
    );
  }
}