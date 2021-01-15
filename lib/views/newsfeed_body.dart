import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/newsfeed.model.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class NewsfeedBodyScreen extends StatefulWidget {
  @override
  NewsfeedBodyScreenState createState() => NewsfeedBodyScreenState();
}

class NewsfeedBodyScreenState extends State<NewsfeedBodyScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  Newsfeed myNewsfeed;
  String newsfeedBody;

  getNewsfeedAnswer() async {
    if (myNewsfeed == null) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;
      myNewsfeed = arguments['myNewsfeed'];
      var result = await appService.getNewsfeedBody(myNewsfeed.id);
      newsfeedBody = result['body'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      appService.addNewsfeedClick(prefs.getInt('id'), myNewsfeed.id);
      myNewsfeed.hasRead = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getNewsfeedAnswer();
    return Scaffold(
      key: _globalKey,
      appBar: buildFullAppBar(context),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    double bodyWidth = 700;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: bodyWidth),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("공지사항", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(color: Colors.white, thickness: 2),
                SizedBox(height: 25),
                Text(myNewsfeed.title),
                Divider(color: Color(0xFF636363), thickness: 1),
                newsfeedBody == null
                    ? Center(child: CircularProgressIndicator())
                    : Html(
                        data: newsfeedBody,
                        onLinkTap: (url) {},
                        style: {},
                        onImageTap: (src) {},
                        onImageError: (exception, stackTrace) {
                          debugPrint(exception.toString());
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
