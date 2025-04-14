import 'package:flutter/material.dart';
import 'package:untitled/Colors.dart';
import 'package:untitled/EditNote.dart';
import 'package:untitled/home.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/db.dart';
class noteView extends StatefulWidget {
  Note note;
  noteView({required this.note});

  @override
  State<noteView> createState() => _noteViewState();
}

class _noteViewState extends State<noteView> {
  //String note="This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note";
  late bool isArchived;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isArchived=widget.note.isArchived;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor.withOpacity(0.5),
        foregroundColor: white.withOpacity(0.7),
        elevation: 0.0,
        actions: [
          IconButton(onPressed: ()async{
            print(widget.note.pin);
            await NotesDB.instance.PinNote(widget.note);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
            );
          }, icon:widget.note.pin? Icon(Icons.push_pin):Icon(Icons.push_pin_outlined,)),
          IconButton(onPressed: ()async{
            await NotesDB.instance.ArchiveNote(widget.note);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
            );
          }, icon:isArchived? Icon(Icons.archive):Icon(Icons.archive_outlined)),
          IconButton(onPressed: ()async{
              await NotesDB.instance.delete(widget.note);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          },
              icon: Icon(Icons.delete_outline_outlined)),
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>editNote(note: widget.note,)));
          }, icon: Icon(Icons.edit_outlined))
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.note.title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23),),
            SizedBox(height: 15,),
            Text(widget.note.content,style: TextStyle(color: Colors.white,),)
          ],
        ),
      ),
    );
  }
}
