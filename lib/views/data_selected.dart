import 'package:flutter/material.dart';

class DataSelectedScreen extends StatefulWidget {
  @override
  DataSelectedScreenState createState() => DataSelectedScreenState();
}

class DataSelectedScreenState extends State<DataSelectedScreen> {
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
    return Container();
  }
}
