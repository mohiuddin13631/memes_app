import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memes/model/memes_model.dart';
import 'package:http/http.dart' as http;
import 'package:memes/widgets/custom_color.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  Memes? memes;

  List<Memes> memesList = [];
  loadMemes() async{
    String url = "https://api.imgflip.com/get_memes";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    // memesModel = MemesModel.fromJson(data);
    for(var i in data['data']['memes']){
      setState(() {
        memesList.add(Memes.fromJson(i));
      });
    }
    // print(memesList);
  }

  var name = "Nothing Search";
  var isFound = false;
  var image = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  cursorColor: Colors.white,
                  controller: searchController,
                  style: TextStyle(color: Colors.white),
                  onEditingComplete: () async {
                      for(var i in memesList){
                        if(i.name.toString() == searchController.text.toString()){
                            name = i.name.toString();
                            image = i.url.toString();
                            isFound = true;
                            break;
                        }

                      }
                      if(isFound == true){
                        setState(() {

                        });
                      }else{
                        name = "Not found";
                        setState(() {

                        });
                      }

                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Enter memes name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(16)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(16)),
                    prefixIcon: Icon(Icons.search,color: Colors.blue,),
                    suffixIcon: InkWell(
                        onTap: () {
                          searchController.clear();
                          isFound = false;
                          name = "Nothing Search";
                          setState(() {

                          });
                        },
                        child: Icon(Icons.cancel_outlined,color: Colors.blue,)),
                  ),
                ),
                SizedBox(height: 19,),
                MasonryGridView.count(
                  shrinkWrap: true,
                  itemCount: keyword.length,
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        searchController.text = keyword[index];
                        setState(() {
                          searchController.text = keyword[index];
                        });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(keyword[index],style: TextStyle(color: Colors.black),),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12,),

                isFound == true?
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(21),
                        child: Image.network(
                          image
                        ),
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ):Center(child: Text(name,style: TextStyle(fontSize: 20,color: Colors.white),),),

              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> keyword = [
    "Two Buttons",
    "Distracted Boyfriend",
    "Running Away Balloon",
    "UNO Draw 25 Cards",
    "Change My Mind",
    "Waiting Skeleton",
    ];
}
