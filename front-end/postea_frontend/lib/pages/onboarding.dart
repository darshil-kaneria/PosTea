import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postea_frontend/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postea_frontend/pages/homepage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Onboarding extends StatefulWidget {
  var username;
  Onboarding({this.username});
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  File imgToUpload;

  pickImage() async {
    // PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    imgToUpload = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(imgToUpload);
    setState(() {});
  }

  Future uploadProfilePic(File file, String profileID) async {
    if (file == null) {
      final assetImage =
          await rootBundle.load("assets/sample_images/default-big.png");

      final fileImg = File(
          '${(await getTemporaryDirectory()).path}/sample_images/default-big.png');
      await fileImg.writeAsBytes(assetImage.buffer
          .asUint8List(assetImage.offsetInBytes, assetImage.lengthInBytes));

      file = fileImg;
    }
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("profile").child(profileID);
    await storageReference.putFile(file).onComplete;
    print("Uploaded image to Firebase from onboarding profile");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // imgToUpload = File("assets/sample_images/default-big.png");
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var profileID;
    // Future<Image> defaultImg = FirebaseStorageService.getImage(context, "default-big.png");

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [onboardingStart, onboardingEnd])),
          child: PageView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 20),
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                            "Hey! Welcome to Postea. What should everyone call you?",
                            style: GoogleFonts.openSans(
                                fontSize: 30, color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.topCenter,
                        color: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 30),
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.white38),
                            hoverColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[100]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                        )),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 20),
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                            "Tell us something about yourself. You can brag about your skills here!",
                            style: GoogleFonts.openSans(
                                fontSize: 30, color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.topCenter,
                        color: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextField(
                          minLines: 10,
                          maxLines: 15,
                          controller: bioController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 30, top: 20),
                            hintText: "Tell us who you are!",
                            hintStyle: TextStyle(color: Colors.white38),
                            hoverColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[100]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 20),
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                            "Add your photo (or a meme, if you're into that)",
                            style: GoogleFonts.openSans(
                                fontSize: 30, color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        await pickImage();
                        print(imgToUpload);
                      },
                      child: Container(
                        height: screenWidth / 3,
                        width: screenWidth / 3,
                        decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side: BorderSide(
                                    width: 1, color: Colors.blueGrey))),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: (imgToUpload != null)
                                ? Image.file(imgToUpload)
                                : Image(
                                    image: AssetImage(
                                        "assets/sample_images/default-big.png")),
                          ),
                          maxRadius: screenWidth / 8,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ButtonTheme(
                      height: MediaQuery.of(context).size.height / 16,
                      minWidth: MediaQuery.of(context).size.width / 3,
                      child: RaisedButton(
                        onPressed: () async {
                          print(nameController.text);
                          print(bioController.text);
                          print(widget.username);

                          var reqBody = JsonEncoder().convert({
                            "username": widget.username,
                            "privateAcc": 0,
                            "name": nameController.text,
                            "biodata": bioController.text,
                            "profilePic": ""
                          });

                          Response response = await post(
                              "https://postea-server.herokuapp.com/profile",
                              headers: {'Content-Type': 'application/json'},
                              body: reqBody);
                          // print(response.statusCode);

                          profileID = jsonDecode(response.body);
                          uploadProfilePic(imgToUpload, widget.username);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      profileID: profileID['profile_id'])));
                        },
                        elevation: 1,
                        color: Colors.white,
                        highlightColor: Colors.brown[100],
                        child: Text(
                          'Get Started',
                          style: GoogleFonts.openSans(fontSize: 18),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Colors.transparent)),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();
  static Future<dynamic> getImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(image)
        .getDownloadURL();
  }
}
