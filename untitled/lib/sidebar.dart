import 'package:flutter/material.dart';
import 'package:untitled/Colors.dart';
import 'package:untitled/archieve_View.dart';
import 'package:untitled/settings.dart';

import 'home.dart';
class sidebar extends StatefulWidget {
  String drawer;
  sidebar({required this.drawer});

  @override
  State<sidebar> createState() => _sidebarState();
}

class _sidebarState extends State<sidebar> {
  @override
  Widget build(BuildContext context) {
    Widget SectionThree(){
      return  Container(
        margin: EdgeInsets.only(right: 15),
        child: TextButton(
            style: ButtonStyle(
                backgroundColor:widget.drawer=="Settings"? MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.5)):MaterialStateProperty.all(bgColor),

                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50))))
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>settings()));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(Icons.settings_outlined,size: 25,color: white.withOpacity(0.7),),
                  SizedBox(width: 15,),
                  Text("Settings",style: TextStyle(color: white.withOpacity(0.7),fontSize: 20),)
                ],
              ),
            )
        ),
      );
    }
    Widget SectionOne(){
      return  Container(
        margin: EdgeInsets.only(right: 15),
        child: TextButton(
            style: ButtonStyle(
                backgroundColor:widget.drawer=="Notes"? MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.5)):MaterialStateProperty.all(bgColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50))))
            ),
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false,
              );
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(Icons.lightbulb,size: 25,color: white.withOpacity(0.7),),
                  SizedBox(width: 15,),
                  Text("Notes",style: TextStyle(color: white.withOpacity(0.7),fontSize: 20),)
                ],
              ),
            )
        ),
      );
    }
    Widget SectionTwo(){
      return  Container(
        margin: EdgeInsets.only(right: 15),
        child: TextButton(
            style: ButtonStyle(
                backgroundColor:widget.drawer=="Archive"? MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.5)):MaterialStateProperty.all(bgColor),

                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50))))
            ),
            onPressed: (){

              Navigator.push(context, MaterialPageRoute(builder: (context)=> archieveView()));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(Icons.archive_outlined,size: 25,color: white.withOpacity(0.7),),
                  SizedBox(width: 15,),
                  Text("Archive",style: TextStyle(color: white.withOpacity(0.7),fontSize: 20),)
                ],
              ),
            )
        ),
      );
    }
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                  child: Text("Google Keep",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)
              ),
              Divider(color: Colors.white.withOpacity(0.3),),
              SectionOne(),
              SizedBox(height: 5,),
              SectionTwo(),
              SizedBox(height: 5,),
              SectionThree()
            ],
          ),
        ),
      ),
    );
  }
}





