import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/faq.model.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class FaqScreen extends StatefulWidget {
  @override
  FaqScreenState createState() => FaqScreenState();
}

class FaqScreenState extends State<FaqScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  Future<FaqList> futureFaqList;

  @override
  void initState() {
    super.initState();
    futureFaqList = appService.getAllFaqWoAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: buildFullAppBar(context),
      // endDrawer: EndDrawerWidget(),
      body: _buildBody(),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Container(
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FAQ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(flex: 4, child: Text("질문")),
                  Expanded(flex: 1, child: Center(child: Text("조회수"))),
                  Expanded(flex: 1, child: Center(child: Text("작성자"))),
                ],
              ),
              Divider(color: Colors.white),
              FutureBuilder(
                future: futureFaqList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [for (var faq in snapshot.data.faq) _buildFaq(faq)]);
                  } else if (snapshot.hasError) {
                    Fluttertoast.showToast(
                      msg: "Could not retrieve data.",
                      toastLength: Toast.LENGTH_LONG,
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaq(Faq faqData) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/faq_answer', arguments: {'myFaq': faqData});
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(flex: 4, child: Text(faqData.question)),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(faqData.clickCount.toString()),
                  ),
                ),
                Expanded(flex: 1, child: Text("T-CYCLING")),
              ],
            ),
          ),
        ),
        Divider(color: Colors.white),
      ],
    );
  }
}
