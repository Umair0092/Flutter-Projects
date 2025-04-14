import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodrecipyapp/RecipeView.dart';
import 'package:http/http.dart' as http;

import 'models.dart';
class Search extends StatefulWidget {
  String qurey="";
  Search(this.qurey, {super.key});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController Tcontorler=TextEditingController();
  Map<String, dynamic> data={};
  bool isloading=true;

  List<RecipeModel> recipeModels=[];
  //Function
  List reciptCatList = [{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"}];
  
  Future<void> fetchRecipes(String query) async {
    final String url =
        'https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=498b2aba&app_key=4affc96041780843564b8a16b10426c4&diet=balanced';

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Edamam-Account-User': 'umairhassan0092',
      'Accept-Language': 'en',
    };

    try {
      final http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
         data= jsonDecode(response.body);
        // Process the data as needed
        data["hits"].forEach((element){
          RecipeModel recipeModel=RecipeModel();
          recipeModel=RecipeModel.fromMap(element["recipe"]);
          recipeModels.add(recipeModel);
        });
        setState(() {
          isloading=false;

        });
        for (var _element in recipeModels) {
          print(_element.Label);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRecipes(widget.qurey);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFA726), // Light Orange
                Color(0xFFFF7043), // Deep Orange
                Color(0xFFD84315)
              ], // Burnt Orange])
            ),
          ),

          /*
          * InWell -Tap,Doubletap etc
          * we also have Gesture detector but InWell provides us with more functionality
          * Card
          * ClipRRect -Frame - Photo
          * ClipPath create your own frames
          * position -can use in stack
          * */
          child:SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(//Search Bar
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 20,horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Color(0x66FFFFFF) // White with opacity (40%)
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(7, 0, 10, 0),
                            child: Icon(Icons.search,size: 35,color: Colors.white,)
                          ),
                          onTap: (){
                              if((Tcontorler.text).replaceAll(" ", "")=="")
                                {
                                  print("Empty search");
                                }
                              else{
                                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> Search(Tcontorler.text)));

                              }
                          },
                        ),
                        Expanded(
                            child:Expanded(child: TextField(
                              controller:Tcontorler,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search any Recipe",
                                hintStyle: TextStyle(color: Colors.white)

                              ),
                            ))
                        )
                      ],
                    ),
                  ),
                ),
                //Text

                Container(
                  child:isloading?CircularProgressIndicator(): ListView.builder(
                    itemCount: recipeModels.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,//Always define it when list s defined in column
                      itemBuilder: (context,index){
                             return InkWell(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder:(context)=> Recipeview(url: recipeModels[index].appurl)));

                               },
                               child: Card(
                                 margin: EdgeInsets.all(20),
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10)
                                 ),
                                 elevation: 0.0,
                                 child: Stack(
                                   children: [
                                     ClipRRect(
                                       borderRadius: BorderRadius.circular(10),
                                       child: Image.network(recipeModels[index].image,
                                         fit: BoxFit.cover,
                                         width: double.infinity,
                                         height: 200,
                                       ),
                                     ),
                                     Positioned(
                                         left: 0,
                                         bottom: 0,
                                         right: 0,
                                         child: Container(
                                             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                             decoration: BoxDecoration(
                                               color: Color(0x66FFFFFF),
                                             ),
                                             child: Text(recipeModels[index].Label,
                                               style: TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 15
                                               ),
                                             )
                                         )
                                     ),
                                     Positioned(
                                        top: 0,
                                         right: 0,
                                         height: 40,
                                         width: 80,
                                         child: Container(
                                             decoration: BoxDecoration(
                                               color: Color(0x66FFFFFF),
                                               borderRadius: BorderRadius.only(
                                                 topRight: Radius.circular(10),
                                                 bottomLeft: Radius.circular(10),
                                               )
                                             ),
                                             child: Center(
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: [
                                                   Icon(Icons.local_fire_department,size: 20,),
                                               Text(recipeModels[index].calories.toStringAsFixed(2)),
                                               
                                                 ],
                                               ),
                                             )
                                         )
                                     )
                                   ],
                                 ),
                               ),
                             );
                      },
                      ),
                ),

              ],
            ),
          ) ,
        )]
      ),
    );
  }
}
