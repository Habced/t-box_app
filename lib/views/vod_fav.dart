import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/marquee.dart';
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
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
                  ),
                );
              }

              return Column(
                children: snapshot.data
                    .asMap()
                    .map((i, VodShort vod) {
                      if (vod.isFavorite == null) {
                        vod.isFavorite = true;
                      }
                      var iconColor = Colors.grey;
                      if (vod.isLoading == null) {
                        vod.isLoading = false;
                      }
                      if (vod.isFavorite) {
                        iconColor = MyPrimaryYellowColor;
                      }
                      var vodRow = Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(vod.thumbnail, fit: BoxFit.fitHeight, height: 160, width: 110),
                          Container(
                            height: 160,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 150,
                                  child: Center(
                                    child: Text(vod.title, overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Text(
                                  DateFormat('yy.MM.dd').format(DateTime.parse(vod.timestamp)),
                                  style: TextStyle(color: Colors.grey[350]),
                                ),
                              ],
                            ),
                          ),
                          vod.isLoading
                              ? CircularProgressIndicator()
                              : FlatButton(
                                  child: Icon(Icons.stars, color: iconColor),
                                  onPressed: _handleVodFav(snapshot.data[i]),
                                )
                        ],
                      );
                      return MapEntry(
                        i,
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            child: vodRow,
                            onTap: () {
                              print('clicked on vod: ' + vod.title);
                            },
                          ),
                        ),
                      );
                    })
                    .values
                    .toList(),
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
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
                  ),
                );
              }

              return Column(
                children: snapshot.data
                    .asMap()
                    .map((i, VodShort vod) {
                      var iconColor = Colors.grey;
                      if (vod.isLoading == null) {
                        vod.isLoading = false;
                      }
                      if (vod.isFavorite) {
                        iconColor = MyPrimaryYellowColor;
                      }
                      var vodRow = Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(vod.thumbnail, fit: BoxFit.fitHeight, height: 160, width: 110),
                          Column(
                            children: [
                              Container(
                                width: 150,
                                child: Center(
                                  child: Text(vod.title, overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Text(
                                DateFormat('yy.MM.dd').format(DateTime.parse(vod.timestamp)),
                                style: TextStyle(color: Colors.grey[350]),
                              ),
                            ],
                          ),
                          FlatButton(
                            child: Column(
                              children: <Widget>[Icon(Icons.share), Text("공유")],
                            ),
                            onPressed: () => _handleVodShare(vod),
                          ),
                          vod.isLoading
                              ? CircularProgressIndicator()
                              : FlatButton(
                                  child: Icon(Icons.stars, color: iconColor),
                                  onPressed: _handleVodFav(snapshot.data[i]),
                                ),
                        ],
                      );
                      return MapEntry(
                        i,
                        Padding(padding: EdgeInsets.all(10), child: InkWell(child: vodRow)),
                      );
                    })
                    .values
                    .toList(),
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
            indicatorColor: MyPrimaryYellowColor,
            labelColor: MyPrimaryYellowColor,
            unselectedLabelColor: Colors.grey,
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

  _handleVodShare(VodShort snapshotData) {
    print('공유 clicked');
    // TODO properly implement share
    Share.share('ughh', subject: 'ugh');
  }

  _handleVodFav(VodShort snapshotData) async {
    print('즐겨찾기 clicked');
    setState(() {
      snapshotData.isLoading = true;
    });
    if (snapshotData.isFavorite) {
      var results = await appService.removeVodFromFavorites(snapshotData.id, _uid);
      FlutterToast.showToast(msg: 'Removed from favorites');
      setState(() {
        snapshotData.isFavorite = false;
        snapshotData.isLoading = false;
      });
    } else {
      var results = await appService.addVodToFavorites(snapshotData.id, _uid);
      FlutterToast.showToast(msg: 'Added to favorites');
      setState(() {
        snapshotData.isFavorite = true;
        snapshotData.isLoading = false;
      });
    }
  }
}
