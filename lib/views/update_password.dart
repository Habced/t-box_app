import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class UpdatePasswordScreen extends StatefulWidget {
  @override
  UpdatePasswordScreenState createState() => UpdatePasswordScreenState();
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TextStyle myStyle = TextStyle(fontSize: 20.0, color: Colors.white);

  final _oldPasswordController = TextEditingController();
  bool _isOldPasswordNotFilledOut;
  bool _isOldPasswordIncorrect;
  final _newPasswordController = TextEditingController();
  bool _isNewPasswordNotFilledOut;
  bool _isNewPasswordNotValid;
  final _newPasswordCheckController = TextEditingController();
  bool _isNewPasswordCheckNotFilledOut;
  bool _isNewPasswordCheckNotMatch;

  bool _hasError;

  @override
  void initState() {
    super.initState();
    _isOldPasswordNotFilledOut = false;
    _isOldPasswordIncorrect = false;
    _isNewPasswordNotFilledOut = false;
    _isNewPasswordNotValid = false;
    _isNewPasswordCheckNotFilledOut = false;
    _isNewPasswordCheckNotMatch = false;
    _hasError = false;
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
    final oldPasswordField = TextField(
      controller: _oldPasswordController,
      obscureText: true,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*이전 비밀번호",
      ),
    );
    final newPasswordField = TextField(
      controller: _newPasswordController,
      obscureText: true,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*새로운 비밀번호",
      ),
    );
    final newPasswordCheckField = TextField(
      controller: _newPasswordCheckController,
      obscureText: true,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*새로운 비밀번호 확인",
      ),
    );
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "비밀번호 변경",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "새로운 비밀번호를 입력해 주세요.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 15),
                oldPasswordField,
                _isOldPasswordNotFilledOut ? Text("비밀번호를 입력해 주세요.", style: TextStyle(color: Colors.red)) : Container(),
                _isOldPasswordIncorrect ? Text("비밀번호를 확인해 주세요.", style: TextStyle(color: Colors.red)) : Container(),
                SizedBox(height: 15),
                newPasswordField,
                _isNewPasswordNotFilledOut
                    ? Text("새 비밀번호를 입력해 주세요.", style: TextStyle(color: Colors.red))
                    : Container(),
                _isNewPasswordNotValid
                    ? Text("비밀번호는 여섯자리 이상이어야 합니다.", style: TextStyle(color: Colors.red))
                    : Container(),
                SizedBox(height: 15),
                newPasswordCheckField,
                _isNewPasswordCheckNotFilledOut
                    ? Text("새 비밀번호를 다시한번 입력해 주세요.", style: TextStyle(color: Colors.red))
                    : Container(),
                _isNewPasswordCheckNotMatch
                    ? Text("새 비밀번호가 일치하지 않습니다.", style: TextStyle(color: Colors.red))
                    : Container(),
                SizedBox(height: 25),
                SizedBox(height: 25),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: FlatButton(
                      color: MyPrimaryYellowColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        _handlePasswordUpdate();
                      },
                      child: Text("확인", style: TextStyle(color: Colors.black))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handlePasswordUpdate() async {
    _hasError = false;

    if (_oldPasswordController.text == "") {
      _isOldPasswordNotFilledOut = true;
      _isOldPasswordIncorrect = false;
      _hasError = true;
    } else {
      _isOldPasswordNotFilledOut = false;
      _isOldPasswordIncorrect = false;
    }

    if (_newPasswordController.text == "") {
      _isNewPasswordNotFilledOut = true;
      _isNewPasswordNotValid = false;
      _hasError = true;
    } else if (_newPasswordController.text.length < 6) {
      _isNewPasswordNotFilledOut = false;
      _isNewPasswordNotValid = true;
      _hasError = true;
    } else {
      _isNewPasswordNotFilledOut = false;
      _isNewPasswordNotValid = false;
    }

    if (_newPasswordCheckController.text == "") {
      _isNewPasswordCheckNotFilledOut = true;
      _isNewPasswordCheckNotMatch = false;
      _hasError = true;
    } else if (_newPasswordCheckController.text != _newPasswordController.text) {
      _isNewPasswordCheckNotFilledOut = false;
      _isNewPasswordCheckNotMatch = true;
      _hasError = true;
    } else {
      _isNewPasswordCheckNotFilledOut = false;
      _isNewPasswordCheckNotMatch = false;
    }

    var myResult;
    if (!_hasError) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      appService
          .updatePassword(prefs.getInt('id'), _oldPasswordController.text, _newPasswordController.text)
          .then((result) => {
                myResult = result,
                if (myResult['res_code'] == 1)
                  {
                    Fluttertoast.showToast(
                      msg: "Successfully updated the password",
                      toastLength: Toast.LENGTH_LONG,
                    ),
                    Navigator.pop(context),
                  }
                else if (myResult['res_code'] == 0)
                  {
                    debugPrint(myResult['res_msg'].toString()),
                    _isOldPasswordIncorrect = true,
                    setState(() {}),
                    Fluttertoast.showToast(
                      msg: "An error occured while trying to update the password",
                      toastLength: Toast.LENGTH_LONG,
                    ),
                  }
              })
          .catchError((Object error) => {
                debugPrint(error.toString()),
                Fluttertoast.showToast(
                  msg: "An error occured while trying to update password",
                  toastLength: Toast.LENGTH_LONG,
                ),
              })
          .whenComplete(() => {});
    } else {
      setState(() {});
    }
  }
}
