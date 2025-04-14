import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:newsapp/httpview.dart';

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
  List <NewsModel> newsModel=<NewsModel>[];
  List<NewsModel> recipeModels=[];
  //Function

  getNewsByQurey(String Q) async{
    String Url="https://newsapi.org/v2/everything?q=${Q}&language=en&sortBy=publishedAt&apiKey=4663d4169510446b9cca9c8156077904";
    Response response= await get(Uri.parse(Url));
    Map data=jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((_element){
        NewsModel model=NewsModel();
        model=NewsModel.fromMap(_element);
        print(model.title);
        print(model.urlToImage);
        print(model.url);
        if(model.urlToImage!="https://default.image")
          newsModel.add(model);
        setState(() {
          isloading=false;
        });
      });
    });
  }  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQurey(widget.qurey);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children:[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,


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
                      child:Container(//Search Bar
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
                                  child: Icon(Icons.search,size: 35,color: Colors.black,)
                              ),
                              onTap: (){
                                if((Tcontorler.text).replaceAll(" ", "")=="")
                                {
                                  print("Empty search");
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder:(context)=> Search(Tcontorler.text)));
                                }
                              },
                            ),
                            Expanded(child: TextField(
                              controller:Tcontorler,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value){
                                print(value);
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search any Recipe",
                                  hintStyle: TextStyle(color: Colors.black),
                                  fillColor: Colors.white10,
                                  filled: true
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    //Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),child: Text("Your Search Results",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                    Container(
                      child:isloading?CircularProgressIndicator():  Container(
                        child: ListView.builder(
                          itemCount: newsModel.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              //child: Image.asset("images/img1.jpg"),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder:(context)=> Recipeview(url: newsModel[index].url)));

                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  elevation: 2.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:BorderRadius.circular(15),
                                          child: Image.network(newsModel[index].urlToImage,fit: BoxFit.fitWidth,width: double.infinity,errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              "images/img1.jpg",
                                              fit: BoxFit.fitWidth,
                                              width: double.infinity,
                                            );
                                          })
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child:Container(
                                          padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black
                                              ],
                                                  end: Alignment.bottomCenter,
                                                  begin: Alignment.topCenter
                                              ),
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(newsModel[index].title ,style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17
                                              ),),
                                              Text(newsModel[index].description.length> 50?"${newsModel[index].description.substring(0,45)} ....":newsModel[index].description,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
