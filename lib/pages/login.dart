import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/auth_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/validators.dart';
import 'package:rezeptverwaltung/util/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      //validator: validateEmail,
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("E-Mail eingeben", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Bitte Passwort eingeben" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Passwort eingeben", Icons.lock),
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
          child: Text("Registrieren", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );

    var doLogin = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
        context.read<AuthProvider>().login(_username, _password);

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['data'];
            context.read<UserProvider>().setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            SnackBar(content: Text('Failed Login: ' + response['message']['message'].toString()));
          }
        });
      } else {
        print("form is invalid");
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
                  SizedBox(height: 20.0),
                  label("Passwort"),
                  SizedBox(height: 5.0),
                  passwordField,
                  SizedBox(height: 20.0),
                  context.watch<AuthProvider>().state == Status.Loading
                      ? loading
                      : longButtons("Login", doLogin),
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