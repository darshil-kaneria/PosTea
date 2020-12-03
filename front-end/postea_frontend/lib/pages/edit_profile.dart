import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:postea_frontend/main.dart';

class EditProfile extends StatefulWidget {
  var nameText;
  var biodata;
  bool privacy;
  var username;
  File profilePic;
  var profile_id;

  EditProfile(
      {@required this.nameText,
      this.biodata,
      this.privacy,
      this.username,
      this.profile_id});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var nameController = TextEditingController();
  var biodataController = TextEditingController();
  File profilePic;
  var _image;

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.nameText;
    biodataController.text = widget.biodata;
    super.initState();
  }

  chooseProfilePic() async {
    // PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    print("about to choose image");
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      print("In dot then");
      print(value);
      profilePic = value;
    });
    print("chosen image is " + profilePic.toString());
    print(profilePic);
  }

  Future uploadProfilePic(File file, String username) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(widget.profile_id.toString());
    print("before query");
    await storageReference.putFile(file).onComplete;
    print("after query");
    print("Uploaded image to Firebase from edit profile");
  }

  updateProfile() async {
    var sendAnswer = JsonEncoder().convert({
      "original_username": widget.username,
      "update_privateAcc": widget.privacy.toString(),
      "update_name": nameController.text,
      "update_biodata": biodataController.text,
      "update_profilePic": "random"
    });

    http.Response resp =
        await http.put("http://postea-server.herokuapp.com/profile",
            headers: {
              'Content-Type': 'application/json',
              HttpHeaders.authorizationHeader: "Bearer posteaadmin",
            },
            body: sendAnswer);
    print(resp.body);
    if (resp.statusCode == 200)
      print("success");
    else
      print("Some error");
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var profileImgName = widget.username.toString() + ".JPG";
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: Theme.of(context).buttonColor),
        ),
        extendBodyBehindAppBar: false,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new GestureDetector(
                          onTap: () async {
                            // profilePic = await ImagePicker.pickImage(
                            //     source: ImageSource.gallery);
                            await chooseProfilePic().then((val) {
                              setState(() {
                                _image = profilePic;
                              });
                            });

                            print("I have chosen the image " +
                                profilePic.toString());
                          },
                          child: Container(
                            height: screenWidth / 3,
                            width: screenWidth / 3,
                            decoration: ShapeDecoration(
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 1, color: Colors.blueGrey))),
                            child: profilePic != null
                                ? Image.file(
                                    profilePic,
                                    height: 300,
                                    width: 300,
                                  )
                                : FutureBuilder(
                                    future: FirebaseStorageService.getImage(
                                        context, widget.profile_id.toString()),
                                    builder: (context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.hasData) {
                                        return CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(snapshot.data),
                                          maxRadius: screenWidth / 8,
                                        );
                                      } else {
                                        return CircularProgressIndicator(
                                          strokeWidth: 2,
                                          backgroundColor: bgColor,
                                          valueColor: AlwaysStoppedAnimation(
                                              loginButtonEnd),
                                        );
                                      }
                                    }),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(15.0),
                      //     child: ButtonTheme(
                      //       shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(100),
                      //             side: BorderSide(color: Colors.redAccent)),
                      //       child: RaisedButton(
                      //         elevation: 1,
                      //         color: loginButton,
                      //         highlightColor: Colors.red[700],
                      //         onPressed: () {

                      //       },
                      //       child: Text("Edit profile image", style: TextStyle(
                      //                 fontFamily: "Helvetica",
                      //                 color: Colors.white,
                      //                 fontSize: 16),),),
                      //     ),
                      //   ),
                      // )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    // style: Theme.of(context).textTheme.headline5,
                    controller: nameController,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        // labelText: "Name",
                        labelStyle: TextStyle(color: Colors.brown[200]),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepOrange[700]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        hintText: "What should we call you?"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Theme.of(context).accentColor,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: biodataController,
                    minLines: 5,
                    maxLines: 10,
                    decoration: InputDecoration(
                        // labelText: "About",
                        labelStyle: TextStyle(
                            color: Colors.brown[200],
                            fontWeight: FontWeight.bold),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Colors.deepOrange[700])),
                        hintText: "Tell everyone something about yourself :)"),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Material(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                          title: Text("Private profile"),
                          trailing: Switch(
                              value: widget.privacy,
                              activeTrackColor: Colors.deepOrange[200],
                              activeColor: Colors.deepOrange[700],
                              onChanged: (value) {
                                setState(() {
                                  widget.privacy = value;
                                });
                              })),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: Colors.redAccent)),
                  child: RaisedButton(
                    elevation: 1,
                    color: loginButton,
                    highlightColor: Colors.red[700],
                    onPressed: () async {
                      await updateProfile();
                      print("profile pic is " + profilePic.toString());
                      await uploadProfilePic(profilePic, widget.username);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
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
