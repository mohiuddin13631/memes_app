import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:memes/model/memes_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/custom_color.dart';

class Details extends StatefulWidget {
  Details({Key? key,required this.memes}) : super(key: key);

  Memes memes;


  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  
  File? imageFile;
  bool _loading = true;
  XFile? netImg;
  bool isEdit = false;
  Future<void> downloadImage() async {
    String imageUrl = widget.memes.url.toString();
    final response = await http.get(Uri.parse(imageUrl));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      _loading = false;
      netImg = XFile(file.path);
    });
  }
  var isEdited = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextButton(
                  onPressed: () {
                    isEdit = true;
                    _cropImage(File(netImg!.path));
                  },
                  child: const Text(
                    "Edit Image",
                    style: TextStyle(color: Colors.white),
                  )))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child:isEdit == false? Image.network(
                    widget.memes.url.toString(),
                  ):Image.file(imageFile!),
                ),
              ),
              Text(
                widget.memes.name.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 8,),

              isEdit == true?
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white
                ),
                  onPressed: (){
                String path = widget.memes.url.toString();
                _saveNetworkImage(imageFile!.path.toString());
              }, child: const Text("Save Image",style: TextStyle(color: Colors.black),)):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();



  void _saveNetworkImage(path) async {
    GallerySaver.saveImage(path).then((success) {
      setState(() {
        print('Image is saved');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image Saved to gallery"))
        );
      });
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path.toString(),
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ] : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [AndroidUiSettings(
            toolbarTitle: "Image Cropper",
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {

      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
        isEdit = true;
      });
      // reload();
    }
  }
}