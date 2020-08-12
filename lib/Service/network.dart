import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:wallpaperApp/Constant/stringsConstant.dart';
import 'package:wallpaperApp/Models/serializers.dart';
import 'package:wallpaperApp/Models/wallpaper.dart';

class Network{

  static final Network _network=Network._();
  
  Network._();

  factory Network()=>_network;

 Future<Wallpaper> getOrderData({String order="popular"})async{
    Wallpaper paper; //(Random().nextInt(3)+1)
    String url="${Strings.API_URL}&order=$order";
    print(url);
    var response=await http.get(url);
    print(response.statusCode);
    if(response.statusCode==200){
    try {
      paper=serializers.deserializeWith(Wallpaper.serializer,jsonDecode(response.body));
     
    } catch (e) {
      throw Exception(e);
    }
    }else{
      throw Exception('Bağlantı hatası');
    }
    
    return paper;
  }
 Future<Wallpaper> getCategoryData({String category})async{
    Wallpaper paper; //(Random().nextInt(3)+1)
    String url="${Strings.API_URL}${category!=null?("&category=$category"):("")}";
    print(url);
    var response=await http.get(url);
    print(response.statusCode);
    if(response.statusCode==200){
    try {
      paper=serializers.deserializeWith(Wallpaper.serializer,jsonDecode(response.body));
     
    } catch (e) {
      throw Exception(e);
    }
    }else{
      throw Exception('Bağlantı hatası');
    }
    
    return paper;
  }

 Future<Wallpaper> getData({String imageType="all",bool editorsChoice=false,String order="popular"})async{
    Wallpaper paper; //(Random().nextInt(3)+1)
    String url="${Strings.API_URL}&image_type=$imageType&editors_choice=$editorsChoice&order=$order";
    print(url);
    var response=await http.get(url);
    print(response.statusCode);
    if(response.statusCode==200){
    try {
      paper=serializers.deserializeWith(Wallpaper.serializer,jsonDecode(response.body));
     
    } catch (e) {
      throw Exception(e);
    }
    }else{
      throw Exception('Bağlantı hatası');
    }
    
    return paper;
  }
  Future<Wallpaper> searchImage(String query)async{
    Wallpaper paper;
   var response=await http.get("${Strings.SEARCH_URL}$query");
   if(response.statusCode==200){
    try {
      paper=serializers.deserializeWith(Wallpaper.serializer,jsonDecode(response.body));
     
    } catch (e) {
      throw Exception(e);
    }
    }else{
      throw Exception('Bağlantı hatası');
    }
    
    return paper;
  }
}