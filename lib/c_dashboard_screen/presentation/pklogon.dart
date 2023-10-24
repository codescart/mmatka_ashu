import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mmatka/b_authentication_screen/presentation/signup_screen.dart';
import 'package:mmatka/b_authentication_screen/widgets/welcome_tag.dart';
import 'package:mmatka/c_dashboard_screen/presentation/_main_dashboard_screen.dart';
import 'package:mmatka/utils/core/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:flutter/material.dart';


class OTPScreens extends StatefulWidget {
  final String phone;
  final String id;
  OTPScreens({required this.phone,required this.id});




  @override
  _OTPScreensState createState() => _OTPScreensState();
}

class _OTPScreensState extends State<OTPScreens> {
  int _otpCodeLength = 6;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = new TextEditingController(text: "");
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;


  @override
  void initState() {
    super.initState();
    super.initState();
    _verifyPhone();
    _getSignatureCode();
    _startListeningSms();
  }

  @override
  void dispose() {
    super.dispose();
    SmsVerification.stopListening();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  /// get signature code
  _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  /// listen sms
  _startListeningSms()  {
    print("lllllllllll");
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        _otpCode = SmsVerification.getCode(message, intRegex);
        textEditingController.text = _otpCode;
        _onOtpCallBack(_otpCode, true);
      });
    });
  }

  _onSubmitOtp()async {
    setState(() {
      _isLoadingButton = !_isLoadingButton;
      _verifyOtpCode();
    });
  }

  _onClickRetry() {
    _startListeningSms();
  }

  _onOtpCallBack(String otpCode, bool isAutofill)async {

    setState(() {
      this._otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _enableButton = false;
        _isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _enableButton = true;
        _isLoadingButton = false;
      } else {
        _enableButton = false;
      }
    });
  }

  _verifyOtpCode() async{

    FocusScope.of(context).requestFocus(new FocusNode());
    Timer(Duration(milliseconds: 4000), () async{
      setState(() {
        _isLoadingButton = false;
        _enableButton = false;
      });

      try {
        await FirebaseAuth.instance
            .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: _verificationCode!, smsCode: _otpCode))
            .then((value) async {
          if (value.user != null) {
            final prefs1 = await SharedPreferences
                .getInstance();
            final key1 = 'user_id';
            final mobile = widget.id ;
            prefs1.setString(key1, mobile);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainDashboardScreen()),
                    (route) => false);
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    const Center(
                      child: WelcomeTag(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldPin(
                        textController: textEditingController,
                        autoFocus: true,
                        codeLength: _otpCodeLength,
                        alignment: MainAxisAlignment.center,
                        defaultBoxSize: 40.0,
                        margin: 5,
                       selectedBoxSize: 40.0,
                        textStyle: TextStyle(fontSize: 16),
                        defaultDecoration: _pinPutDecoration.copyWith(
                            border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6))),
                        selectedDecoration: _pinPutDecoration,
                        onChange: (code) {
                          _onOtpCallBack(code,false);
                        }),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: MaterialButton(
                        onPressed: _enableButton ? _onSubmitOtp : null,
                        child: _setUpButtonChild(),
                        color: AppConstant.primaryColor,
                        disabledColor: Color(0xffccab61),
                      ),
                    ),
                    // Container(
                    //   width: double.maxFinite,
                    //   child: TextButton(
                    //     onPressed: _onClickRetry,
                    //     child: Text(
                    //       "Retry",
                    //       style: TextStyle(color: Colors.orange),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  _verifyPhone() async {

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('+91${widget.phone}');
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              final prefs1 = await SharedPreferences
                  .getInstance();
              final key1 = 'user_id';
              final mobile = widget.id ;
              prefs1.setString(key1, mobile);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainDashboardScreen()),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));

  }

  Widget _setUpButtonChild() {
    if (_isLoadingButton) {
      return Container(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Text(
        "Verify",
        style: TextStyle(color: Colors.white),
      );
    }
  }
}
