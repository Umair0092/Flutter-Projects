import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:untitled/Colors.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/db.dart';

import 'NotesView.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {
  late List<Note> notes=[];
  bool isloading=false;

  Future<void> searchNotes(String query) async {
    try {
      notes.clear();
      final result = await NotesDB.instance.searchNotes(query);
      setState(() {
        notes = result;
      });
    } catch (e) {
      print("Error searching notes: $e");
      setState(() {
        notes = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget staggeredViewAll(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
            child:
            MasonryGridView.builder(
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // Number of columns
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notes.length,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> noteView(note: notes[index],) ));
                  },
                  child: Container(

                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: white.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(notes[index].title,style: TextStyle(color: white.withOpacity(0.7,),fontSize: 20,fontWeight: FontWeight.bold),),
                        Text(  notes[index].content.length>250 ? "${notes[index].content.substring(0,250)} ...":notes[index].content,style: TextStyle(color: white.withOpacity(0.7)),)

                      ],
                    ),
                  ),
                );
              },
            ),

          ),
        ],
      );

    }






    return Scaffold(
      backgroundColor: bgColor,

      body: SingleChildScrollView(
        child: SafeArea(child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: cardColor,
                  boxShadow: [BoxShadow(color: black.withOpacity(0.2),blurRadius: 3,spreadRadius: 1)]
        
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back_outlined)),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,

                              hintText: ("Search Your Note"),
                              hintStyle: TextStyle(
                                  fontSize: 17,color: white.withOpacity(0.5)
                              )
                          ),
                          onSubmitted: (value){
                             searchNotes(value);
                          },
                        ),
                      )
                    ],
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 15),child: Divider(color: white.withOpacity(0.3),)),
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Text("Your Search Results",style: TextStyle(color: white.withOpacity(0.7),fontWeight: FontWeight.bold,fontSize: 18),)),
                  staggeredViewAll()
                ],
              ),
            )
        
          ],
        )),
      ),
    );
  }
}
