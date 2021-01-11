import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

void main() {
  runApp(MaterialApp(home: ContactPage(), debugShowCheckedModeBanner: false,));
}

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Using SnackBar"),
      ),
      body: Center(
        child: MyButton(),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController _outputController;
  @override
  initState() {
    super.initState();
    this._outputController = new TextEditingController();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            left: 25,
            top: 60,
            right: 25,
                      child: RaisedButton(
              child: Text('Show SnackBar'),
              // On pressing the raised button
              onPressed: () {
                // show snackbar
                Scaffold.of(context).showSnackBar(SnackBar(
                      // set content of snackbar
                      content: Text("Hello! I am SnackBar :)"),
                      // set duration
                      duration: Duration(seconds: 3),
                      // set the action
                      action: SnackBarAction(
                          label: "Hit Me (Action)",
                          onPressed: () {
                            // When action button is pressed, show another snackbar
                            Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Hello! I am shown becoz you pressed Action :)"),
                                ));
                          }),
                    ));
              },
            ),
          ),
          //---------------------------- My Code ----------------------------------------
          Positioned(
            left: 25,
            top: 120,
            right: 25,
            child: Container(
              height: 100,
              width: 180,
              child: RaisedButton(
                child: Row(
                  children: [
                    Expanded(flex:1,child: Image.asset('images/scanner.png')),
                    Expanded(flex:1,child: Text('Qr scan'))
                  ],
                ),
                onPressed: _scan,),
            )
          ),
          
          this._outputController.text != null ?Positioned(
              left: 10,
            bottom: 100,
            right: 10,
                          child: TextField(
                          controller: this._outputController,
                          maxLines: 2,
                          decoration: InputDecoration( 
                            prefixIcon: Icon(Icons.wrap_text),
                            // suffixIcon: _getFAB(),
                            suffixIcon :  InkWell(
                              child: CircleAvatar(
                                child: Icon(Icons.share_rounded),
                              ),
                              onTap: () async{
                  SocialShare.shareWhatsapp(
                              "Qr-code:" + this._outputController.text)
                          .then((data) {
                        print(data);
                      });
                },
                            ),
                            helperText:
                                'The barcode or qrcode you scan will be displayed in this area.',
                            hintText:
                                'The barcode or qrcode you scan will be displayed in this area.',
                            hintStyle: TextStyle(fontSize: 15),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                          ),
                        ),
            ):Container(),  
            
            
        ],
      ),
      
    );
  }
  Widget _getFAB() {
        return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Color(0xFF801E48),
          visible: true,
          curve: Curves.bounceIn,
          children: [
                // FAB 1
                SpeedDialChild(
                child: CircleAvatar(
                child: FaIcon(FontAwesomeIcons.tshirt, color: Colors.white,), // Icon widget changed with FaIcon
                radius: 60.0,
                backgroundColor: Colors.cyan),
                backgroundColor: Color(0xFF801E48),
                onTap: () async{
                  SocialShare.shareWhatsapp(
                              "Qr-code:" + this._outputController.toString())
                          .then((data) {
                        print(data);
                      });
                },
                label: 'Whats App',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFF801E48)),
                // FAB 2
                SpeedDialChild(
                child: Icon(Icons.assignment_turned_in),
                backgroundColor: Color(0xFF801E48),
                onTap: () async{
                  SocialShare.shareTwitter(
                              "This is Social Share twitter example",
                              hashtags: ["hello", "world", "foo", "bar"],
                              trailingText: "Qr-code:" + this._outputController.toString())
                          .then((data) {
                        print(data);
                      });
                },
                label: 'Twitter ',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFF801E48))
          ],
        );
  }
  Future _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      this._outputController.text = barcode;
    }
  }
}