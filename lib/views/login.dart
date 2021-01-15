import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TextStyle myStyle = TextStyle(
      /*fontFamily: 'Montserrat',*/ fontSize: 20.0,
      color: Colors.white);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Possible states
  // nothing, logging in, empty, API Error, incorrect, deactivated, deleted
  String loginState = "nothing";

  updateState(newLoginState) {
    setState(() {
      debugPrint("Updating State to: " + newLoginState);
      loginState = newLoginState;
    });
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
    var errorTextStyle = TextStyle(color: Colors.red, fontSize: 18);

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
    final passwordField = TextField(
      controller: _passwordController,
      obscureText: true,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "비밀번호",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final loginButton = Material(
      elevation: 5.0,
      // borderRadius: BorderRadius.circular(30.0),
      color: MyPrimaryYellowColor.withOpacity(0.8),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        onPressed: () {
          if (loginState != "logging in") {
            _performLogin();
          } // else do nothing
        },
        child: Text("로그인",
            textAlign: TextAlign.center,
            style: myStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final navBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFlatNavButton("화원가입", "/signup"),
        Text("|"),
        _buildFlatNavButton("아이디 찾기", "/find_id"),
        Text("|"),
        _buildFlatNavButton("비밀번호 찾기", "/find_pw"),
      ],
    );
    return SizedBox.expand(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loginState == "empty"
                          ? Text("아이디와 비밀번호를 입력해 주세요.", style: errorTextStyle)
                          : Container(),
                      // TODO get translation
                      loginState == "API Error"
                          ? Text(
                              "An Error occured while connecting to the database.",
                              style: errorTextStyle)
                          : Container(),
                      loginState == "incorrect"
                          ? Text("아이디와 비밀번호를 확인해 주세요.", style: errorTextStyle)
                          : Container(),
                      loginState == "deactivated"
                          ? Text(
                              "회원님의 계정은 사이트에서\n비활성화되었으며 14일 이내에\n영구 삭제 될 예정입니다.\n14일 이내에 계정 활성화를 하면\n삭제 요청이 취소되고 계정이\n활성화 됩니다.",
                              style: errorTextStyle,
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                      loginState == "deleted"
                          ? Text(
                              "회원님의 계정은\n사이트에서 영구히 삭제되었습니다.\n사이트 이용을 원하시면 아래 회원가입\n버튼을 눌러 다른 아이디로 재가입해\n주시기 바랍니다",
                              style: errorTextStyle,
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(height: 25.0),
                      loginButton,
                      navBar,
                    ],
                  )),
            ),
          )),
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

  _performLogin() {
    updateState("logging in");
    if (_emailController.text == "" || _passwordController.text == "") {
      updateState("empty");
      return;
    }

    var myLogin;
    var myResCode;
    appService
        .login(_emailController.text, _passwordController.text)
        .then((result) => {debugPrint(result.toString()), myLogin = result})
        .catchError((Object error) => {
              updateState("API Error"),
              debugPrint(error.toString()),
            })
        .whenComplete(() => {
              myResCode = myLogin['res_code'],
              if (myResCode == 7)
                {updateState("deleted")}
              else if (myResCode == 6)
                {updateState("deactivated")}
              else if (myResCode == 5 || myResCode == 1)
                {
                  debugPrint("The returned res_code is 5 or 1"),
                  // _saveUserInfo( id, fullname, email, username, role, cellphone, photoUrl, zipNo, jibunAddr, roadAddr, detailJuso );
                  _saveUserInfo(
                    myLogin['user_info']['id'],
                    myLogin['user_info']['fullname'],
                    myLogin['user_info']['email'],
                    myLogin['user_info']['username'],
                    myLogin['user_info']['role'],
                    myLogin['user_info']['cellphone'],
                    myLogin['user_info']['profile_photo_url'],
                    myLogin['address'][0]['zipNo'],
                    myLogin['address'][0]['jibunAddr'],
                    myLogin['address'][0]['roadAddr'],
                    myLogin['address'][0]['detailJuso'],
                  ),
                  if (myResCode == 5)
                    {
                      // voucher about to expire or has expired
                      debugPrint("The returned res_code is 5")
                    },
                  Navigator.of(context).popUntil((route) => route.isFirst),
                }
              else
                {
                  // There was an error - most likely email or pw incorrect error
                  updateState("incorrect"),
                }
            });
    //, onError: updateState("DB Connection failed"),
    //).
  }

  _saveUserInfo(id, fullname, email, username, role, cellphone, photoUrl, zipNo,
      jibunAddr, roadAddr, detailJuso) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    prefs.setString('fullname', fullname);
    prefs.setString('email', email);
    prefs.setString('username', username);
    prefs.setInt('role', role);
    prefs.setString('cellphone', cellphone);
    var myPurl = "https://i1.tbox.media/" + photoUrl;
    prefs.setString('photoUrl', myPurl);
    prefs.setString('zipNo', zipNo ?? "");
    prefs.setString('jibunAddr', jibunAddr ?? "");
    prefs.setString('roadAddr', roadAddr ?? "");
    prefs.setString('detailJuso', detailJuso ?? "");
    prefs.setBool('loggedIn', true);
  }
}
