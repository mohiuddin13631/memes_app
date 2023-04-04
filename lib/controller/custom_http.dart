import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:memes/model/memes_model.dart';
class CustomHttpRequest{

  static Future<MemesModel> memesApiCall() async{
    MemesModel memesModel;
    String url = "https://api.imgflip.com/get_memes";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    memesModel = MemesModel.fromJson(data);
    return memesModel;
  }


}