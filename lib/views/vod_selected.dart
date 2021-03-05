import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/marquee.dart';
import 'package:tboxapp/models/vod.model.dart';
// import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;
import 'package:tboxapp/views/vod_play.dart';

class VodSelectedScreen extends StatefulWidget {
  final int vodId;

  VodSelectedScreen({Key key, @required this.vodId}) : super(key: key);
  @override
  VodSelectedScreenState createState() => VodSelectedScreenState();
}

class VodSelectedScreenState extends State<VodSelectedScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  int _uid;
  int _urole;

  Future<Vod> futureVod;
  // Vod futureVod;
  var favIconColor;

  @override
  void initState() {
    super.initState();
    futureVod = getFutureVod();
    favIconColor = Colors.grey;
    appService.addVodClick(widget.vodId);
  }

  Future<Vod> getFutureVod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getInt('id') ?? -1;
    _urole = prefs.getInt('role') ?? -1;
    if (_uid != -1) {
      return appService.getVodForUser(widget.vodId, _uid);
    } else {
      return appService.getVod(widget.vodId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<Vod>(
      future: futureVod,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SizedBox.expand(child: Center(child: Text("${snapshot.error}")));
        }
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
            ),
          );
        }
        if (snapshot.data.isFavorite) {
          favIconColor = Colors.yellow;
        } else {
          favIconColor = Colors.grey;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(snapshot.data.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .12,
                  decoration: BoxDecoration(
                    // color: Colors.black26,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black38, Colors.black87], // red to yellow
                      tileMode: TileMode.repeated, // repeats the gradient over the canvas
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MarqueeWidget(
                          direction: Axis.horizontal,
                          child: Text(
                            snapshot.data.title,
                            style: TextStyle(fontSize: FontSize.xLarge.size),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Column(
                                children: <Widget>[Icon(Icons.play_circle_outline), Text("재생")],
                              ),
                              onPressed: () => _handleVodPlay(snapshot.data),
                            ),
                            SizedBox(width: 10),
                            FlatButton(
                              child: Column(
                                children: <Widget>[Icon(Icons.share), Text("공유")],
                              ),
                              onPressed: () => _handleVodShare(snapshot.data),
                            ),
                            SizedBox(width: 10),
                            FlatButton(
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.stars, color: favIconColor),
                                  Text("즐겨찾기"),
                                ],
                              ),
                              onPressed: () => _handleVodFav(snapshot.data),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              snapshot.data.title,
              style: TextStyle(fontSize: FontSize.xLarge.size),
            ),
            SizedBox(height: 10),
            Text(snapshot.data.contents),
            SizedBox(height: 20),
            Text('something then vid list'),
          ],
        );
      },
    );
  }

  _handleVodPlay(Vod snapshotData) {
    if (_uid == -1) {
      FlutterToast.showToast(msg: '로그인 is required.');
      return;
    }
    if (!snapshotData.viewableTo.contains(_urole)) {
      FlutterToast.showToast(msg: '권한 없습니다.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VodPlayScreen(
          uid: _uid,
          myVod: snapshotData,
        ),
      ),
    );
  }

  _handleVodShare(Vod snapshotData) {
    print('공유 clicked');
    // TODO properly implement share
    Share.share('ughh', subject: 'ugh');
  }

  _handleVodFav(Vod snapshotData) async {
    print('즐겨찾기 clicked');
    if (_uid == -1) {
      FlutterToast.showToast(msg: 'You must be logged in to use this function');
    } else {
      print(snapshotData.isFavorite);
      if (snapshotData.isFavorite) {
        var results = await appService.removeVodFromFavorites(widget.vodId, _uid);
        print(results.toString());
        FlutterToast.showToast(msg: 'Removed from favorites');
        setState(() {
          favIconColor = Colors.grey;
        });
        snapshotData.isFavorite = false;
      } else {
        var results = await appService.addVodToFavorites(widget.vodId, _uid);
        print(results.toString());
        FlutterToast.showToast(msg: 'Added to favorites');
        setState(() {
          favIconColor = Colors.yellow;
        });
        snapshotData.isFavorite = true;
      }
    }
  }
}
