import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mosam_app/worker/worker.dart';

String city="california";

class loding extends StatefulWidget {
  const loding({super.key});
  @override
  State<loding> createState() => _lodingState();
}

class _lodingState extends State<loding> {

  void StartApp(String c) async{
    worker mosam=worker("$c");
    await mosam.getData();
    print("loading page icon");
    print(mosam.icon);
    Future.delayed(Duration(seconds: 2),()=>{
    Navigator.pushReplacementNamed(context, '/home',arguments: {
    "temp_value":mosam.temp,
    "air_speed":mosam.Air_speed,
    "location":mosam.location,
    "description":mosam.depretion,
    "Humidity":mosam.Humidity,
    "main":mosam.main,
      "icon":mosam.icon,
      "city":mosam.location
    })
    });
    

  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    Map? search=ModalRoute.of(context)?.settings.arguments as Map?;
    if(search?.isNotEmpty ?? false){
      city=search?["city"];
    }
    StartApp(city);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 250,),
              Image.asset("assets/img1.png",height: 180,width: 180,),
              Text("Moasum App" ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white), ),
              SizedBox(height: 8,),
              Text("Made by Umair",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),),
              SizedBox(height: 30,),
              SpinKitWave(
                 color: Colors.white70,
                 size: 50.0,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue[300],
    );
  }
}
