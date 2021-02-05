import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class VodSelectedScreen extends StatefulWidget {
  final int vodId;

  VodSelectedScreen({Key key, @required this.vodId}) : super(key: key);
  @override
  VodSelectedScreenState createState() => VodSelectedScreenState();
}

class VodSelectedScreenState extends State<VodSelectedScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  int _uid;

  Future<Vod> futureVod;
  // Vod futureVod;
  var favIconColor;

  @override
  void initState() {
    super.initState();
    futureVod = getFutureVod();
    /*
    futureVod = Vod(
      id: 1,
      title: "wawawawawawawawawawawa",
      contents: 'sfsfsfsfsfsfsf\nsfsfsfsfsf\/sfsfsfsfsfsfsf',
      vod: 'so',
      mrbg: 'so',
      thumbnail: 'https://i1.tbox.media/vodthumbnail/2020/06/19/e5abd59e90144e5bbc2c20e8a3a71427.jpg',
      pcTitle: 'pctitle',
      scTitle: 'sctitle',
      levelId: 1,
      viewableTo: [1, 2, 3],
      usingPoints: true,
      earnablePoints: 1,
      earnableTimes: 1,
      sensingType: 1,
      sensingStartMin: 1,
      sensingStartSec: 1,
      sensingEndMin: 2,
      sensingEndSec: 2,
      pointGoal: 1,
      pointSuccess: 1,
      isFavorite: false,
    );
*/
    favIconColor = Colors.grey;
    // if (futureVod.isFavorite) {
    //   favIconColor = Colors.yellow;
    // } else {
    //   favIconColor = Colors.grey;
    // }
  }

  Future<Vod> getFutureVod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getInt('id') ?? -1;
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
        if (snapshot.hasData) {
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
                          Text(snapshot.data.title, style: TextStyle(fontSize: FontSize.xLarge.size)),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Column(
                                  children: <Widget>[Icon(Icons.play_circle_outline), Text("재생")],
                                ),
                                onPressed: () {
                                  print('재생 clicked');
                                  // TODO implement play button
                                },
                              ),
                              SizedBox(width: 10),
                              FlatButton(
                                child: Column(
                                  children: <Widget>[Icon(Icons.share), Text("공유")],
                                ),
                                onPressed: () {
                                  print('공유 clicked');
                                  // TODO properly implement share
                                  Share.share('ughh', subject: 'ugh');
                                },
                              ),
                              SizedBox(width: 10),
                              FlatButton(
                                child: Column(
                                  children: <Widget>[Icon(Icons.stars, color: favIconColor), Text("즐겨찾기")],
                                ),
                                onPressed: () async {
                                  print('즐겨찾기 clicked');
                                  if (snapshot.data.isFavorite) {
                                    await appService.removeVodFromFavorites(widget.vodId, _uid);
                                    setState(() {
                                      favIconColor = Colors.yellow;
                                    });
                                  } else {
                                    await appService.addVodToFavorites(widget.vodId, _uid);
                                    setState(() {
                                      favIconColor = Colors.grey;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(snapshot.data.title),
              Text(snapshot.data.contents),
              Text('something then vid list'),
            ],
          );
        } else if (snapshot.hasError) {
          return SizedBox.expand(child: Center(child: Text("${snapshot.error}")));
        }

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
          ),
        );
      },
    );
  }
}
