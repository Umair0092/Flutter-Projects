import 'package:flutter/material.dart';
import 'package:untitled/Colors.dart';
import 'package:untitled/home.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/db.dart';

import 'NotesView.dart';
class editNote extends StatefulWidget {
  Note note;
  editNote({required this.note});

  @override
  State<editNote> createState() => _editNoteState();
}

class _editNoteState extends State<editNote> {
  late String Newtitle;
  late String NewContent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NewContent=widget.note.content;
    Newtitle=widget.note.title;
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
            Note Nnote=Note(id:widget.note.id,uniqueID: widget.note.uniqueID,title: Newtitle.toString(),content: NewContent.toString(),pin: widget.note.pin,createdTime: widget.note.createdTime);
            await NotesDB.instance.Update(Nnote);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>noteView(note:Nnote)));
          }, icon: Icon(Icons.save_outlined))
        ],

      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        child: Column(
          children: [
            Form(child: TextFormField(
              initialValue: Newtitle,
              cursorColor: white,
              onChanged: (value){
                Newtitle=value;
              },
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: white.withOpacity(0.7)),
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  //hintText: ("Title"),
                  hintStyle: TextStyle(
                      fontSize: 25,fontWeight: FontWeight.bold,color: white.withOpacity(0.7)
                  )
              ),

            ),),

            Container(
              height: 300,
              child: Form(
                child: TextFormField(
                  initialValue: NewContent,
                  onChanged: (value){
                    NewContent=value;
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 50,
                  maxLines: null,
                  cursorColor: white,
                  style: TextStyle(fontSize: 17,color: white.withOpacity(0.7)),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
