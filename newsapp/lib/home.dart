import 'dart:convert';
import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:newsapp/httpview.dart';
import 'package:newsapp/search.dart';
import 'catagoriy.dart';
import 'models.dart';
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  TextEditingController Tcontorler=TextEditingController();
  List colors=[Colors.blueAccent,Colors.red,Colors.orange];
  List ListItems=["business","entertainment","general","health","science","sports","technology"];
  List <NewsModel> newsModel=<NewsModel>[];
  List <NewsModel2> newsModel2=<NewsModel2>[];

  bool isloading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQurey("pakistan");
    getNewsByQurey2("");
  }
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
  }
  getNewsByQurey2(String Q) async{
    String Url="https://gnews.io/api/v4/top-headlines?category=general&lang=en&country=pk&max=10&apikey=3cb30289ca88183faa59f12367275ea8";
    Response response= await get(Uri.parse(Url));
    Map data=jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((_element){

        NewsModel2 model=NewsModel2();
        model=NewsModel2.fromMap(_element);
        newsModel2.add(model);
        setState(() {
          isloading=false;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NewsApp"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(//Search Bar
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
            Container(
              height: 50,
              child: ListView.builder(
                itemCount: ListItems.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      //print(ListItems[index]);
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> ctg(Q: ListItems[index])));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      child: Text(ListItems[index],style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.white
                      ),),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 14),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 205,

                  autoPlay: true,
                  enlargeCenterPage: true,

                ),
                  items: newsModel2.map((news)
                  {
                       return Builder(builder: (BuildContext context){
                        return Container(

                          decoration: BoxDecoration(

                          ),
                          child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder:(context)=> Recipeview(url: news.url)));

                              },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child:news.urlToImage==''?Image.asset("images/img1.jpg"): Image.network(news.urlToImage,fit: BoxFit.fitWidth,width: double.infinity,),
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
                                          Text(news.title ,style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19
                                          ),),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                });
              }).toList() ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 17, 0, 0),
                  child:Row(
                    children: [
                      Text("Latest News",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),)
                    ],
                  ),
                )
              ],
            ),
            Container(
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
                                child: Image.network(newsModel[index].urlToImage,fit: BoxFit.fitWidth,width: double.infinity, errorBuilder: (context, error, stackTrace) {
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){}, child: Text("Show More",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),style: ButtonStyle(
                   backgroundColor: WidgetStatePropertyAll(Colors.blue)
                  ),)
                ],
              ),
            )
            //Text
          ],
        ),
      ),

    );
  }
}
