
class RecipeModel{
  late String Label;
  late String image;
  late double calories;
  late String appurl;
  RecipeModel({this.appurl="",this.calories=0 ,this.image="",this.Label=""});
  factory RecipeModel.fromMap(Map recipe){
    return RecipeModel(
      Label: recipe["label"],
      calories: recipe["calories"],
      image: recipe["image"],
       appurl: recipe["url"]
    );
  }

}