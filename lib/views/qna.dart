import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/inquiry.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class QnaScreen extends StatefulWidget {
  @override
  QnaScreenState createState() => QnaScreenState();
}

class QnaScreenState extends State<QnaScreen> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TabController _tabController;

  int _uid;

  final _inquiryTitleController = TextEditingController();
  final _inquiryController = TextEditingController();

  Future<List<Inquiry>> futureInquiries;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    futureInquiries = getFutureInquiries();
  }

  Future<List<Inquiry>> getFutureInquiries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getInt('id') ?? -1;
    if (_uid != -1) {
      return appService.getInquiryByUser(_uid, true);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: buildFullAppBar(context),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var inquiryTab = Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            maxLines: 1,
            controller: _inquiryTitleController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              hintText: "제목을 입력해주세요.",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TextField(
              maxLines: 30,
              controller: _inquiryController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 5.0),
                hintText: "문의하실 내용을 입력해주세요.",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: FlatButton(
              color: MyPrimaryYellowColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onPressed: () async {
                // debugPrint("pressed");
                if (_uid == -1) {
                  FlutterToast.showToast(
                    msg: "Please log in to add an inquiry.",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                } else if (_inquiryTitleController.text == "") {
                  FlutterToast.showToast(
                    msg: "Title cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                } else if (_inquiryController.text == "") {
                  FlutterToast.showToast(
                    msg: "Inquiry cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                } else {
                  // Call the api
                  var result = await appService.addInquiry(_uid, _inquiryTitleController.text, _inquiryController.text);
                  if (result['res_code'] == 1) {
                    _inquiryTitleController.text = "";
                    _inquiryController.text = "";
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inquiry Successfuly Sent'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Your inquiry was sent to the admin. Something about the reply'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    _tabController.animateTo(1);
                  }
                }
              },
              child: Text("확인"),
            ),
          ),
        ],
      ),
    );

    var replyTab = Padding(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<Inquiry>>(
        future: futureInquiries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  snapshot.data[index].isExpanded = !isExpanded;
                });
              },
              // children: snapshot.data.map<ExpansionPanel>((Inquiry inquiry) {
              children: snapshot.data.map<ExpansionPanel>((Inquiry inquiry) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(inquiry.inquiry),
                      subtitle: Text(inquiry.replies.length == 0 ? "미답변" : "답변완료"),
                    );
                  },
                  body: inquiry.replies.length == 0
                      ? Container()
                      : ListTile(
                          title: Text(inquiry.replies[0].reply),
                          // subtitle: ,
                          // trailing: Icon(Icons.??)
                          // onTap: () { setState((){})},
                        ),
                  isExpanded: inquiry.isExpanded,
                  canTapOnHeader: true,
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(height: 10), Text("Loading...")],
            ),
          );
        },
      ),
    );

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "1:1 문의"),
              Tab(text: "문의내역"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [inquiryTab, SingleChildScrollView(child: replyTab)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInquiry(Inquiry inquiry) {
    // TODO Properly create an inquiry
    return Text("Inquiry: " + inquiry.inquiry);
  }
}
