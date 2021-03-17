import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/end_drawer.dart';
import 'package:tboxapp/components/marquee.dart';
import 'package:tboxapp/models/screen_data.model.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/views/ble_devices.dart';
import 'package:tboxapp/services/app_service.dart' as appService;
import 'package:tboxapp/views/data_points.dart';
import 'package:tboxapp/views/vod_cate_list.dart';
import 'package:tboxapp/views/vod_play.dart';
import 'package:tboxapp/views/vod_selected.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  int _uid;
  int _urole;

  String unreadNewsfeeds;
  List<Vod> latestVods;
  bool isRecentVodsLoading = true;

  Future<dynamic> futureBannerList;
  bool isBannersLoading = true;
  Future<FrontPageData> fpd;

  Vod displayedVod;
  var favIconColor;

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    // _checkPrefs();
    _getTotalUnread();
    fpd = _getFpd();
    favIconColor = Colors.grey;
    // TODO check if user is logged in and if userrole was updated
  }

  // _checkPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _uid = prefs.getInt('id') ?? -1;
  //   _urole = prefs.getInt('role') ?? -1;
  // }

  _getTotalUnread() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var result = await tbService.getTotalUnreadNewsfeed(prefs.getInt('id'));
    // unreadNewsfeeds = result['total_unread'].toString();
    // debugPrint(unreadNewsfeeds);
    // setState(() {});
  }

  Future<FrontPageData> _getFpd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getInt('id') ?? -1;
    _urole = prefs.getInt('role') ?? -1;
    if (_uid == -1) {
      return await appService.getFrontPageData();
    } else {
      return await appService.getFrontPageDataForUser(_uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: logo,
        // leading: ,
        actions: [
          // unreadNewsfeeds == "0" || unreadNewsfeeds == null
          //     ? IconButton(
          //         icon: Icon(Icons.notifications),
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/newsfeed');
          //         },
          //       )
          //     : Badge(
          //         position: BadgePosition.topRight(top: 9, right: 9),
          //         badgeContent: Text(unreadNewsfeeds),
          //         child: IconButton(
          //           icon: Icon(Icons.notifications),
          //           onPressed: () {
          //             Navigator.pushNamed(context, '/newsfeed');
          //           },
          //         ),
          //       ),
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () {
              // TODO Properly implement pushing the ble page
              // Navigator.pushNamed(context, "/ble");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BleDevicesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: _openEndDrawer,
          )
        ],
        iconTheme: IconThemeData(color: MyPrimaryYellowColor),
      ),
      endDrawer: EndDrawerWidget(),
      // drawer: EndDrawerWidget(),
      body: WillPopScope(
        child: _buildBody(),
        onWillPop: () {
          if (_globalKey.currentState.isDrawerOpen) {
            Navigator.pop(context);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
      ),
      backgroundColor: Color.fromARGB(0x00, 0x21, 0x29, 0x35),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Coach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Data',
          ),
        ],
        backgroundColor: MyPrimaryBlueColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/coach');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/vod_fav');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/data_main');
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    // var myCarousel1 = CarouselSlider(
    //   options: CarouselOptions(
    //     // height: 200,
    //     aspectRatio: 16 / 9,
    //     // viewportFraction: 0.8,
    //     viewportFraction: 1,
    //     initialPage: 0,
    //     enableInfiniteScroll: true,
    //     reverse: false,
    //     autoPlay: true,
    //     autoPlayInterval: Duration(seconds: 3),
    //     autoPlayAnimationDuration: Duration(milliseconds: 800),
    //     autoPlayCurve: Curves.fastOutSlowIn,
    //     enlargeCenterPage: true,
    //     // onPageChanged: callbackFunction,
    //     scrollDirection: Axis.horizontal,
    //   ),
    //   items: imgList.map((i) {
    //     return Container(
    //       child: Image(image: AssetImage(i)),
    //     );
    //   }).toList(),
    // );

    return FutureBuilder<FrontPageData>(
      future: fpd,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${snapshot.error}"),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VodCateListScreen(
                            selPcId: -1,
                            selScId: -1,
                          ),
                        ),
                      );
                    },
                    child: Text('VodCateListScreen'),
                  ),
                ],
              ),
            ),
          );
          // return Text("${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
            ),
          );
        }

        // var myCarousel2 = CarouselSlider(
        //   options: CarouselOptions(
        //     // height: 200,
        //     aspectRatio: 16 / 9,
        //     viewportFraction: 0.8,
        //     // viewportFraction: 1,
        //     initialPage: 0,
        //     enableInfiniteScroll: true,
        //     reverse: false,
        //     autoPlay: true,
        //     autoPlayInterval: Duration(seconds: 3),
        //     autoPlayAnimationDuration: Duration(milliseconds: 800),
        //     autoPlayCurve: Curves.fastOutSlowIn,
        //     enlargeCenterPage: false,
        //     // onPageChanged: callbackFunction,
        //     scrollDirection: Axis.horizontal,
        //   ),
        //   items: snapshot.data.banners.map((i) {
        //     return Container(
        //       margin: EdgeInsets.all(5.0),
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.all(Radius.circular(15.0)),
        //         // child: Image.asset(i, fit: BoxFit.fitHeight, width: 1000.0),
        //         child: Image.network(i.img, fit: BoxFit.fitHeight, width: 1000.0),
        //       ),
        //     );
        //   }).toList(),
        // );

        displayedVod = snapshot.data.latestVod;
        if (_uid != -1 && displayedVod != null && displayedVod.isFavorite != null && displayedVod.isFavorite) {
          favIconColor = Colors.yellow;
        } else {
          favIconColor = Colors.grey;
        }
        var selectedVod = Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .35,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(displayedVod.thumbnail),
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
                        // snapshot.data.title,
                        displayedVod.title,
                        style: TextStyle(fontSize: FontSize.xLarge.size),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                              Text("재생", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          onPressed: () => _handleVodPlay(snapshot.data.latestVod),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              Text("공유", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          onPressed: () => _handleVodShare(displayedVod),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.stars, color: favIconColor),
                              Text("즐겨찾기", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          onPressed: () => _handleVodFav(displayedVod),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );

        var recentVods = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _buildRecentVids(snapshot.data.latestVods)),
        );

        var pcLatestVods = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var pc in snapshot.data.pcLatestVods) _buildPcLatestVids(pc),
          ],
        );

        return Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/bg_logo_white.jpg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // mySignalPicker,
                // myCarousel1,
                // myCarousel2,
                selectedVod,
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.fromLTRB(7, 3, 3, 8),
                  child: Text(
                    "새로 올라온 콘텐츠",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 10),
                recentVods,
                // isRecentVodsLoading ? CircularProgressIndicator() : recentVods,
                SizedBox(height: 10),
                pcLatestVods
                // Text("현재 시청중인 페이지"),
                // SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildRecentVids(latestVods) {
    List<Widget> vods = [];
    for (var vod in latestVods) {
      var vodThumbnail = Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 40),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyPrimaryYellowColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: NetworkImage(vod.thumbnail),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(),
        ),
      );

      var vodGradient = Positioned(
        bottom: 10,
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: BoxShape.circle,
          ),
        ),
      );

      var vodBottomFill = Positioned.fill(
        bottom: 30,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            vod.title,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: TextStyle(
              fontSize: FontSize.large.size,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );

      vods.add(
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VodSelectedScreen(vodId: vod.id),
                ),
              );
            },
            child: SizedBox(
              height: 120,
              width: 160,
              child: vodThumbnail,
            )
            // child: SizedBox(
            //   height: 125,
            //   width: 160,
            //   child: Stack(
            //     fit: StackFit.expand,
            //     children: [
            //       vodThumbnail,
            //       vodGradient,
            //       vodBottomFill,
            //     ],
            //   ),
            // ),
            ),
      );
    }
    return vods;
  }

  Column _buildPcLatestVids(pclv) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRect(
          child: Stack(
            children: [
              Positioned(
                top: 2.0,
                left: 2.0,
                child: Text(
                  pclv.pc.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Text(
                  pclv.pc.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _buildRecentVids(pclv.vodList)),
        ),
        // SizedBox(height: 10)
      ],
      // children: [Text(pclv.pc.title), _buildPcLatestVodsRow(pclv.vodList), SizedBox(height: 10)],
    );
  }

  SingleChildScrollView _buildPcLatestVodsRow(latestVods) {
    List<Widget> vods = [];
    for (var vod in latestVods) {
      vods.add(
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VodSelectedScreen(vodId: vod.id),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 90,
            width: 160,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(vod.thumbnail),
                fit: BoxFit.fitHeight,
              ),
              // borderRadius: BorderRadius.circular(5),
            ),
            child: Container(),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: vods),
    );
  }

  void _openEndDrawer() {
    _globalKey.currentState.openEndDrawer();
  }

  _handleVodPlay(Vod snapshotData) {
    // if (_uid == -1) {
    //   Fluttertoast.showToast(msg: '로그인 is required.');
    //   return;
    // }
    // if (!snapshotData.viewableTo.contains(_urole)) {
    //   Fluttertoast.showToast(msg: '권한 없습니다.');
    //   return;
    // }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VodPlayScreen(
    //       uid: _uid,
    //       myVod: snapshotData,
    //     ),
    //   ),
    // );
  }

  _handleVodShare(Vod snapshotData) {
    print('공유 clicked');
    // TODO properly implement share
    Share.share('ughh', subject: 'ugh');
  }

  _handleVodFav(Vod snapshotData) async {
    print('즐겨찾기 clicked');
    if (_uid == -1) {
      Fluttertoast.showToast(msg: 'You must be logged in to use this function');
    } else {
      print(snapshotData.isFavorite);
      if (snapshotData.isFavorite) {
        var results = await appService.removeVodFromFavorites(snapshotData.id, _uid);
        print(results.toString());
        Fluttertoast.showToast(msg: 'Removed from favorites');
        setState(() {
          favIconColor = Colors.grey;
        });
        snapshotData.isFavorite = false;
      } else {
        var results = await appService.addVodToFavorites(snapshotData.id, _uid);
        print(results.toString());
        Fluttertoast.showToast(msg: 'Added to favorites');
        setState(() {
          favIconColor = Colors.yellow;
        });
        snapshotData.isFavorite = true;
      }
    }
  }
}
