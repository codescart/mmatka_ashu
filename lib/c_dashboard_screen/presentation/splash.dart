import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mmatka/b_authentication_screen/presentation/welcome_screen.dart';
import 'package:mmatka/b_authentication_screen/widgets/welcome_tag.dart';
import 'package:mmatka/c_dashboard_screen/presentation/_main_dashboard_screen.dart';
import 'package:mmatka/c_dashboard_screen/presentation/a_home_screen.dart';
import 'package:mmatka/utils/core/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../b_authentication_screen/widgets/custom_button.dart';

class SplashScreen extends StatefulWidget {
  String? email;
  SplashScreen({Key? key,  this.email}) : super(key: key);  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds:5),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>  widget.email == null ? WelcomeScreen() : Popup())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppConstant.backgroundColor,
      body:Column(
        children: [
          SizedBox(height: 200,),
          Center(
            child: Container(
               height: 300,width: 320,
              child:Image.asset("assets/images/splash (2).gif",
              ),
            ),
          ),
          SizedBox(height: 50,),
          Text('Welcome to',style: TextStyle(fontSize: 25,color: Colors.black),),
          Text('M-Matka',style: TextStyle(fontSize: 30,color: Colors.black),)
        ],
      ),
    );
  }
}

class Popup extends StatefulWidget {
  const Popup({Key? key}) : super(key: key);

  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {


  @override
  void initState() {
    leader();
    versioncheck();
    // TODO: implement initState
    super.initState();
  }
  var mapl;
  var map;
  bool raja=false;

  Future versioncheck() async{
    final response = await http.post(
      Uri.parse(Apiconst.baseurl+'version'),
    );
    var data = jsonDecode(response.body)['country'];

    if (data[0]['version']!= Apiconst.versioncode) {
      print("jsi ho");
      setState(() {
        raja=true;


      });
    }else{
      print("Bhag yha se");
    }
  }



  Future leader() async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final value = prefs.getString(key) ?? "0";
    final response = await http.post(
      Uri.parse(Apiconst.baseurl+'userpro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id":"$value"
      }),
    );
    var data = jsonDecode(response.body);
    print(data);
    if (data['error'] == '200') {
      setState(() {
        map=json.decode(response.body)['country'];


      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1),() => showAlert(context));

    return Container(
    child: HomeScreen(),
    );
  }
  void showAlert(BuildContext context) {

    showDialog(
        context: context,
        builder: (context) =>
        raja==false?
            AlertDialog(
          content: Container(
            height: 300,
            child: Column(
              children: [
                Text(map == null?
                'Your Name' : map['name'].toString(),
                  style: Theme.of(context).textTheme.headline4,),
                SizedBox(height: 15,),
                Text("जरुरी सुचना"),
                SizedBox(height: 15,),
                Text("सभी कस्टमर पेमेंट ऐड कर सकते है और अपना कैश विड्रा (withdrawal) कर सकते हैं"),
                SizedBox(height: 25,),
                Text("********************************************"),
                Text("जरुरी सुचना"),
                SizedBox(height: 15,),
                Text(" अगर  आपको M-Matka  गेम खेलेंगे तो कैश विड्रा करने में कोई समस्या है तो आप नीचे दिए गए हेल्पलाइन नंबर पर कॉल करे"),
                SizedBox(height: 15,),

                TextButton(onPressed:(){
                  _launchCaller();
                }, child: Text("+918930993911",style: TextStyle(color: AppConstant.primaryColor),)
                ),
              ],
            ),
          ),
          actions: [
            CustomButton(
              text: 'CLOSE',
              textColor: AppConstant.backgroundColor,
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainDashboardScreen()));
              },
            ),
          ],
        ):AlertDialog(
          content: Container(
            child: Row(
              children: [
                Container(
                  width: 40,height: 40,
                  child: Image(image:AssetImage("assets/images/dmatka1.png") ),
                ),
                SizedBox(width: 20,),
                Text('new version are avilable'),
              ],
            ),

          ),
          actions: [
            CustomButton(
              text: 'UPDATE',
              onTap: () {
                _launchURL();
              },
            ),
          ],
        )

    );
  }
  _launchCaller() async {
    const url = "tel:+918930993911";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
_launchURL() async {
  const url = 'https://mmatka.com/mmatkaupdated.apk';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}