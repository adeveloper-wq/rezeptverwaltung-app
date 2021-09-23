
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:rezeptverwaltung/domains/ingredient.dart';
import 'package:rezeptverwaltung/domains/receipt.dart';
import 'package:rezeptverwaltung/domains/receipt_step.dart';
import 'package:rezeptverwaltung/providers/receipt_provider.dart';
import 'package:rezeptverwaltung/util/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewReceipt extends StatefulWidget {
  final int groupId;
  const NewReceipt(this.groupId);
  @override
  _NewReceiptState createState() => _NewReceiptState();
}

class _NewReceiptState extends State<NewReceipt> {
  final formKey = new GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  Receipt _newReceipt;

  List<dynamic> _allUnits;
  List<dynamic> _allTags;

  List<XFile> images;

  void getAllUnits() {
    final Future<Map<String, dynamic>> successfulMessage =
    context.read<ReceiptProvider>().getAllUnits();

    successfulMessage.then((response) {
      if (response['status']) {
        setState(() {
          _allUnits = response['data'];
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['message'])));
      }
    });
  }

  void getAllTags() {
    final Future<Map<String, dynamic>> successfulMessage =
    context.read<ReceiptProvider>().getAllTags();

    successfulMessage.then((response) {
      if (response['status']) {
        setState(() {
          _allTags = response['data'];
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
    getAllUnits();
    getAllTags();

    _newReceipt = new Receipt();
    _newReceipt.groupId = widget.groupId;
  }

  @override
  Widget build(BuildContext context) {

    final nameField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Name eingeben" : null,
      onSaved: (value) => _newReceipt.name = value,
      decoration: buildInputDecoration("Name eingeben", Icons.auto_stories),
    );

    final portionsField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Anzahl der Portionen eingeben" : null,
      onSaved: (value) => _newReceipt.portions = int.parse(value),
      decoration: buildInputDecoration("Portionen eingeben", Icons.group),
    );

    final workingTimeField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Arbeitszeit (min) eingeben" : null,
      onSaved: (value) => _newReceipt.workingTime = int.parse(value),
      decoration: buildInputDecoration("Arbeitszeit (min) eingeben", Icons.timer_rounded),
    );

    final cookingTimeField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Kochzeit (min) eingeben" : null,
      onSaved: (value) => _newReceipt.cookingTime = int.parse(value),
      decoration: buildInputDecoration("Kochzeit (min) eingeben", Icons.timer_rounded),
    );

    final restTimeField = TextFormField(
      autofocus: false,
      obscureText: false,
      validator: (value) => value.isEmpty ? "Bitte Ruhezeit (min) eingeben" : null,
      onSaved: (value) => _newReceipt.restTime = int.parse(value),
      decoration: buildInputDecoration("Ruhezeit (min) eingeben", Icons.timer_rounded),
    );

    final pickImage = () async {
      List<XFile> imgsTmp = await _picker.pickMultiImage();
      setState(() {
        images = imgsTmp;
      });
    };

    final addStep = (int index) {
      setState(() {
        _newReceipt.steps.add(new ReceiptStep(index, ''));
      });
    };

    final removeStep = (int index){
      _newReceipt.steps.removeWhere((element) => element.stepNumber == index);

      // adjust order again (so that step numbers go up incremental)
      List<ReceiptStep> _newSteps = [];
      int _previousStepNumber = -1;
      _newReceipt.steps.forEach((step) {
        int stepNumber = step.stepNumber;
        if((_previousStepNumber + 1) != stepNumber) {
          stepNumber = _previousStepNumber + 1;
        }
        _previousStepNumber++;
        _newSteps.add(new ReceiptStep(stepNumber, step.instruction));
      });

      setState(() {
        _newReceipt.steps = _newSteps;
      });
    };

    final addIngredient = () {
      setState(() {
        _newReceipt.ingredients.add(new Ingredient(null, null, null));
      });
    };

    final removeIngredient = (Ingredient ingredient){
      setState(() {
        _newReceipt.ingredients.remove(ingredient);
      });
    };

    final setIngredientName = (Ingredient ingredient, String name){
      int index = _newReceipt.ingredients.indexOf(ingredient);
      _newReceipt.ingredients[index].name = name;
    };

    final setIngredientUnitId = (Ingredient ingredient, int unitId){
      int index = _newReceipt.ingredients.indexOf(ingredient);
      setState(() {
        _newReceipt.ingredients[index].unitId = unitId;
      });
    };

    final setIngredientAmount = (Ingredient ingredient, int amount){
      int index = _newReceipt.ingredients.indexOf(ingredient);
      _newReceipt.ingredients[index].amount = amount;
    };

    final toggleTag = (int tagId) {
      if(_newReceipt.tagIds.contains(tagId)){
        setState(() {
          _newReceipt.tagIds.remove(tagId);
        });
      }else{
        setState(() {
          _newReceipt.tagIds.add(tagId);
        });
      }
    };

    final upload = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        print(_newReceipt.toString());

        final Future<Map<String, dynamic>> successfulMessage =
        context.read<ReceiptProvider>().createReceipt(_newReceipt);

        successfulMessage.then((response) {
          if (response['status']) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response['message'])));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response['message'])));
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte alles richtig ausfüllen.')));
      }
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
                if(images != null)
                  Container(
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Image.file(File(images[0].path)),
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
                    if(_allTags != null)
                      for (var item in _allTags)
                        new Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                              child: Text(item['name']),
                              style: ElevatedButton
                                  .styleFrom(
                                primary: _newReceipt.tagIds.contains(item['T_ID'])
                                    ? Colors.greenAccent
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                toggleTag(item['T_ID']);
                              },
                            )
                        )
                  ]
                ),
                label("Schritte"),
                for(ReceiptStep step in _newReceipt.steps)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.redAccent,
                            onPressed: () {
                              removeStep(step.stepNumber);
                            },
                          ),
                          label(step.stepNumber.toString()),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        autofocus: false,
                        key: new Key(step.hashCode.toString()),
                        obscureText: false,
                        initialValue: step.instruction,
                        validator: (value) => value.isEmpty ? "Bitte Beschreibung eingeben" : null,
                        onSaved: (value) => {

                        },
                        onChanged: (value) => {
                          _newReceipt.steps.firstWhere((element) => element.stepNumber == step.stepNumber).instruction = value,
                        },
                        decoration: buildInputDecoration("Beschreibung", Icons.timer_rounded),
                      ),
                    ]
                  ),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.greenAccent,
                  onPressed: () {
                    addStep(_newReceipt.steps.length);
                  },
                ),
                label("Zutaten"),
                for(var ingredient in _newReceipt.ingredients)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.redAccent,
                              onPressed: () {
                                removeIngredient(ingredient);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                autofocus: false,
                                obscureText: false,
                                validator: (value) => value.isEmpty ? "Menge eingeben" : null,
                                onSaved: (value) => {
                                  setIngredientAmount(ingredient, int.parse(value)),
                                },
                                decoration: InputDecoration(labelText: 'Menge'),
                              ),
                            ),
                            DropdownButton<int>(
                              items: _allUnits.map((value) {
                                return DropdownMenuItem<int>(
                                  value: value['E_ID'],
                                  child: Text(value['einheit']),
                                );
                              }).toList(),
                              value: ingredient.unitId,
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(new FocusNode());
                                setIngredientUnitId(ingredient, value);
                              },
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                autofocus: false,
                                obscureText: false,
                                validator: (value) => value.isEmpty ? "Name eingeben" : null,
                                onSaved: (value) => {
                                  setIngredientName(ingredient, value),
                                },
                                decoration: InputDecoration(labelText: 'Name'),
                              ),
                            ),
                          ],
                        )
                      ]
                  ),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.greenAccent,
                  onPressed: () {
                    addIngredient();
                  },
                ),
                longButtons("Speichern", upload),
              ],
            ),
          ),
        ),
      ),
    );
  }
}