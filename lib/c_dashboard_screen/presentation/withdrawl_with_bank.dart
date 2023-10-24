import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mmatka/b_authentication_screen/widgets/custom_button.dart';
import 'package:mmatka/c_dashboard_screen/presentation/action_bar/withdraw_hisrory.dart';
import 'package:mmatka/utils/core/app_constant.dart';
import 'package:mmatka/utils/core/widgets/back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Withdrawbank extends StatefulWidget {
  const Withdrawbank({Key? key}) : super(key: key);

  @override
  State<Withdrawbank> createState() => _WithdrawbankState();
}





class _WithdrawbankState extends State<Withdrawbank> {
  final amoount = TextEditingController();
  final reenter = TextEditingController();
  final enter = TextEditingController();
  final ifsc = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();



  Future leader(String amoount, String enter,String reenter,String ifsc,String name,String phone) async{

    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final value = prefs.getString(key) ?? "0";

    final response = await http.post(
      Uri.parse(Apiconst.baseurl+'bank_withdrawl'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{

        "user_id": "$value",
        "amount": amoount,
        "Ac_number": enter,
        "ReAc_number":reenter,
        "ifsc_code":ifsc,
        "name":name,
        "phone":phone,
      }),
    );
    var data = jsonDecode(response.body);
    print(data);
    if (data['error'] == '200') {
      Fluttertoast.showToast(
          msg: "After Withdraw Request your payment will reach in your bank Account in 30 minutes",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }else{
      Fluttertoast.showToast(
          msg: data['msg'] ,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstant.secondaryColor,
        appBar: AppBar(
          leading:CustomBackButton(),
          title: Text("Withdraw Cash via Bank"),
        ),
        body:SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  // width: width,
                  // height: 120.h,
                  decoration: BoxDecoration(
                    color: AppConstant.secondaryColor,
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enter Amount',
                            style:
                            Theme.of(context).textTheme.headline2!.copyWith(
                              color: AppConstant.subtitlecolor,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: 100,
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 40,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:AppConstant.secondaryColor,
                                  ),
                                ),
                                hintText: "00",),
                              controller: amoount,
                            ),
                          ),
                          SizedBox( height: 40,),
                          Container(
                            height: 30,width: 200,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6.sp),
                            ),
                            child: Center(child: Text("100% safe & Secure")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Enter Bank Account Number"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50, width: 320,
                  decoration: BoxDecoration(
                    color: AppConstant.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please enter Account Number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppConstant.secondaryColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 2,
                          )),

                      prefixIcon: Icon(
                        Icons.import_contacts, size: 16,
                        color: AppConstant.titlecolor,
                      ),
                      hintText: "Enter Your Bank Account Number",
                    ),


                    controller: enter,

                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Re-E nter Bank Account Number"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50, width: 320,
                  decoration: BoxDecoration(
                    color: AppConstant.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please re-enter Account Number';
                      }
                      print(enter.text);
                      print(reenter.text);
                      if(enter.text!=reenter.text){
                        return "Account Number does not match";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppConstant.secondaryColor,
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 2,
                          )),

                      prefixIcon: Icon(
                        Icons.import_contacts, size: 16,
                        color: AppConstant.titlecolor,
                      ),
                      hintText: "Re-Enter Your Bank Account Number",
                    ),


                    controller: reenter,

                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Enter IFSC Code"),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50, width: 320,
                  decoration: BoxDecoration(
                    color: AppConstant.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) return;

                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppConstant.secondaryColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 2,
                          )),

                      prefixIcon: Icon(
                        Icons.import_contacts, size: 16,
                        color: AppConstant.titlecolor,
                      ),
                      hintText: "Enter Your IFSC Code",
                    ),


                    controller:ifsc,

                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Enter Account Holder Name"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50, width: 320,
                  decoration: BoxDecoration(
                    color: AppConstant.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return;

                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppConstant.secondaryColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 2,
                          )),


                      prefixIcon: Icon(
                        Icons.import_contacts, size: 16,
                        color: AppConstant.titlecolor,
                      ),
                      hintText: "Enter Your Account Holder Name",
                    ),
                    controller: name,

                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Enter Phone Number"),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50, width: 320,
                  decoration: BoxDecoration(
                    color: AppConstant.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return;

                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppConstant.secondaryColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 2,
                          )),

                      prefixIcon: Icon(
                        Icons.import_contacts, size: 16,
                        color: AppConstant.titlecolor,
                      ),
                      hintText: "Enter Your Phone Number",
                    ),


                    controller: phone,

                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: ButtonTheme(
                        height: 40,
                        minWidth: 150,
                        child: ElevatedButton(
                          // color:AppConstant.primaryColor,
                          child: Text("WITHDRAW CASH", style: TextStyle(color: AppConstant.backgroundColor),),
                          onPressed: () {
                            if(formkey.currentState!.validate()) {
                              leader(amoount.text, enter.text, reenter.text,
                                  ifsc.text, name.text, phone.text);
                              return;
                            }else{

                            }
                          },
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,width: 150,
                      child: CustomButton(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WithdrawHistory()));
                        },
                        text: ' HISTORY ',
                        textColor: AppConstant.titlecolor,
                        btnColor: AppConstant.backgroundColor,
                        border: Border.all(
                          color: AppConstant.titlecolor,
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),

              ],
            ),
          ),
        )
    );
  }
}
