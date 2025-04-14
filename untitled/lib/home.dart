import 'package:flutter/material.dart';
import 'package:untitled/CreateNote.dart';
import 'package:untitled/NotesView.dart';
import 'package:untitled/SearchView.dart';
import 'package:untitled/models/reportModel.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/db.dart';
import 'package:untitled/services/fireStore_db.dart';
import 'package:untitled/services/login_info.dart';
import 'package:untitled/sidebar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Colors.dart';
import 'login.dart';
import 'services/db.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _drawerkey = GlobalKey();

  late List<Note> notes;
  bool isstagared=true;
  late List<Note> pinnedNotes = [];
  late String? imgUrl="";
  bool isLoading = true;
  bool isLoading2 = true;

  Future CreateEntry() async {
    final note1 = Note(
      title: "New Test",
      content:
          "New content This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note This is Note",
      pin: false,
      uniqueID: "gSGGSGSDCVDSFEAZVDCCZVAGFSCZVZVVCXDg",
      createdTime: DateTime.now(),
    );
    await NotesDB.instance.create(note1);
  }

  Future ReadAlld() async {
    this.notes = await NotesDB.instance.ReadAll();
    await LocalDataSaver.getImg().then((value) {
      if (this.mounted) {
        setState(() {
          imgUrl = value;
        });
      }
    });
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future ReadPinned() async {
    this.pinnedNotes = await NotesDB.instance.readPinned();
    print(pinnedNotes);
    setState(() {
      isLoading2 = false;
    });
  }

  String drawerOpen = "Notes";

  Future getOneNote(int id) async {
    await NotesDB.instance.ReadOne(id);
  }

  Future UpdateOneNode(Note note) async {
    await NotesDB.instance.Update(note);
  }

  Future Delete(Note note) async {
    await NotesDB.instance.delete(note);
  }

  Future cleardb() async {
    await NotesDB.instance.clearDatabase();
  }

  Future migrate() async {
    await NotesDB.instance.migrateNotesTableToAddIsArchived(); // Run migration
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => noteView(note: notes[index]),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: white.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notes[index].title,
                  style: TextStyle(
                    color: white.withOpacity(0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  notes[index].content.length > 250
                      ? "${notes[index].content.substring(0, 250)} ..."
                      : notes[index].content,
                  style: TextStyle(color: white.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        );
      },
    ),

  );}
  Widget ListViewAll(List<Note> notes){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
          child: Column(
            children: [
                         ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
          child:
          ListView.builder(

            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,

            itemBuilder: (context,index){
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => noteView(note: notes[index]),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notes[index].title,
                        style: TextStyle(
                          color: white.withOpacity(0.7),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        notes[index].content.length > 250
                            ? "${notes[index].content.substring(0, 250)} ..."
                            : notes[index].content,
                        style: TextStyle(color: white.withOpacity(0.7)),
                      ),
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
  Widget staggeredViewAll(List<Note> notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: MasonryGridView.builder(
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // Number of columns
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => noteView(note: notes[index]),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notes[index].title,
                        style: TextStyle(
                          color: white.withOpacity(0.7),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        notes[index].content.length > 250
                            ? "${notes[index].content.substring(0, 250)} ..."
                            : notes[index].content,
                        style: TextStyle(color: white.withOpacity(0.7)),
                      ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //cleardb();
    //Note note4;
    //CreateEntry();
    //migrate();
    ReadPinned();
    ReadAlld();

    //CreateEntry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => createNote()),
          );
        },
        backgroundColor: cardColor,
        foregroundColor: white.withOpacity(0.7),
        child: Icon(Icons.add, size: 45),
      ),
      endDrawerEnableOpenDragGesture: true,
      key: _drawerkey,
      drawer: sidebar(drawer: "Notes"),
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _drawerkey.currentState!.openDrawer();
                          },
                          icon: Icon(Icons.menu, color: white.withOpacity(0.5)),
                        ),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => searchView(),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2.5,
                            height: 55,
                            decoration: BoxDecoration(
                             // border: Border.all(color: white),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Search your Notes",
                                  style: TextStyle(
                                    color: white.withOpacity(0.5),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isstagared=!isstagared;
                              });
                            },
                            child: Icon(
                              Icons.grid_view,
                              color: white.withOpacity(0.5),
                            ),
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                (states) => white.withOpacity(0.2),
                              ),
                              shape: MaterialStateProperty.all<
                                RoundedRectangleBorder
                              >(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              signOut();
                              LocalDataSaver.saveLoginData(false);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Login()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              onBackgroundImageError: (Object,StackTrace){
                                print("ok");
                              },

                               backgroundImage: NetworkImage(imgUrl.toString()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading2)
                Container(
                  child: Center(child: CircularProgressIndicator(color: white)),
                )
              else if (pinnedNotes.length > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Pinned Notes",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isstagared?staggeredViewAll(pinnedNotes):ListViewAll(pinnedNotes),

                  ],
                ),
              isLoading
                  ? Container(
                    child: Center(
                      child: CircularProgressIndicator(color: white),
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "All",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isstagared?staggeredViewAll(notes):ListViewAll(notes),
                    ],
                  ),

              // isLoading?Container(child: Center()):ListViewAll()
            ],
          ),
        ),
      ),
    );
  }
}
