import 'dart:convert';

import 'package:http/http.dart';

class worker{
  String location="";
  String temp="";
  String Humidity="";
  String depretion="";
  String Air_speed="";
  String main="";
  String icon="";
  //Methods
  worker(this.location){
    location=this.location;
  }
  Future<void> getData() async{
    try{
      Response response= await get(Uri.parse("http://api.openweathermap.org/data/2.5/weather?q=$location&appid=fd6e496ee3be2eedde0211bc3d15d322"));
      Map Data= jsonDecode(response.body);

      Map temp_data=Data['main'];
      double gettemp=temp_data['temp']-273.15;


      List weather_data= Data['weather'];
      Map weather_main_data=weather_data[0];
      String getMain_des= weather_main_data['main'];

      Map wind=Data['wind'];
      double getAir_speed=wind["speed"]*3.6;

      String  main_des= weather_main_data['description'];


      int get_humidity=temp_data['humidity'];
      temp=gettemp.toString();
      Humidity=get_humidity.toString();
      depretion=main_des.toString();
      Air_speed=getAir_speed.toString();
      main=main_des;
      icon=weather_main_data['icon'];
    }catch(e){

      temp="N/A.";
      Humidity="N/A.";
      depretion="Can't get data";
      Air_speed="N/A.";
      main="N/A.";
      icon="04d";
    }




  }

}