import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'component_fields.dart';

class ComponentPage extends StatefulWidget {
  @override
  _ComponentPageState createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  TextEditingController _componentNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  String messageText;




  @override


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Invento'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, 'login');
              }),
        ],
      ),
      body: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: getComponent.length,
            itemBuilder: (BuildContext context, int index) {
              return makeCard(
                getComponent[index],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          elevation: 20,
          onPressed: () {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _componentNameController.clear();
                          _quantityController.clear();
                        },
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(
                            () {
                              getComponent.add(
                                Component(
                                  componentName: _componentNameController.text,
                                  quantity: int.parse(_quantityController.text),
                                ),
                              );
                            },
                          );
                          _firestore.collection('components').add({
                            'Component Name':_componentNameController.text,
                            'Quanitity':int.parse(_quantityController.text)
                          });
                          _componentNameController.clear();
                          _quantityController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'ADD',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                    title: Column(
                      children: <Widget>[
                        Center(
                          child: Text('Add a new component'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          textInputAction: TextInputAction.next,
                          controller: _componentNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Component Name',
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: _quantityController,
                          decoration: InputDecoration(
                            hintText: 'Enter present quanitity',
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}