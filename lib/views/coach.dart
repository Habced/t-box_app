import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/shared/global_vars.dart' as gvars;
import 'package:tboxapp/components/coach_mode_select.dart';
import 'package:tboxapp/components/coach_mode_adjust.dart';

class CoachScreen extends StatefulWidget {
  @override
  CoachScreenState createState() => CoachScreenState();
}

class CoachScreenState extends State<CoachScreen> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  double myWidth = 400.0;
  double myHeight = 400.0;

  TabController tabController;
  String selectedTab;

  @override
  void initState() {
    super.initState();

    selectedTab = 'Adjust';
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      if (tabController.index == 0) {
        selectedTab = 'Adjust';
      } else if (tabController.index == 1) {
        selectedTab = 'Select';
      } else {
        selectedTab = 'Unaccounted for tab';
      }
      print(selectedTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    myWidth = MediaQuery.of(context).size.width;
    myHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.black,
      appBar: buildFullAppBar(context),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    var adjustTab = CoachModeAdjust(); // = _buildAdjustTab();
    var selectTab = CoachModeSelect();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
              indicatorColor: gvars.MyPrimaryYellowColor,
              labelColor: gvars.MyPrimaryYellowColor,
              unselectedLabelColor: Colors.white,
              controller: tabController,
              tabs: [
                Tab(text: "Adjust"),
                Tab(text: "Select"),
              ]),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: [
              adjustTab,
              selectTab,
            ],
          ))
        ],
      ),
    );
  }
}
