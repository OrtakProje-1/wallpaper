import 'package:http/http.dart' as http;
import 'package:wallpaper/Constant/stringsConstant.dart';
import 'package:wallpaper/Models/wallpaper.dart';

class Network {
  static final Network _network = Network._();

  Network._();

  factory Network() => _network;

  Future<Wallpaper?> getOrderData({String order = "popular"}) async {
    Wallpaper? paper; //(Random().nextInt(3)+1)
    String url = "${Strings.API_URL}&order=$order";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        paper = Wallpaper.fromJson(response.body);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception('Bağlantı hatası');
    }

    return paper;
  }

  Future<Wallpaper?> getCategoryData({String? category}) async {
    Wallpaper? paper; //(Random().nextInt(3)+1)
    String url =
        "${Strings.API_URL}${category != null ? ("&category=$category") : ("")}";
    print(url);
    var response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      try {
        paper = Wallpaper.fromJson(response.body);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception('Bağlantı hatası');
    }

    return paper;
  }

  Future<Wallpaper?> getData(
      {String imageType = "all",
      bool? editorsChoice = false,
      String order = "popular"}) async {
    Wallpaper? paper; //(Random().nextInt(3)+1)
    String url =
        "${Strings.API_URL}&image_type=$imageType&editors_choice=$editorsChoice&order=$order";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        paper = Wallpaper.fromJson(response.body);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception('Bağlantı hatası');
    }
    return paper;
  }

  Future<Wallpaper?> searchImage(String query) async {
    Wallpaper? paper;
    var response = await http.get(Uri.parse("${Strings.SEARCH_URL}$query"));
    if (response.statusCode == 200) {
      try {
        paper = Wallpaper.fromJson(response.body);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception('Bağlantı hatası');
    }

    return paper;
  }
}
