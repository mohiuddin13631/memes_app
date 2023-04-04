import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:memes/controller/custom_http.dart';
import 'package:memes/model/memes_model.dart';
import 'package:memes/view/details.dart';

import 'package:memes/view/search_page.dart';
import 'package:memes/widgets/custom_color.dart';
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: bgColor,
      backgroundColor: Color(0xff844ad5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                children: [
                  Text("Memes Gallery",style: TextStyle(color: textColorWhite,fontSize: 30,fontWeight: FontWeight.bold),),
                  Spacer(),
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context) => SearchPage(),));
                  }, icon: Icon(Icons.search_outlined,color: textColorWhite,size: 40,)),

                ],
              ),
            ),
            const SizedBox(height: 20,),
            // Spacer(),
            FutureBuilder<MemesModel>(
              future: CustomHttpRequest.memesApiCall(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }
                else{
                  return Container(
                    height: size.height*.85,
                    padding: const EdgeInsets.only(top: 16,right: 16,left: 16),
                    decoration: const BoxDecoration(
                      // color: Colors.teal,
                      color: Color(0xff020520),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.memes!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: .8),
                      itemBuilder: (context, index) {
                        var memes = snapshot.data!.data!.memes![index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Details(memes: memes),));
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditImage(memes: memes),));
                              // String imagePath = memes.url.toString();
                              // cropImage(memes.url.toString());
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      // border: Border.all(),
                                      image: DecorationImage(
                                          image: NetworkImage(memes.url.toString()),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                Positioned(
                                  left: 6,
                                  bottom: 3,
                                  child: Text(memes.name.toString(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                )
                              ],
                            )
                          ),
                        );
                      },
                    ),
                  );
                }
              },),
          ],
        ),
      )
    );
  }

  String? _croppedFile;

  cropImage(filepath) async {
    // var cropImage = await ImageCropper.platform.cropImage(sourcePath: filepath);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      // sourcePath: widget.memes.url.toString(),
      sourcePath: filepath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile.path;
      });
    }
  }
}
