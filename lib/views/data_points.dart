import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/models/user_points.model.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class DataPointsScreen extends StatefulWidget {
  @override
  DataPointsScreenState createState() => DataPointsScreenState();
}

class DataPointsScreenState extends State<DataPointsScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  int _uid;

  Future<UserPointsList> futureUserPointsList;

  @override
  void initState() {
    super.initState();
    //TODO implement get data
    futureUserPointsList = getPointData();
  }

  Future<UserPointsList> getPointData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getInt('id') ?? -1;
    return appService.getPointsUsageByUser(_uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    if (_uid == -1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Not logged in'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Would you like to login?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<UserPointsList>(
      future: futureUserPointsList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          FlutterToast.showToast(
            msg: "Could not retrieve data.",
            toastLength: Toast.LENGTH_LONG,
          );
          return Text('${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(height: 10), Text('Loading...')],
            ),
          );
        }
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('보유 포인트'),
              Text(snapshot.data.totalPoints.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          for (var ups in snapshot.data.userPoints) _buildPointUsage(ups),
        ]);
      },
    );
  }

  Widget _buildPointUsage(UserPoints up) {
    final mdf = new DateFormat('yy.MM.dd');
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    mdf.format(DateTime.parse(up.createDate)),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(up.label, overflow: TextOverflow.ellipsis)),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    mdf.format(DateTime.parse(up.amount)) + 'P',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.white),
      ],
    );
  }
}
