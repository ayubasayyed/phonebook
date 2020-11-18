import 'package:flutter/material.dart';
import 'ViewContact.dart';
import 'AddContact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  navigateToAddScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddContact()
    ));
  }

  navigateToViewScreen(id){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ViewContact(id);
    }));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact\'s'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (context, DataSnapshot dataSnapshot, Animation<double> animation, int index){
            return GestureDetector(
              onTap: (){navigateToViewScreen(dataSnapshot.key);},
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                            dataSnapshot.value['photoUrl'] == "empty" ?
                            AssetImage("images/logo.png") :
                            NetworkImage(dataSnapshot.value['photoUrl']),
                            ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${dataSnapshot.value['firstName']} ${dataSnapshot.value['lastName']}'),
                            Text('${dataSnapshot.value['phone']}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToAddScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
