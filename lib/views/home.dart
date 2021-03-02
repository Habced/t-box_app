import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/style.dart';
import 'package:tboxapp/components/end_drawer.dart';
import 'package:tboxapp/models/screen_data.model.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/views/ble_devices.dart';
import 'package:tboxapp/services/app_service.dart' as appService;
import 'package:tboxapp/views/data_points.dart';
import 'package:tboxapp/views/vod_cate_list.dart';
import 'package:tboxapp/views/vod_selected.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  String unreadNewsfeeds;
  List<Vod> latestVods;
  bool isRecentVodsLoading = true;

  Future<dynamic> futureBannerList;
  bool isBannersLoading = true;
  Future<FrontPageData> fpd;

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    print('a');
    _getTotalUnread();
    fpd = _getFpd();
    print('c');
    print(fpd);
    // TODO check if user is logged in and if userrole was updated
  }

  _getTotalUnread() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var result = await tbService.getTotalUnreadNewsfeed(prefs.getInt('id'));
    // unreadNewsfeeds = result['total_unread'].toString();
    // debugPrint(unreadNewsfeeds);
    // setState(() {});
  }

  Future<FrontPageData> _getFpd() async {
    print('b');
    return await appService.getFrontPageData();
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
      backgroundColor: Colors.black,
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

    // var recentVods = SingleChildScrollView(
    //   scrollDirection: Axis.horizontal,
    //   child: Row(children: _buildRecentVids()),
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

        var myCarousel2 = CarouselSlider(
          options: CarouselOptions(
            // height: 200,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            // viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            // onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: snapshot.data.banners.map((i) {
            return Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                // child: Image.asset(i, fit: BoxFit.fitHeight, width: 1000.0),
                child: Image.network(i.img, fit: BoxFit.fitHeight, width: 1000.0),
              ),
            );
          }).toList(),
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
                myCarousel2,
                SizedBox(height: 10),
                Text("최신영상"),
                SizedBox(height: 10),
                // isRecentVodsLoading ? CircularProgressIndicator() : recentVods,
                SizedBox(height: 10),
                // Text("현재 시청중인 페이지"),
                // SizedBox(height: 10),

                // RaisedButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, '/coach');
                //   },
                //   child: Text('Go to Coach', style: TextStyle(color: Colors.white)),
                // ),
                // RaisedButton(
                //   onPressed: () {
                //     // Navigator.pushNamed(context, '/vod_selected');
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => DataPointsScreen(),
                //       ),
                //     );
                //   },
                //   child: Text('point list'),
                // ),
                // RaisedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => VodCateListScreen(
                //           selPcId: -1,
                //           selScId: -1,
                //         ),
                //       ),
                //     );
                //   },
                //   child: Text('VodCateListScreen'),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildRecentVids() {
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
          onTap: () {},
          child: SizedBox(
            height: 200,
            width: 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                vodThumbnail,
                vodGradient,
                vodBottomFill,
              ],
            ),
          ),
        ),
      );
    }
    return vods;
  }

  void _openEndDrawer() {
    _globalKey.currentState.openEndDrawer();
  }
}
