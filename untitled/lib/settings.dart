import 'package:flutter/material.dart';
import 'package:untitled/Colors.dart';
import 'package:untitled/services/login_info.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
   late bool value=true;
   getSyncSet() async{
     await LocalDataSaver.getSyncData().then((valueDb){
       setState(() {
         value=valueDb!;
       });
     });
   }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSyncSet();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: white.withOpacity(0.7),
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text("Sync",style: TextStyle(color: white.withOpacity(0.7),fontSize: 18),),
                Spacer(),
                Switch.adaptive(value: value, onChanged: (switchValue){
                  setState(() {
                    this.value=switchValue;
                    LocalDataSaver.saveSyncValue(switchValue);
                  });

                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
