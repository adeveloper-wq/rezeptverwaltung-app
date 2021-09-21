
import 'package:flutter/material.dart';
import 'package:rezeptverwaltung/util/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewReceipt extends StatefulWidget {
  @override
  _NewReceiptState createState() => _NewReceiptState();
}

class _NewReceiptState extends State<NewReceipt> {
  final formKey = new GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _name;
  int _portions, _cookingTime, _workingTime, _restTime;

  XFile image;

  List<String> tags = ['vegan', 'vegetarisch', 'herzhaft', 'süß', 'suppe', 'party', 'getränk', 'backen', 'kochen', 'basic'];

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final nameField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Name eingeben" : null,
      onSaved: (value) => _name = value,
      decoration: buildInputDecoration("Name eingeben", Icons.auto_stories),
    );

    final portionsField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Anzahl der Portionen eingeben" : null,
      onSaved: (value) => _portions = int.parse(value),
      decoration: buildInputDecoration("Portionen eingeben", Icons.group),
    );

    final workingTimeField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Arbeitszeit (min) eingeben" : null,
      onSaved: (value) => _workingTime = int.parse(value),
      decoration: buildInputDecoration("Arbeitszeit (min) eingeben", Icons.timer_rounded),
    );

    final cookingTimeField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Kochzeit (min) eingeben" : null,
      onSaved: (value) => _cookingTime = int.parse(value),
      decoration: buildInputDecoration("Kochzeit (min) eingeben", Icons.timer_rounded),
    );

    final restTimeField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Ruhezeit (min) eingeben" : null,
      onSaved: (value) => _restTime = int.parse(value),
      decoration: buildInputDecoration("Ruhezeit (min) eingeben", Icons.timer_rounded),
    );

    final pickImage = () async {
      print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      print("bley");
      XFile imgTmp = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        image = imgTmp;
      });
      print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      print(image.path);
    };

    return Scaffold(
      appBar: AppBar(
          title: Text("Rezept erstellen"),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  child: Text("Bild auswählen"),
                  style: ElevatedButton
                      .styleFrom(
                    primary: Colors.greenAccent,
                  ),
                  onPressed: () {
                    pickImage();
                  },
                ),
                if(image != null)
                  Container(
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Image.file(File(image.path)),
                    )
                  ),
                label("Name"),
                SizedBox(height: 5.0),
                nameField,
                SizedBox(height: 20.0),
                label("Portionen"),
                SizedBox(height: 5.0),
                portionsField,
                SizedBox(height: 20.0),
                label("Arbeitszeit"),
                SizedBox(height: 5.0),
                workingTimeField,
                SizedBox(height: 20.0),
                label("Kochzeit"),
                SizedBox(height: 5.0),
                cookingTimeField,
                SizedBox(height: 20.0),
                label("Ruhezeit"),
                SizedBox(height: 5.0),
                restTimeField,
                SizedBox(height: 20.0),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    for (var item in tags)
                      new Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: ElevatedButton(
                            child: Text(item),
                            style: ElevatedButton
                                .styleFrom(
                              primary: item.isNotEmpty
                                  ? Colors.grey
                                  : Colors.greenAccent,
                            ),
                            onPressed: () {

                            },
                          )
                      )
                  ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}