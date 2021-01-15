import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/faq.model.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class FaqAnswerScreen extends StatefulWidget {
  @override
  FaqAnswerScreenState createState() => FaqAnswerScreenState();
}

class FaqAnswerScreenState extends State<FaqAnswerScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  Faq myFaq;
  String faqAnswer;

  getFaqAnswer() async {
    if (myFaq == null) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;
      myFaq = arguments['myFaq'];
      var result = await appService.getFaqAnswer(myFaq.id);
      faqAnswer = result['answer'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      appService.addFaqClick(prefs.getInt('id'), myFaq.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getFaqAnswer();
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
        color: Colors.black,
        constraints: BoxConstraints(maxWidth: bodyWidth),
        height: MediaQuery.of(context).size.height,
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
                Text(myFaq.question),
                Divider(
                  color: Color(0xFF636363),
                  thickness: 1,
                ),
                faqAnswer == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Html(
                        data: faqAnswer,
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
