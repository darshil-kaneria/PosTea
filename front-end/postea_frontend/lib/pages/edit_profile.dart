import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  var nameText;
  var biodata;
  bool privacy;

  EditProfile({@required this.nameText, this.biodata, this.privacy});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var nameController = TextEditingController();
  var biodataController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.nameText;
  biodataController.text = widget.biodata;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
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
                      child: Container(
                      height: screenWidth / 3,
                      width: screenWidth / 3,
                      decoration: ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(width: 1, color: Colors.blueGrey))),
                      child: FutureBuilder(
                          future: FirebaseStorageService.getImage(
                              context, "tom_and_jerry.jpeg"),
                          builder: (context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data),
                                maxRadius: screenWidth / 8,
                              );
                            } else {
                              return CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: bgColor,
                                valueColor: AlwaysStoppedAnimation(loginButtonEnd),
                              );
                            }
                          }),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        // labelText: "Name",
                        labelStyle: TextStyle(color: Colors.brown[200]),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange[700]),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "What should we call you?"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: biodataController,
                    minLines: 5,
                    maxLines: 10,
                    decoration: InputDecoration(
                        // labelText: "About",
                        labelStyle: TextStyle(color: Colors.brown[200],fontWeight: FontWeight.bold),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    title: Text("Private profile"),
                    trailing: Switch(value: widget.privacy,
                    activeTrackColor: Colors.deepOrange[200],
                    activeColor: Colors.deepOrange[700],
                    onChanged: (value){
                      setState(() {
                        widget.privacy = value;
                      });
                    })

                  ),
                )
              ),
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
                            onPressed: () {

                          },
                          child: Text("Save", style: TextStyle(
                                    fontFamily: "Helvetica",
                                    color: Colors.white,
                                    fontSize: 16),),),

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
