import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mmatka/c_dashboard_screen/presentation/chartdeatil.dart';
import 'package:mmatka/c_dashboard_screen/presentation/live%20_result.dart';
import 'package:mmatka/utils/core/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Album {
  String id;
  String market_name;
  String market_result;
  String batting_openingtime;
  String batting_close_time;
  String result;
  String format;
  String date;
  String month;
  String year;




  Album(this.id,this.market_name,this.market_result,
      this.batting_openingtime,this.batting_close_time,this.result,this.format,this.date,this.month,this.year
      );

}
Future<List<Album>> bow() async{
  final response = await http.get(
    Uri.parse(Apiconst.baseurl+'allgame'),

  );
  var jsond = json.decode(response.body)["country"];
  print(jsond);
  List<Album> allround = [];
  for (var o in jsond)  {
    Album al = Album(
      o["id"],
      o["market_name"],
      o["market_result"],
      o["batting_openingtime"],
      o["batting_close_time"],
      o["result"],
      o["format"],
      o["date"],
      o["month"],
      o["year"],

    );

    allround.add(al);
  }
  return allround;
}

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with RestorationMixin {
  Future ?reportList;
  @override
  String? get restorationId => widget.restorationId;
  @override
  void initState() {

    reportList = resu();
    // final _futureAlbum = resu(d:17,m:8,y:2022);
    // TODO: implement initState
    super.initState();
  }




  final RestorableDateTime _selectedDate =
  RestorableDateTime( DateTime.now(),);
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  Key _refreshKey = UniqueKey();

  void onRefresh() => setState((){
    _refreshKey = UniqueKey();
  });


  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(

          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate:DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
        );
      },
    );
  }
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }
  var d;
  var m;
  var y;
  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null)  {
      setState(()async
      {
        _selectedDate.value = newSelectedDate;
        final d=_selectedDate.value.day;
        final m=_selectedDate.value.month;
        final y=_selectedDate.value.year;
        resu();
        final prefs1 = await SharedPreferences
            .getInstance();
        final key1 = 'd';
        final mobile = d;
        prefs1.setInt(key1, mobile);

        final prefs = await SharedPreferences
            .getInstance();
        final key = 'm';
        final mobi = m;
        prefs.setInt(key, mobi);

        final pref = await SharedPreferences
            .getInstance();
        final ky = 'y';
        final mob = y;
        pref.setInt(ky, mob);


        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}',
            style: TextStyle(color: Colors.black),),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(


      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.bar_chart),
          title: const Text('Charts'),
        ),
        body:
        Column(
          children: [

            Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                children: [
                  Text('Select Date to see the winners'),
                  Spacer(),
                  IconButton(onPressed: (){
                    setState(() {
                      reportList = resu();
                    });
                  }, icon: Icon(Icons.replay_circle_filled)),
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstant.secondaryColor,
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _restorableDatePickerRouteFuture.present();
                      }, icon: Icon(Icons.calendar_month),

                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Albumd>>(
                future: resu(),
                // future: bow(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot.data!.length);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: AppConstant.secondaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: CircleAvatar(
                                    backgroundColor: AppConstant.primaryColor,
                                    radius: 25.r,
                                    child: CircleAvatar(
                                      backgroundColor: AppConstant.secondaryColor,
                                      radius: 20.r,
                                      child: Icon(
                                        Icons.apartment_rounded,
                                        color: AppConstant.titlecolor,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${snapshot.data![index].gamename}',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline4,
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 120),
                                      child: Text(
                                        'Winner Number',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                          color: AppConstant.subtitlecolor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${snapshot.data![index].date}',
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                              color: AppConstant.subtitlecolor,
                                            ),
                                          ),
                                          Text("|",style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                            color: AppConstant.subtitlecolor,
                                          ),),
                                          Text(
                                            '${snapshot.data![index].month}',
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                              color: AppConstant.subtitlecolor,
                                            ),
                                          ),
                                          Text("|",style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                            color: AppConstant.subtitlecolor,
                                          ),),
                                          Text(
                                            '${snapshot.data![index].year}',
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                              color: AppConstant.subtitlecolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    color: AppConstant.primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      bottomLeft: Radius.circular(8.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    child: Text(

                                      '${snapshot.data![index].result}',
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                        color: AppConstant.backgroundColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ):LiveResult();
                }
            ),
          ],
        ),
      ),
    );
  }
  Future<List<Albumd>> resu() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final d = prefs.getInt('d')??01;
    SharedPreferences prefs1 = await SharedPreferences.getInstance();

    final m = prefs1.getInt('m')?? 01;
    SharedPreferences prefs2 = await SharedPreferences.getInstance();

    final y = prefs2.getInt('y')??2022;
    print( d);
    print( m);
    print( y);
    print('aaaaaaaaaaaaaaaeeeeeeeeeeeeaaaaaaaaaaaaa');
    final response = await http.post(
        Uri.parse(Apiconst.baseurl+'year'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "year":"$y",
          "date":"$d",
          "month":"$m"
        })
    );
    var jsond = json.decode(response.body)["country"];

    List<Albumd> allround = [];
    for (var o in jsond)  {
      Albumd al = Albumd(
        o["id"],
        o["gamename"],
        o["time"],
        o["date"],
        o["year"],
        o["month"],
        o["result"],
      );

      allround.add(al);
    }

    print('aaaaaaaaaaaaaaaeeeeeeeeeeeeaaaaaaaaaaaaa');
    return allround;
  }

}
class Albumd {
  String ?id;
  String ?gamename;
  String ?time;
  String? date;
  String ?year;
  String ?month;
  String ?result;
  Albumd(this.id,this.gamename,this.time,
      this.date,this.year,this.month,this.result,
      );

}
