import 'dart:async';
import 'dart:convert';

import 'package:wingame/common/api_service.dart';
import 'package:wingame/common/encrypt_service.dart';
import 'package:wingame/globalvar.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../common/theme_helper.dart';
import '../widgets/appbar.dart';
import 'login_page.dart';
class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  List<dynamic> allchats = [];
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";


  getchatsdata() async {
    setState(() {
      isApiCallProcess = true;
    });
    Map<String, dynamic> map = {
      'user_id': globals.user_id,
      'encryption_key': globals.token,
    };
    APIService apiService = new APIService();
    apiService
        .apicall({"str": encryp(json.encode(map))}, "api_getchats").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      var successcode = int.parse(responseJson["success"].toString());
      if (successcode != 0 && successcode != 3) {
        print(responseJson);
        setState(() {
          isApiCallProcess = false;
          globals.token = responseJson["encryption_key"];
          allchats = responseJson["message"];
          //Future.delayed(
          //     Duration(milliseconds: 200),
          //         () {
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 750), curve: Curves.easeOut);
                 // });
        });
        //print(allchats);
      } else if (successcode == 3) {
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        var snackBar = SnackBar(
          content: Text(responseJson["message"]),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getchatsdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(globals.color_background),
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: Appbar()),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                height: 600,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: allchats.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                      return ChatBubble(
                        text: allchats[index]['message'],
                        isCurrentUser: (allchats[index]['sender_id']==globals.user_id) ? true : false,
                        type: allchats[index]['type'],
                        timestamp: allchats[index]['timestamp'],
                        readstatus: allchats[index]['readstatus'],
                      );
                  }

                ),
              ),
              addmessage(),
              Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
            ],
          ),
        )
      ),

    );
  }
  openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery,maxWidth: 640,maxHeight: 480,imageQuality: 60);
      //you can use ImageCourse.camera for Camera capture
      if(pickedFile != null){
        setState(() {
          imagepath = pickedFile.path;
        });

        //print(imagepath);
        //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

        final imagebytes = await pickedFile.readAsBytes(); //convert to bytes
        String base64string = base64.encode(imagebytes); //convert bytes to base64 string
        //print(base64string);
        Map<String, dynamic> map = {
          'user_id': globals.user_id,
          'encryption_key': globals.token,
          'message':base64string,
          'type':'img',
        };
        APIService apiService = new APIService();
        apiService
            .apicall({"str": encryp(json.encode(map))},
            "api_send_message")
            .then((value) {
          Map<String, dynamic> responseJson =
          json.decode(value);
          var successcode = int.parse(
              responseJson["success"].toString());
          if (successcode != 0 &&
              successcode != 3) {
            setState(() {
              isApiCallProcess = false;
            });
            globals.token =
            responseJson["encryption_key"];
            getchatsdata();
            // Future.delayed(
            //     Duration(milliseconds: 200),
            //         () {
                  _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 750), curve: Curves.easeOut);
                //});
            controller.clear();

          } else if (successcode == 3) {
            setState(() {
              isApiCallProcess = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage()),
            );
          } else {
            setState(() {
              isApiCallProcess = false;
            });
            var snackBar = SnackBar(
              content: Container(
                  height: 120,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      Text(
                        "Uh-Oh ",
                        style: TextStyle(
                            color: HexColor("#FFFFFF"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        responseJson["message"],
                        style: TextStyle(
                            color: HexColor("#FFFFFF"),
                            fontSize: 18),
                      ),
                    ],

                  )
              ),
              backgroundColor: Colors.grey[100],
            );
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBar);
          }
        });
      }else{
        //print("No image is selected.");
      }
    }catch (e) {
      //print("error while picking file.");
    }
  }
  addmessage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black38,

      ),
      child: SizedBox(height: 60,
        child: Row(
          children: [
            SizedBox(width: 50,
              child: InkWell(
                child: Icon(Icons.camera_alt,color: Colors.white,),
                onTap: () async {
                  openImage();
                  /*setState(() {
                    isApiCallProcess = true;
                  });
                  Map<String, dynamic> map = {
                    'user_id': globals.user_id,
                    'encryption_key': globals.token,
                    'message':base64Image,
                    'type':'img',
                  };
                  APIService apiService = new APIService();
                  apiService
                      .apicall({"str": encryp(json.encode(map))},
                      "api_send_message")
                      .then((value) {
                    Map<String, dynamic> responseJson =
                    json.decode(value);
                    var successcode = int.parse(
                        responseJson["success"].toString());
                    if (successcode != 0 &&
                        successcode != 3) {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      globals.token =
                      responseJson["encryption_key"];
                      getchatsdata();
                      Future.delayed(
                          Duration(milliseconds: 200),
                              () {
                            _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 750), curve: Curves.easeOut);
                          });
                      controller.clear();

                    } else if (successcode == 3) {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage()),
                      );
                    } else {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      var snackBar = SnackBar(
                        content: Container(
                            height: 120,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                              children: [
                                Text(
                                  "Uh-Oh ",
                                  style: TextStyle(
                                      color: HexColor("#FFFFFF"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text(
                                  responseJson["message"],
                                  style: TextStyle(
                                      color: HexColor("#FFFFFF"),
                                      fontSize: 18),
                                ),
                              ],

                            )
                        ),
                        backgroundColor: Colors.grey[100],
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }
                  });*/
                },
              ),
            ),
            Form(
              key: _formKey,
                child: SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: controller,
                    decoration: ThemeHelper().textInputDecoration(
                        'Message',
                        'Enter Message To Send'),
                    validator: (input) => input!.length < 1
                        ? "Enter Message"
                        : null,
                  ),
                )
            ),
            SizedBox(width: 50,
              child: InkWell(
                child: Icon(Icons.send,color: Colors.white),
                onTap: (){
                    if (validateAndSave())
                    {
                      setState(() {
                        isApiCallProcess = true;
                      });
                      Map<String, dynamic> map = {
                        'user_id': globals.user_id,
                        'encryption_key': globals.token,
                        'message':controller.text,
                        'type':'text',
                      };
                      controller.text = "";
                      controller.clear();
                      APIService apiService = new APIService();
                      apiService
                          .apicall({"str": encryp(json.encode(map))},
                          "api_send_message")
                          .then((value) {
                        Map<String, dynamic> responseJson =
                        json.decode(value);
                        print(responseJson);
                        var successcode = int.parse(
                            responseJson["success"].toString());
                        if (successcode != 0 &&
                            successcode != 3) {
                          setState(() {
                            isApiCallProcess = false;
                          });
                          globals.token =
                          responseJson["encryption_key"];


                          getchatsdata();
                          // Future.delayed(
                          //     Duration(milliseconds: 100),
                          //         () {
                           //     _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 50), curve: Curves.easeOut);
                             // });
                        } else if (successcode == 3) {
                          setState(() {
                            isApiCallProcess = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage()),
                          );
                        } else {
                          setState(() {
                            isApiCallProcess = false;
                          });
                          var snackBar = SnackBar(
                            content: Container(
                                height: 120,
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Uh-Oh ",
                                      style: TextStyle(
                                          color: HexColor("#861F41"),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Text(
                                      responseJson["message"],
                                      style: TextStyle(
                                          color: HexColor("#861F41"),
                                          fontSize: 18),
                                    ),
                                  ],

                                )
                            ),
                            backgroundColor: Colors.grey[100],
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                        }
                      });
                    }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
    required this.type,
    required this.timestamp,
    required this.readstatus,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;
  final String type;
  final String timestamp;
  final String readstatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                (type!="img") ? Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: isCurrentUser ? Colors.white : Colors.black87),
                  textAlign: TextAlign.right,
                ) : Image.network(text),
                SizedBox(height: 5,),
                Text(timestamp,style: TextStyle(fontSize: 9,color: Colors.black38),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}