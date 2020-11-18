import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook/models/Contact.dart';
import 'package:path/path.dart';

class EditContact extends StatefulWidget {
  final String id;

  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  final String id;

  _EditContactState(this.id);

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _photoUrl;

  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _pnController = TextEditingController();
  TextEditingController _emController = TextEditingController();
  TextEditingController _adController = TextEditingController();

  bool isLoading = true;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();


  getContact(String id) async{
    Contact _contact;
    _databaseReference.child(id).onValue.listen((event) {
        _contact = Contact.fromSnapshot(event.snapshot);
        _fnController.text = _contact.firstName;
        _lnController.text = _contact.lastName;
        _pnController.text = _contact.phone;
        _emController.text = _contact.email;
        _adController.text = _contact.address;
        isLoading = false;

        setState(() {
          _firstName = _contact.firstName;
          _lastName  = _contact.lastName;
          _email = _contact.lastName;
          _phone = _contact.phone;
          _address = _contact.address;
          isLoading = false;
          _photoUrl = _contact.photoUrl;
        });
    });
  }

  //pick Image

  pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    File image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
      print(image);
    }else{
      print('no image selected');
      return;
    }
    String fileName = basename(pickedFile.path);
    print (fileName);
    uploadImage(image, fileName);
  }

  uploadImage(File file , String fileName) async {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(file);
    String downloadUrl;
   await uploadTask.whenComplete(() async {
       downloadUrl = await reference.getDownloadURL();
    });

   setState(() {
     _photoUrl = downloadUrl;
   });
  }

  updateContact(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty &&
        _phone.isNotEmpty) {
      Contact contact = Contact.withId(this.id, this._firstName, this._lastName, this._phone,
          this._email, this._address, this._photoUrl);

      await _databaseReference.child(id).update(contact.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Field Required'),
              content: Text('All Fields are required'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close')),
              ],
            );
          });
    }
  }

  navigateToLastScreen(context) {
    Navigator.pop(context);
  }
  @override
  void initState() {
    super.initState();
    this.getContact(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              //image view
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      this.pickImage();
                    },
                    child: Center(
                      child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: _photoUrl == "empty"
                                    ? AssetImage("images/logo.png")
                                    : NetworkImage(_photoUrl),
                              ))),
                    ),
                  )),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  },
                  controller: _fnController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  },
                  controller: _lnController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  controller: _pnController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  controller: _emController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  controller: _adController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              // update button
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                  onPressed: () {
                    updateContact(context);
                  },
                  color: Colors.red,
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
