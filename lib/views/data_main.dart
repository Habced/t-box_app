import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class DataMainScreen extends StatefulWidget {
  @override
  DataMainScreenState createState() => DataMainScreenState();
}

class DataMainScreenState extends State<DataMainScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //TODO implement get data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    var dataHeader = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_logo_yellow.jpg'),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/data_main_header.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 30),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Data Center',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );

    var bd800 = BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[800]);
    var bd700 = BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey[700]);
    var dataTs = TextStyle(fontSize: FontSize.xxLarge.size);

    var weightData = InkWell(
      onTap: () {
        // TODO implment clicked
        print("Weight clicked");
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: bd800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Weight'),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: bd700,
                    child: Image.asset(
                      'assets/images/data_weight.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            // TODO properly get DATA
            Column(
              children: [
                Text('DATA', style: dataTs),
                Text('kg'),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );

    var calorieData = InkWell(
      onTap: () {
        // TODO implment clicked
        print("Calorie clicked");
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: bd800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Calorie'),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: bd700,
                    child: Image.asset(
                      'assets/images/data_cal.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            // TODO properly get DATA
            Column(
              children: [
                Text('DATA', style: dataTs),
                Text('kcal'),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );

    var timeData = InkWell(
      onTap: () {
        // TODO implment clicked
        print("Time clicked");
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: bd800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Time'),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: bd700,
                    child: Image.asset(
                      'assets/images/data_time.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            // TODO properly get DATA
            Column(
              children: [
                Text('DATA', style: dataTs),
                Text('hrs'),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );

    var touchData = InkWell(
      onTap: () {
        // TODO implment clicked
        print("Touch clicked");
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: bd800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Touch'),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: bd700,
                    child: Image.asset(
                      'assets/images/data_touch.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            // TODO properly get DATA
            Column(
              children: [
                Text('DATA', style: dataTs),
                Text('taps'),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );

    var distanceData = InkWell(
      onTap: () {
        // TODO implment clicked
        print("Distance clicked");
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: bd800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Distance'),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: bd700,
                    child: Image.asset(
                      'assets/images/data_distance.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            // TODO properly get DATA
            Column(
              children: [
                Text('DATA', style: dataTs),
                Text('kms'),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          dataHeader,
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [weightData, SizedBox(width: 10), calorieData],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [timeData, SizedBox(width: 10), touchData],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [distanceData],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
