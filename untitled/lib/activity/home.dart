import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:http/http.dart';
import 'package:weather_icons/weather_icons.dart';
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int conter=1;


  @override
  void initState() {
    super.initState();
    //getData();
    print("This is init state");
  }
  @override
  Widget build(BuildContext context) {
    Map? info=ModalRoute.of(context)?.settings.arguments as Map?;
    TextEditingController searchControlar=new TextEditingController();
    String? temp= info?["temp_value"].toString().substring(0,4);
    String? icon=info?["icon"];
    print(info?.entries);
    String? city=info?["city"];
    String? Air_speed=info?["air_speed"].toString().substring(0,4);
    String? humidity=info?["Humidity"];
    String? discp=info?["description"];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(preferredSize: Size.fromHeight(0), child: GradientAppBar(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              Color(0xFFcaf0f8), // Light Aqua Blue
              Color(0xFF90e0ef), // Sky Blue
              Color(0xFF0077b6)], // Deep Blue
          )
      )),
      body: SingleChildScrollView(
        child: SafeArea(
          
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFcaf0f8), // Light Aqua Blue
                    Color(0xFF90e0ef), // Sky Blue
                    Color(0xFF0077b6), // Deep Blue
                  ]
              ),
        
            ),
            child: Column(
              children: [
                Container( //Search Bar
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(vertical: 20,horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                      color: Color(0x66FFFFFF) // White with opacity (40%)
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(searchControlar.text.replaceAll(" ", "")=="")
                            print("Empty search");
                          else {
                            Navigator.pushReplacementNamed(
                                context, '/loading', arguments: {
                              "city": searchControlar.text
                            });
                          }
                          },
                        child: Container(child: Icon(Icons.search,color: Colors.blue,size: 30,),margin: EdgeInsets.fromLTRB(7, 0, 10, 0),),
                      ),
                      Expanded(child: TextField(
                        controller:searchControlar,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search any city"
                        ),
                      ))
                      //Text("Text")
                    ],
                  ),
                ),//Search Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(26),
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Row(
                          children: [
                            Image.network("http://openweathermap.org/img/wn/$icon@2x.png"),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$discp",style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),),
                                Text("in $city",style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),)
                              ],
                            )
                          ],
                        )
                      ),
                    )
                  ],
                ),//Box One
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 240,
                        padding: EdgeInsets.all(26),
                        margin: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Icon(WeatherIcons.hot,size: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("$temp" ,style: TextStyle(fontSize: 90),),
                                Text("C",style: TextStyle(fontWeight: FontWeight.bold,),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),//big centeral Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                       height: 200,
                        padding: EdgeInsets.all(26),
                        margin: EdgeInsets.fromLTRB(24, 0, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(WeatherIcons.day_light_wind)
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text("$Air_speed",style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                            ),),
                            Text("km/hr")
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 200,
                        padding: EdgeInsets.all(26),
                        margin: EdgeInsets.fromLTRB(10, 0, 24, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(WeatherIcons.humidity)
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text("$humidity",style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold
                            ),),
                            Text("%")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),//Third Row
                SizedBox(height: 15,),
                Container(
                  padding: EdgeInsets.all(50),
        
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Made by Umair Hassan",style: TextStyle(color: Colors.white,),),
                      Text("Data provided by OpenWeatherMap.org",style: TextStyle(color: Colors.white,))
                    ],
                  ),
                )//Outro
              ],
            ),
          ),
        ),
      ),
    );
  }
}
