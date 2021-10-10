import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/response_data.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/pages/new_receipt.dart';
import 'package:rezeptverwaltung/pages/receipt.dart';
import 'package:rezeptverwaltung/providers/auth_refresh_provider.dart';
import 'package:rezeptverwaltung/providers/group_provider.dart';
import 'package:rezeptverwaltung/providers/receipt_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  User user;
  List<dynamic> _userGroups;
  List<dynamic> _receipts;

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
        getReceipts();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['message'])));
      }
    });
  }

  void getReceipts(){
    final Future<ResponseData> result =
    context.read<ReceiptProvider>().getReceipts(_activeGroupId);

    result.then((response) {
      print(response);
      if (response.status) {
        setState(() {
          _receipts = response.data;
        });

      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
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
      getReceipts();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_userGroups != null)
            // Handle your callback
              Container(
                width: double.infinity,
                child: Column(
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

            if (_receipts != null)
            // Handle your callback
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var item in _receipts)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Receipt(item)));
                        },
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.fastfood),
                                title: Text(item['titel']),
                                subtitle: Text('Portionen: ' + item['portionen']),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            SizedBox(
              height: 20,
            ),
            Center(child: Text(user != null ? user.email : '')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewReceipt(_activeGroupId)));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
