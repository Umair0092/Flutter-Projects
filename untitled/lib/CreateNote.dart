import 'package:flutter/material.dart';
import 'package:untitled/Colors.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/db.dart';
import 'package:uuid/uuid.dart';
import 'home.dart';
class createNote extends StatefulWidget {
  const createNote({super.key});

  @override
  State<createNote> createState() => _createNoteState();
}

class _createNoteState extends State<createNote> {

  TextEditingController title=TextEditingController();
  TextEditingController content=TextEditingController();
  var uuid = Uuid();
  // Generate a v1 (time-based) id
 // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: white.withOpacity(0.7),
        actions: [
          IconButton(onPressed: ()async{
            Note note=Note(title: title.text,uniqueID: uuid.v1() , content: content.text, pin: false, createdTime: DateTime.now());
            await NotesDB.instance.create(note);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
            );
          },
              icon: Icon(Icons.save_outlined))
        ],

      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        child: Column(
          children: [
            TextField(
              cursorColor: white,
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: white.withOpacity(0.7)),
              controller: title,
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  hintText: ("Title"),
                  hintStyle: TextStyle(
                      fontSize: 25,fontWeight: FontWeight.bold,color: white.withOpacity(0.7)
                  )
              ),

            ),
            Container(
              height: 300,
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 50,
                maxLines: null,
                cursorColor: white,
                style: TextStyle(fontSize: 17,color: white.withOpacity(0.7)),
                controller: content,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    hintText: ("Note"),
                    hintStyle: TextStyle(
                        fontSize: 17,fontWeight: FontWeight.bold,color: white.withOpacity(0.7)
                    )
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}
