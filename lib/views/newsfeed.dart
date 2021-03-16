import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/newsfeed.model.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class NewsfeedScreen extends StatefulWidget {
  @override
  NewsfeedScreenState createState() => NewsfeedScreenState();
}

class NewsfeedScreenState extends State<NewsfeedScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  Future<NewsfeedList> futureNewsfeedList;

  @override
  void initState() {
    super.initState();
    futureNewsfeedList = appService.getAllNewsFeedWoBody();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: buildFullAppBar(context),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Container(
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("공지사항", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(color: Colors.white, thickness: 2),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(flex: 4, child: Text("제목")),
                  Expanded(flex: 1, child: Center(child: Text("조회수"))),
                  Expanded(flex: 1, child: Center(child: Text("등록일"))),
                ],
              ),
              Divider(color: Colors.white),
              FutureBuilder(
                future: futureNewsfeedList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [for (var newsfeed in snapshot.data.newsfeed) _buildNewsfeed(newsfeed)]);
                  } else if (snapshot.hasError) {
                    Fluttertoast.showToast(
                      msg: "Could not retrieve data.",
                      toastLength: Toast.LENGTH_LONG,
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsfeed(Newsfeed newsfeedData) {
    final myDateFormat = new DateFormat('yy.MM.dd');
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/newsfeed_body', arguments: {'myNewsfeed': newsfeedData});
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      newsfeedData.pin
                          ? Image(
                              image: AssetImage('assets/icons/pin.png'),
                              fit: BoxFit.fitWidth,
                              width: 10,
                            )
                          : Container(),
                      newsfeedData.pin ? SizedBox(width: 2) : Container(),
                      Flexible(
                        child: Container(
                          child: Text(
                            newsfeedData.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Align(alignment: Alignment.center, child: Text(newsfeedData.clickCount.toString()))),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(myDateFormat.format(DateTime.parse(newsfeedData.createDate))),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.white),
      ],
    );
  }
}
