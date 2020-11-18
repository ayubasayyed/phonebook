import "package:firebase_database/firebase_database.dart";

class Contact{
  String _id;
  String _firstName;
  String _lastName;
  String _address;
  String _photoUrl;
  String _phone;
  String _email;

  set id(String value) {
    _id = value;
  }

  String get id => _id;

  Contact(this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);

  Contact.withId(this._id, this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get phone => _phone;

  String get email => _email;

  String get address => _address;

  String get photoUrl => _photoUrl;



  set firstName(String value) {
    _firstName = value;
  }

  set photoUrl(String value) {
    _photoUrl = value;
  }

  set address(String value) {
    _address = value;
  }

  set email(String value) {
    _email = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  Contact.fromSnapshot(DataSnapshot snapshot){
  this._id = snapshot.key;
  this._firstName = snapshot.value['firstName'];
  this._lastName = snapshot.value['lastName'];
  this._phone  = snapshot.value['phone'];
  this._email = snapshot.value['email'];
  this._address = snapshot.value['address'];
  this._photoUrl = snapshot.value['photoUrl'];

  }

  Map<String, dynamic> toJson(){
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl,
    };
  }
}
