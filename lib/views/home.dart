import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/style.dart';
import 'package:tboxapp/components/end_drawer.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/views/ble_devices.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

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

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    _getTotalUnread();
    _getBanners();
    _getLatestVods();
  }

  _getTotalUnread() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var result = await tbService.getTotalUnreadNewsfeed(prefs.getInt('id'));
    // unreadNewsfeeds = result['total_unread'].toString();
    // debugPrint(unreadNewsfeeds);
    // setState(() {});
  }

  _getBanners() async {
    var response = await appService.getAllBanner();
    if (response['res_code'] == 0) {
      return;
    }
    for (var img in response['results']) {
      setState(() {
        imgList.add('https://i1.tbox.media/' + img['img']);
      });
    }
  }

  _getLatestVods() async {
    // TODO Uncomment when API is complete
    // var response = await tbService.getAllVod(6);
    // var results = response['results'];
    // for( var v in results ) {
    //   latestVods.add(
    //     Vod(
    //       id: v['id'],
    //       title: v['title'],
    //       contents: v['contents'],
    //       vod: v['vod'],
    //       mrbg: v['mrbg'],
    //       thumbnail: v['thumbnail'],
    //       primaryCate: v['primaryCate'],
    //       secondaryCate: v['secondaryCate'],
    //       gangsaName: v['gangsaName'],
    //       viewableTo: v['viewableTo'],
    //     )
    //   );
    // }
    // TODO Remove when API is complete
    latestVods = [
      Vod(
          id: 1,
          title: 'a',
          contents: 'asdf',
          vod: 'a link',
          mrbg: 'a link',
          thumbnail: 'https://i1.tbox.media/vodthumbnail/2020/06/19/e5abd59e90144e5bbc2c20e8a3a71427.jpg',
          primaryCate: 1,
          secondaryCate: 1,
          gangsaName: 'asdf',
          viewableTo: [1, 2, 3]),
      Vod(
          id: 2,
          title: 'b',
          contents: 'asdf',
          vod: 'a link',
          mrbg: 'a link',
          thumbnail: 'https://i1.tbox.media/vodthumbnail/2020/06/19/e5abd59e90144e5bbc2c20e8a3a71427.jpg',
          primaryCate: 1,
          secondaryCate: 1,
          gangsaName: 'asdf',
          viewableTo: [1, 2, 3]),
      Vod(
          id: 4,
          title: 'c',
          contents: 'asdf',
          vod: 'a link',
          mrbg: 'a link',
          thumbnail: 'https://i1.tbox.media/vodthumbnail/2020/06/19/e5abd59e90144e5bbc2c20e8a3a71427.jpg',
          primaryCate: 1,
          secondaryCate: 1,
          gangsaName: 'asdf',
          viewableTo: [1, 2, 3]),
      Vod(
          id: 5,
          title: 'd',
          contents: 'asdf',
          vod: 'a link',
          mrbg: 'a link',
          thumbnail: 'https://i1.tbox.media/vodthumbnail/2020/06/19/e5abd59e90144e5bbc2c20e8a3a71427.jpg',
          primaryCate: 1,
          secondaryCate: 1,
          gangsaName: 'asdf',
          viewableTo: [1, 2, 3]),
      Vod(
          id: 6,
          title: 'aa',
          contents: 'asdf',
          vod: 'a link',
          mrbg: 'a link',
          thumbnail: 'https://i1.tbox.media/vodthumbnail/2020/06/19/e5abd59e90144e5bbc2c20e8a3a71427.jpg',
          primaryCate: 1,
          secondaryCate: 1,
          gangsaName: 'asdf',
          viewableTo: [1, 2, 3]),
      Vod(
          id: 7,
          title: 'bv',
          contents: 'asdf',
          vod: 'a link',
          mrbg: 'a link',
          thumbnail: 'https://i1.tbox.media/vodthumbnail/2020/06/19/e5abd59e90144e5bbc2c20e8a3a71427.jpg',
          primaryCate: 1,
          secondaryCate: 1,
          gangsaName: 'asdf',
          viewableTo: [1, 2, 3]),
    ];
    // print(latestVods.toString());
    isRecentVodsLoading = false;
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/coach');
          } else if (index == 1) {
            // TODO
            // Navigator.pushNamed(context, '/coach');
          } else if (index == 2) {
            // TODO
            // Navigator.pushNamed(context, '/coach');
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
      items: imgList
          .map(
            (i) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  // child: Image.asset(i, fit: BoxFit.fitHeight, width: 1000.0),
                  child: Image.network(i, fit: BoxFit.fitHeight, width: 1000.0),
                ),
              ),
            ),
          )
          .toList(),
    );

    var recentVods = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _buildRecentVids(),
      ),
    );

    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/bg_logo_white.jpg'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      color: Colors.black,
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // mySignalPicker,
            // myCarousel1,
            myCarousel2,
            SizedBox(height: 10),
            // _buildCategory("T-BOX", [] /* TODO */),
            // _buildCategory("T-Cycling", [] /* TODO */),
            // _buildCategory("T-CYCLING"),
            Text("최신영상"),
            SizedBox(height: 10),
            isRecentVodsLoading ? CircularProgressIndicator() : recentVods,
            SizedBox(height: 10),
            Text("현재 시청중인 페이지"),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/coach');
              },
              child: Text('Go to Coach', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecentVids() {
    List<Widget> vods = [];
    for (var vod in latestVods) {
      vods.add(
        GestureDetector(
          onTap: () {},
          child: SizedBox(
            height: 200,
            width: 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
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
                ),
                Positioned(
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
                ),
                Positioned.fill(
                  bottom: 30,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      vod.title,
                      style: TextStyle(fontSize: FontSize.large.size, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )
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
