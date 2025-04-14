import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'models.dart';

class ctg extends StatefulWidget {
  String Q;
  ctg({required this.Q});

  @override
  State<ctg> createState() => _ctgState();
}

class _ctgState extends State<ctg> {
  List <NewsModel> newsModel=<NewsModel>[];
  bool  isloading=true;
  getNewsByQurey(String Q) async{
    String Url="https://newsapi.org/v2/top-headlines?category=${Q}&apiKey=4663d4169510446b9cca9c8156077904";
    Response response= await get(Uri.parse(Url));
    Map data=jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((_element){
        NewsModel model=NewsModel();
        model=NewsModel.fromMap(_element);
        newsModel.add(model);
        setState(() {
          isloading=false;
        });
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQurey(widget.Q);
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



            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 17, 0, 0),
                  child:Row(
                    children: [
                      Text(widget.Q,style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),)
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
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 2.0,
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius:BorderRadius.circular(15),
                              child: Image.network(newsModel[index].urlToImage,fit: BoxFit.fitWidth,width: double.infinity)
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
                  );
                },
              ),
            ),

            //Text
          ],
        ),
      ),

    );
  }
}

