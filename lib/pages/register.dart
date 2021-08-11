import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/auth_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/validators.dart';
import 'package:rezeptverwaltung/util/widgets.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password, _email;

  @override
  Widget build(BuildContext context) {

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Bitte Benutzernamen eingeben" : null,
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("Name", Icons.person),
    );

    final emailField = TextFormField(
      autofocus: false,
      //validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration("E-Mail", Icons.mail),
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

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Anmelden", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        context.read<AuthProvider>().register(_email, _username, _password).then((response) {
          if (response['status']) {
            User user = response['data'];
            context.read<UserProvider>().setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            SnackBar(content: Text('Registration Failed: ' + response.toString()));
          }
        });
      } else {
        SnackBar(content: Text('Invalid form, please complete the form properly.'));
      }

    };

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label("E-Mail"),
                  SizedBox(height: 5.0),
                  emailField,
                  SizedBox(height: 15.0),
                  label("Name"),
                  SizedBox(height: 10.0),
                  usernameField,
                  SizedBox(height: 15.0),
                  label("Passwort"),
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(height: 20.0),
                  context.watch<AuthProvider>().state == Status.Loading
                      ? loading
                      : longButtons("Registrieren", doRegister),
                  SizedBox(height: 5.0),
                  forgotLabel
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}