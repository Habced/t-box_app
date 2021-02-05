import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/models/vod_cate.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;
import 'package:tboxapp/views/vod_selected.dart';

class VodCateListScreen extends StatefulWidget {
  final int selPcId;
  final int selScId;

  VodCateListScreen({Key key, @required this.selPcId, @required this.selScId}) : super(key: key);
  @override
  VodCateListScreenState createState() => VodCateListScreenState();
}

class VodCateListScreenState extends State<VodCateListScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  TabController _tabController;

  // Future<List<VodCate>> futureVodCateList;
  // Future<List<Vod>> futureVodList;
  Future<List<PcScV>> futurePcScV;

  int currentPcId;
  int currentScId;
  List<PcScV> allPcScV;
  List<Vod> filteredVods;

  @override
  void initState() {
    super.initState();
    currentPcId = widget.selPcId;
    currentScId = widget.selScId;
    allPcScV = [];
    filteredVods = [];
    // _tabController = TabController(vsync: this, length: 2);
    // futureVodFavList = getFutureVodFavList();
    // futureVodWatchedList = getFutureVodWatchedList();
    futurePcScV = getFuturePcScV();
  }

  Future<List<PcScV>> getFuturePcScV() async {
    return await appService.getAllVod(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: buildFullAppBar(context),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return FutureBuilder<List<PcScV>>(
      future: futurePcScV,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          allPcScV = snapshot.data;

          List<DropdownMenuItem> myPcItems = [DropdownMenuItem<int>(value: -1, child: Text('All'))];
          myPcItems.addAll(snapshot.data.map((PcScV psv) {
            return DropdownMenuItem<int>(value: psv.pc.id, child: Text(psv.pc.title));
          }).toList());

          var pcDropdown = DropdownButton(
            value: currentPcId,
            items: myPcItems,
            onChanged: (val) {
              _pcChange(val);
              filterVods();
              setState(() {});
            },
          );

          var separtor = Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 10, 0),
            child: Text('>', style: TextStyle(fontSize: FontSize.xLarge.size)),
          );

          List<DropdownMenuItem> myScItems = [DropdownMenuItem<int>(value: -1, child: Text('All'))];
          if (currentPcId != -1 && snapshot.data.where((PcScV psv) => psv.pc.id == currentPcId).toList() != []) {
            myScItems.addAll(snapshot.data.where((PcScV psv) => psv.pc.id == currentPcId).first.sc.map(
              (SecondaryCateVods scv) {
                return DropdownMenuItem<int>(value: scv.sc.id, child: Text(scv.sc.title));
              },
            ).toList());
          }

          var scDropdown = DropdownButton(
            value: currentScId,
            items: myScItems,
            onChanged: (val) {
              _scChange(val);
              filterVods();
              setState(() {});
            },
          );

          filterVods();

          var cateRow = Row(
            children: [
              pcDropdown,
              currentPcId != -1 ? separtor : Container(),
              currentPcId != -1 ? scDropdown : Container(),
            ],
          );

          var vods = _buildVods(context, filteredVods);

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  cateRow,
                  Divider(color: Colors.white, thickness: 2),
                  vods,
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
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

    // var scDropdown = FutureBuilder<List<PcScV>>(
    //   future: futurePcScV,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       List<DropdownMenuItem> myItems = [DropdownMenuItem<int>(value: -1, child: Text('All'))];
    //       myItems.addAll(snapshot.data.map((PcScV psv) {
    //         return DropdownMenuItem<int>(value: psv.pc.id, child: Text(psv.pc.title));
    //       }).toList());

    //       return DropdownButton(
    //         value: currentPcId,
    //         items: myItems,
    //         onChanged: (val) {
    //           _pcChange(val);
    //         },
    //       );
    //     } else if (snapshot.hasError) {
    //       return Text("${snapshot.error}");
    //     }

    //     return Center(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
    //       ),
    //     );
    //   },
    // );
  }

  _pcChange(val) {
    print("in _pcChange, selected val: " + val.toString());
    setState(() {
      currentPcId = val;
      currentScId = -1;
    });
  }

  _scChange(val) {
    print("in _scChange, selected val: " + val.toString());
    setState(() {
      currentScId = val;
    });
  }

  filterVods() {
    filteredVods = [];
    if (currentPcId == -1) {
      allPcScV.forEach((PcScV psv) {
        psv.sc.forEach((SecondaryCateVods scv) {
          scv.vodList.forEach((Vod v) {
            filteredVods.add(v);
          });
        });
      });
    } else if (currentPcId != -1 && currentScId == -1) {
      allPcScV.forEach((PcScV psv) {
        if (currentPcId == psv.pc.id) {
          for (var i = 0; i < psv.sc.length; i++) {
            psv.sc[i].vodList.forEach((Vod v) {
              filteredVods.add(v);
            });
          }
        }
      });
    } else if (currentPcId != -1 && currentScId != -1) {
      allPcScV.forEach((PcScV psv) {
        if (currentPcId == psv.pc.id) {
          for (var i = 0; i < psv.sc.length; i++) {
            if (currentScId == psv.sc[i].sc.id) {
              for (var j = 0; j < psv.sc[i].vodList.length; j++) {
                filteredVods.add(psv.sc[i].vodList[j]);
              }
            }
          }
        }
      });
    }
  }

  _buildVods(context, myVods) {
    return Column(
      children: _getRows(context, myVods),
    );
  }

  List<Widget> _getRows(context, vods) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < vods.length; i += 2) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildVod(context, vods[i]),
          SizedBox(width: 10),
          i + 1 < vods.length ? _buildVod(context, vods[i + 1]) : Expanded(flex: 1, child: Container())
        ],
      ));
      list.add(
        SizedBox(height: 15),
      );
    }
    return list;
  }

  _buildVod(context, Vod vodData) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VodSelectedScreen(vodId: vodData.id),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(child: Image.network(vodData.thumbnail)),
            SizedBox(height: 3),
            Text(vodData.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
