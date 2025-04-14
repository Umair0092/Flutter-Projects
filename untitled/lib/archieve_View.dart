import 'package:flutter/material.dart';
import 'package:untitled/CreateNote.dart';
import 'package:untitled/NotesView.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/sidebar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Colors.dart';

class archieveView extends StatefulWidget {
  const archieveView({super.key});
  @override
  State<archieveView> createState() => _archieveViewState();
}

class _archieveViewState extends State<archieveView> {
  GlobalKey<ScaffoldState> _drawerkey=GlobalKey();
  late List<Note> notes=[];
  bool isLoading=true;
  Future ReadAlld() async{
    this.notes=await NotesDB.instance.readArchived();
    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   ReadAlld();
  }
  String note="This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note";
  String note1="This is Note This is Note This is Note This is Note";
  Widget staggeredViewAll(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
          child: Column(
            children: [
              Text("Archived Notes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: white.withOpacity(0.9)),)
            ],
          ),
        ),
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
  Widget ColoredList(){return  Container(
    margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
    child:
    MasonryGridView.builder(
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // Number of columns
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 15,
      mainAxisSpacing: 12,
      crossAxisSpacing: 8,
      itemBuilder: (context,index){
        return InkWell(
          onTap: (){},
          child: Container(

            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: index.isEven? Colors.green[900]:Colors.blue[900],
                border: Border.all(color: Colors.green.shade900),
                borderRadius: BorderRadius.circular(15)
            ),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Heading",style: TextStyle(color: white.withOpacity(0.7,),fontSize: 20,fontWeight: FontWeight.bold),),
                Text( index.isEven ? note.length>250 ? "${note.substring(0,250)} ...":note:note1,style: TextStyle(color: white.withOpacity(0.7)),)
              ],
            ),
          ),
        );
      },
    ),

  );}
  Widget ListViewAll(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
          child: Column(
            children: [
              Text("List View",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: white.withOpacity(0.9)),)
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
          child:
          ListView.builder(

            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 15,

            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(15)
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Heading",style: TextStyle(color: white.withOpacity(0.7,),fontSize: 20,fontWeight: FontWeight.bold),),
                    Text( index.isEven ? note.length>250 ? "${note.substring(0,250)} ...":note:note1,style: TextStyle(color: white.withOpacity(0.7)),)

                  ],
                ),
              );
            },
          ),

        ),
      ],
    );

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         Navigator.push(context,MaterialPageRoute(builder: (context)=>createNote()));
      },

          backgroundColor: cardColor,
          foregroundColor: white.withOpacity(0.7),
          child: Icon(Icons.add,size: 45,)
      ),
      endDrawerEnableOpenDragGesture: true,
      key: _drawerkey,
      drawer: sidebar(drawer: "Archive",),
      backgroundColor:  bgColor,
      body: SafeArea(
          child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cardColor,
                    boxShadow: [BoxShadow(color: black.withOpacity(0.2),blurRadius: 3,spreadRadius: 1)]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                              IconButton(onPressed: (){
                                _drawerkey.currentState!.openDrawer();
                              }, icon: Icon(Icons.menu,color: white.withOpacity(0.5),)),
                            SizedBox(width: 16,),
                          Container(
                                width: 140,
                                height: 55,
                                decoration: BoxDecoration(
                                 // border: Border.all(color: white),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Search your Notes",style: TextStyle(color: white.withOpacity(0.5),fontSize: 16),)
                                  ],
                                ),
                              )
            
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TextButton(onPressed: (){}, child: Icon(Icons.grid_view,color: white.withOpacity(0.5),),style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith((states)=>white.withOpacity(0.2)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                            ),),
                            CircleAvatar(backgroundColor: Colors.white,radius: 20,)
            
                          ],
                        ),
                      ),
                    ],
                  ),
            
                ),
                isLoading?Container(
                  child: Center(child: CircularProgressIndicator(),),
                )
                    :
                staggeredViewAll(),

            
              ],
            ),
          )
      ),
    );
  }
}
