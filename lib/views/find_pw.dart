import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class FindPwScreen extends StatefulWidget {
  @override
  FindPwScreenState createState() => FindPwScreenState();
}

class FindPwScreenState extends State<FindPwScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TextStyle myStyle = TextStyle(
      /*fontFamily: 'Montserrat',*/ fontSize: 20.0,
      color: Colors.white);

  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

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
    final explanationField = Column(
      children: [
        Container(
          width: 400,
          padding: EdgeInsets.symmetric(vertical: 22),
          decoration: DottedDecoration(color: MyPrimaryYellowColor, dash: <int>[4, 2]),
          child: Center(
            child: Text("비밀번호 찾기", style: TextStyle(fontSize: 24)),
          ),
        ),
        SizedBox(height: 5),
        Text("회원가입시 입력하신", style: TextStyle(fontSize: 18)),
        Text("아이디/이름/이메일주소를 입력해주세요", style: TextStyle(fontSize: 18)),
      ],
    );
    final idField = TextField(
      controller: _idController,
      obscureText: false,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "아이디",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final nameField = TextField(
      controller: _nameController,
      obscureText: false,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "이름",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final emailField = TextField(
      controller: _emailController,
      obscureText: false,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "이메일",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final sendEmailButton = Material(
      elevation: 5.0,
      // borderRadius: BorderRadius.circular(30.0),
      color: MyPrimaryYellowColor.withOpacity(0.8),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        onPressed: () {
          _handleSendEmail();
        },
        child: Text("이메일 전송",
            textAlign: TextAlign.center, style: myStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final navBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFlatNavButton("로그인", "/login"),
        Text("|"),
        _buildFlatNavButton("화원가입", "/signup"),
        Text("|"),
        _buildFlatNavButton("아이디 찾기", "/find_id"),
      ],
    );
    return SizedBox.expand(
      child: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/bg_login.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        color: Colors.black,
        constraints: BoxConstraints.expand(),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  explanationField,
                  SizedBox(height: 10),
                  idField,
                  SizedBox(height: 25.0),
                  nameField,
                  SizedBox(height: 25.0),
                  emailField,
                  SizedBox(height: 25.0),
                  sendEmailButton,
                  navBar,
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildFlatNavButton(name, route) {
    return SizedBox(
      width: 115,
      child: FlatButton(
        minWidth: 50,
        onPressed: () {
          // Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        child: Text(name),
      ),
    );
  }

  _handleSendEmail() {
    var myResult;
    appService
        .sendResetPasswordEmail(_idController.text, _nameController.text, _emailController.text)
        .then(
          (result) => {
            myResult = result,
            debugPrint(myResult.toString()),
          },
        )
        .catchError(
          (Object error) => {
            debugPrint(error.toString()),
            Fluttertoast.showToast(
              msg: myResult['res_msg'],
              toastLength: Toast.LENGTH_LONG,
            ),
          },
        )
        .whenComplete(
          () => {
            if (myResult['res_code'] == 1)
              {
                Fluttertoast.showToast(
                  msg: "이메일이 전송되었습니다",
                  toastLength: Toast.LENGTH_LONG,
                ),
              }
            else if (myResult['res_code'] == 2)
              {
                Fluttertoast.showToast(
                  msg: "입력하신 내용을 다시 한 번 확인해 주세요.",
                  toastLength: Toast.LENGTH_LONG,
                ),
              }
            else
              {
                Fluttertoast.showToast(
                  msg: "입력하신 내용을 다시 한 번 확인해 주세요.",
                  toastLength: Toast.LENGTH_LONG,
                ),
              },
          },
        );
  }
}
