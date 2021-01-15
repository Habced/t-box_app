import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tboxapp/components/end_drawer.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/services/app_service.dart' as appService;
import 'package:tboxapp/models/store.model.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatefulWidget {
  @override
  StoreScreenState createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  Future<List<StoreItem>> futureStoreItems;

  int _filterValue = -1;
  List<int> storeCateIds; // To keep track of which myStoreCates were added
  List<DropdownMenuItem> myStoreCates;
  List<StoreItem> filteredStoreItems;
  List<StoreItem> storeItems;

  @override
  void initState() {
    super.initState();
    futureStoreItems = appService.getAllStoreItem();
    storeCateIds = [-1];
    myStoreCates = [DropdownMenuItem(child: Text("All"), value: -1)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: buildFullAppBar(context),
      endDrawer: EndDrawerWidget(),
      body: WillPopScope(
          child: _buildBody(),
          onWillPop: () {
            if (_globalKey.currentState.isDrawerOpen) {
              Navigator.pop(context);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          }),
      // bottomNavigationBar: buildBottomNavigationBar(context, 3),
    );
  }

  Widget _buildBody() {
    var filterDropdown = DropdownButton(
      value: _filterValue,
      onChanged: (value) {
        setState(() {
          _filterValue = value;
        });
      },
      items: myStoreCates,
    );

    double bodyWidth = 700;
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            color: Colors.black,
            constraints: BoxConstraints(maxWidth: bodyWidth),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "스토어",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(width: 130, child: filterDropdown),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                          FutureBuilder<List<StoreItem>>(
                            future: futureStoreItems,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                storeItems = snapshot.data;
                                // filteredStoreItems = snapshot.data;
                                if (_filterValue == -1) {
                                  filteredStoreItems = storeItems;
                                } else {
                                  filteredStoreItems = [];
                                  for (var i = 0; i < storeItems.length; i++) {
                                    if (storeItems[i].cateId == _filterValue) {
                                      filteredStoreItems.add(storeItems[i]);
                                    }
                                  }
                                }
                                return Column(
                                    children:
                                        _getRows(context, filteredStoreItems)
                                    // children: [
                                    //   for( var storeItem in snapshot.data) _buildStoreItem(storeItem)
                                    // ]
                                    );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            },
                          ),
                        ])))));
    // return Center(
    //   child: FutureBuilder<List<StoreItem>>(
    //     future: futureStoreItems,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return Column(
    //           children: [
    //             for( var storeItem in snapshot.data) _buildStoreItem(storeItem)
    //           ]
    //         );
    //       } else if (snapshot.hasError) {
    //         return Text("${snapshot.error}");
    //       }

    //       return CircularProgressIndicator();
    //     },
    //   ),
    // );
  }

  List<Widget> _getRows(context, storeItems) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < storeItems.length; i += 2) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStoreItem(context, storeItems[i]),
          SizedBox(width: 1),
          i + 1 < storeItems.length
              ? _buildStoreItem(context, storeItems[i + 1])
              : Expanded(flex: 1, child: Container())
        ],
      ));
      list.add(
        SizedBox(height: 2),
      );
    }
    return list;
  }

  Widget _buildStoreItem(context, StoreItem storeItem) {
    if (!storeCateIds.contains(storeItem.cateId)) {
      storeCateIds.add(storeItem.cateId);
      myStoreCates.add(DropdownMenuItem(
          child: Text(storeItem.cate), value: storeItem.cateId));
    }
    return Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () async {
            if (storeItem.naverStoreLink != '' &&
                storeItem.naverStoreLink != 'soldout') {
              if (await canLaunch(storeItem.naverStoreLink)) {
                await launch(storeItem.naverStoreLink);
              }
            } else if (storeItem.interparkStoreLink != '' &&
                storeItem.naverStoreLink != 'soldout') {
              if (await canLaunch(storeItem.interparkStoreLink)) {
                await launch(storeItem.interparkStoreLink);
              }
            } else if (storeItem.naverStoreLink == 'soldout' ||
                storeItem.interparkStoreLink == 'soldout') {
              FlutterToast.showToast(msg: "Sold Out");
            } else {
              FlutterToast.showToast(msg: "Error with link");
            }
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                  child: Image.network(
                      'https://i1.tbox.media/' + storeItem.mainImg)),
              Column(
                children: [
                  Text(storeItem.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 3,
                  ),
                  Text(storeItem.price.toString() + ' 원',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              )
            ],
          ),
        ));

    //  Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Container(
    //         child: Image.network(
    //             'https://i1.tbox.media/' + storeItem.mainImg)),
    //     SizedBox(
    //       height: 8,
    //     ),
    //     Text(storeItem.name),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     Text(storeItem.price.toString() + ' 원',
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //         )),
    //     SizedBox(
    //       height: 8,
    //     ),
    //     OutlineButton.icon(
    //       color: Colors.white,
    //       textColor: Colors.white,
    //       highlightColor: Colors.white,
    //       highlightedBorderColor: Colors.white,
    //       borderSide: BorderSide(
    //         width: 1.0,
    //         color: Colors.white,
    //         style: BorderStyle.solid,
    //       ),
    //       icon: Icon(
    //         Icons.local_offer,
    //         color: Colors.white,
    //       ),
    //       label: Text('구매하기', style: TextStyle(color: Colors.white)),
    //       onPressed: () async {
    //         if (storeItem.naverStoreLink != '' &&
    //             storeItem.naverStoreLink != 'soldout') {
    //           if (await canLaunch(storeItem.naverStoreLink)) {
    //             await launch(storeItem.naverStoreLink);
    //           }
    //         } else if (storeItem.interparkStoreLink != '' &&
    //             storeItem.naverStoreLink != 'soldout') {
    //           if (await canLaunch(storeItem.interparkStoreLink)) {
    //             await launch(storeItem.interparkStoreLink);
    //           }
    //         } else if (storeItem.naverStoreLink == 'soldout' ||
    //             storeItem.interparkStoreLink == 'soldout') {
    //           FlutterToast.showToast(msg: "Sold Out");
    //         } else {
    //           FlutterToast.showToast(msg: "Error with link");
    //         }
    //       },
    //     )
    //   ],
  }
}
