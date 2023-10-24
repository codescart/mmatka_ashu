import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mmatka/c_dashboard_screen/presentation/splash.dart';
import 'package:mmatka/utils/core/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('user_id');
  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {
  String? email;
   MyApp({Key? key,  this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: child,
        );
      },
      child:SplashScreen(email:email)
    );
  }
}

