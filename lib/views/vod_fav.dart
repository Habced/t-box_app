import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class VodFavScreen extends StatefulWidget {
  @override
  VodFavScreenState createState() => VodFavScreenState();
}

class VodFavScreenState extends State<VodFavScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  TabController _tabController;

  int _uid;

  Future<List<VodShort>> futureVodFavList;
  Future<List<VodShort>> futureVodWatchedList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    getVodLists();
  }

  getVodLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getInt('id') ?? -1;
    if (_uid != -1) {
      futureVodFavList = appService.getVodInFavorites(_uid);
      futureVodWatchedList = appService.getPlayedVods(_uid);
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Not Logged In'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Your must be logged in to have access to this page'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ).whenComplete(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: buildFullAppBar(context),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var favTab = Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('즐겨찾기 한 동영상'),
          Divider(color: Colors.white, thickness: 2),
          FutureBuilder<List<VodShort>>(
            future: futureVodFavList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.map((VodShort vod) {
                    var vodRow = Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(vod.thumbnail, fit: BoxFit.fitHeight, height: 160, width: 110),
                        Column(
                          children: [
                            Text(vod.title),
                            Text(vod.timestamp),
                          ],
                        ),
                        Text("icon?"),
                      ],
                    );
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: InkWell(child: vodRow),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
                ),
              );
            },
          ),
        ],
      ),
    );
    var watchedTab = Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('최근 시청 한 동영상'),
          Divider(color: Colors.white, thickness: 2),
          FutureBuilder<List<VodShort>>(
            future: futureVodWatchedList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.map((VodShort vod) {
                    var vodRow = Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(vod.thumbnail, fit: BoxFit.fitHeight, height: 160, width: 110),
                        Column(
                          children: [
                            Text(vod.title),
                            Text(vod.timestamp),
                          ],
                        ),
                        Text("icon?"),
                      ],
                    );
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: InkWell(child: vodRow),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
                ),
              );
            },
          ),
        ],
      ),
    );

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "즐겨찾기"),
              Tab(text: "최근 시청"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(child: favTab),
                SingleChildScrollView(child: watchedTab),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
