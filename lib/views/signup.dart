import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TextStyle myStyle = TextStyle(
      /*fontFamily: 'Montserrat',*/ fontSize: 20.0,
      color: Colors.white);

  final _nameController = TextEditingController();
  bool _isNameNotFilledOut;
  final _emailController = TextEditingController();
  bool _isEmailNotFilledOut;
  bool _isEmailNotEmail;
  final _idController = TextEditingController();
  String _idButtonText = "중복 확인";
  bool _isIdNotFilledOut;
  bool _isIdNotValid;
  bool _isNeedingIdCheck; // to show the error
  bool _isIdAvailable; // user has clicked button and everything okay
  bool _isNeedingNewId; // to show the error if id isn't available
  String _checkedIdText;
  final _passwordController = TextEditingController();
  bool _isPasswordNotFilledOut;
  bool _isPasswordNotValid;
  final _passwordCheckController = TextEditingController();
  bool _isPasswordCheckNotFilledOut;
  bool _isPasswordNotMatch;
  bool _isCheckedTos; // The actual value
  bool _isNeedingTosCheck; // To show error message
  final _cellphoneOneController = TextEditingController();
  final _cellphoneTwoController = TextEditingController();
  final _cellphoneThreeController = TextEditingController();
  bool _isCellphoneNotFilled;
  bool _isCellphoneNotValid;

  @override
  void initState() {
    super.initState();
    _isNameNotFilledOut = false;
    _isEmailNotFilledOut = false;
    _isEmailNotEmail = false;
    _isIdNotFilledOut = false;
    _isIdNotValid = false;
    _isNeedingIdCheck = false;
    _isIdAvailable = false;
    _isNeedingNewId = false;
    _checkedIdText = "";
    _isPasswordNotFilledOut = false;
    _isPasswordNotValid = false;
    _isPasswordCheckNotFilledOut = false;
    _isPasswordNotMatch = false;
    _isCellphoneNotFilled = false;
    _isCellphoneNotValid = false;
    _isCheckedTos = false;
    _isNeedingTosCheck = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: buildFullAppBar(context),
        // endDrawer: EndDrawerWidget(),
        body: WillPopScope(
            child: _buildBody(),
            onWillPop: () {
              if (_globalKey.currentState.isDrawerOpen) {
                Navigator.pop(context);
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            }));
  }

  Widget _buildBody() {
    final explanationField = Column(
      children: [
        Container(
          width: 400,
          padding: EdgeInsets.symmetric(vertical: 22),
          decoration: DottedDecoration(color: MyPrimaryYellowColor, dash: <int>[4, 2]),
          child: Center(
            child: Text("회원가입", style: TextStyle(fontSize: 24)),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Image.asset('assets/images/banner_signup.jpg'),
      ],
    );
    final nameField = TextField(
      controller: _nameController,
      obscureText: false,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*이름",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final emailField = TextField(
      controller: _emailController,
      obscureText: false,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*이메일",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final idField = TextField(
      controller: _idController,
      obscureText: false,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*아이디",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final checkIdButton = FlatButton(
      color: Color(0xFFECEEF0),
      onPressed: () {
        if (_idButtonText == "중복 확인") {
          _handleCheckId();
        } else {
          // Do nothing
        }
      },
      child: Text(
        _idButtonText,
        style: TextStyle(color: Colors.black),
      ),
    );
    final passwordField = TextField(
      controller: _passwordController,
      obscureText: true,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*비밀번호",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final passwordConfirmField = TextField(
      controller: _passwordCheckController,
      obscureText: true,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*비밀번호 확인",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final cellphoneFieldOne = TextField(
      controller: _cellphoneOneController,
      obscureText: false,
      style: myStyle,
      maxLength: 3,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "*핸드폰",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final cellphoneFieldTwo = TextField(
      controller: _cellphoneTwoController,
      obscureText: false,
      style: myStyle,
      maxLength: 4,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "XXXX",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final cellphoneFieldThree = TextField(
      controller: _cellphoneThreeController,
      obscureText: false,
      style: myStyle,
      maxLength: 4,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "XXXX",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final agreeTosCheckbox = Row(
      children: [
        Expanded(
          flex: 1,
          child: Checkbox(
            value: _isCheckedTos,
            onChanged: (newValue) {
              setState(() {
                _isCheckedTos = newValue;
              });
            },
          ),
        ),
        Expanded(
          flex: 11,
          child: RichText(
              text: TextSpan(style: TextStyle(fontWeight: FontWeight.bold), children: <TextSpan>[
            TextSpan(text: '본인은 T-BOX MEDIA 서비스 약관, 개인정보 보호 정책 및 회원 약관 '),
            TextSpan(
                text: '사이트이용약관',
                style: TextStyle(color: MyPrimaryYellowColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // TODO Implement navigate to TOS page
                    debugPrint("사이트이용약관 was tapped");
                  }),
            TextSpan(text: ', '),
            TextSpan(
                text: '개인정보처리방침',
                style: TextStyle(color: MyPrimaryYellowColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // TODO Implement navigate to TOS page
                    debugPrint("개인정보처리방침 was tapped");
                  }),
            TextSpan(text: ', '),
            TextSpan(
                text: '멤버십약관',
                style: TextStyle(color: MyPrimaryYellowColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // TODO Implement navigate to TOS page
                    debugPrint("멤버십약관 was tapped");
                  }),
            TextSpan(text: ' 을 읽고 동의 함을 확인합니다.'),
          ])),
        )
      ],
    );
    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: MyPrimaryYellowColor.withOpacity(0.8),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        onPressed: () {
          _handleSignup();
        },
        child: Text("회원가입",
            textAlign: TextAlign.center, style: myStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return SizedBox.expand(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_logo_white.jpg'),
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
                      explanationField,
                      SizedBox(height: 25),
                      nameField,
                      _isNameNotFilledOut ? Text("이름을 입력해 주세요.", style: TextStyle(color: Colors.red)) : Container(),
                      SizedBox(height: 25.0),
                      emailField,
                      _isEmailNotFilledOut ? Text("이메일을 입력해 주세요.", style: TextStyle(color: Colors.red)) : Container(),
                      (_isEmailNotFilledOut == false && _isEmailNotEmail)
                          ? Text("유효한 이메일을 입력해 주세요.", style: TextStyle(color: Colors.red))
                          : Container(),
                      SizedBox(height: 25.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: idField,
                          ),
                          Expanded(
                            flex: 3,
                            child: checkIdButton,
                          )
                        ],
                      ),
                      _isIdNotFilledOut ? Text("아이디를 입력해 주세요.", style: TextStyle(color: Colors.red)) : Container(),
                      _isIdNotValid ? Text("아이디가 너무 짧습니다.", style: TextStyle(color: Colors.red)) : Container(),
                      _isNeedingIdCheck ? Text("아이디 중복 확인 해주세요.", style: TextStyle(color: Colors.red)) : Container(),
                      _isNeedingNewId
                          ? Text("이미 사용중인 아이디 입니다. 다른 아이디를 입력해 주세요.", style: TextStyle(color: Colors.red))
                          : Container(),
                      _isIdAvailable ? Text("사용 가능한 아이디 입니다.", style: TextStyle(color: Colors.green)) : Container(),
                      SizedBox(height: 25.0),
                      passwordField,
                      _isPasswordNotFilledOut
                          ? Text("비밀번호를 입력해 주세요.", style: TextStyle(color: Colors.red))
                          : Container(),
                      _isPasswordNotValid
                          ? Text("비밀번호는 여섯자리 이상이어야 합니다.", style: TextStyle(color: Colors.red))
                          : Container(),
                      SizedBox(height: 25.0),
                      passwordConfirmField,
                      _isPasswordCheckNotFilledOut
                          ? Text("비밀번호를 다시한번 입력해 주세요.", style: TextStyle(color: Colors.red))
                          : Container(),
                      _isPasswordNotMatch ? Text("비밀번호가 일치하지 않습니다.", style: TextStyle(color: Colors.red)) : Container(),
                      SizedBox(height: 25.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: cellphoneFieldOne,
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(child: Text("-")),
                          ),
                          Expanded(
                            flex: 3,
                            child: cellphoneFieldTwo,
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(child: Text("-")),
                          ),
                          Expanded(
                            flex: 3,
                            child: cellphoneFieldThree,
                          ),
                        ],
                      ),
                      _isCellphoneNotFilled
                          ? Text("휴대폰 번호를 입력해 주세요.", style: TextStyle(color: Colors.red))
                          : Container(),
                      _isCellphoneNotValid
                          ? Text("휴대폰 번호의 형식이 잘못되었습니다.", style: TextStyle(color: Colors.red))
                          : Container(),
                      SizedBox(height: 25.0),
                      agreeTosCheckbox,
                      _isNeedingTosCheck ? Text("약관에 동의해야 합니다.", style: TextStyle(color: Colors.red)) : Container(),
                      SizedBox(height: 25.0),
                      signupButton,
                      SizedBox(
                        width: 115,
                        child: FlatButton(
                          minWidth: 50,
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "/login");
                          },
                          child: Text("로그인"),
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    );
  }

  _handleCheckId() {
    setState(() {
      _idButtonText = "확인중 ...";
    });
    var hasError = false;
    _isIdAvailable = false;
    _isNeedingNewId = false;
    if (_idController.text == "") {
      _isIdNotFilledOut = true;
      _isIdNotValid = false;
      _isNeedingIdCheck = false;
      hasError = true;
    } else if (_idController.text.length < 6) {
      _isIdNotFilledOut = false;
      _isIdNotValid = true;
      _isNeedingIdCheck = false;
      hasError = true;
    } else {
      _isIdNotFilledOut = false;
      _isIdNotValid = false;
      _isNeedingIdCheck = false;
    }
    if (hasError == false) {
      var myResult;
      appService
          .dupUsernameCheck(_idController.text)
          .then((result) => {
                myResult = result,
              })
          .catchError((Object error) => {
                debugPrint(error.toString()),
              })
          .whenComplete(() => {
                if (myResult['res_code'] == 1)
                  {
                    _checkedIdText = _idController.text,
                    _isNeedingNewId = false,
                    _isIdAvailable = true,
                  }
                else if (myResult['res_code'] == 2)
                  {
                    _isNeedingNewId = true,
                    _isIdAvailable = false,
                  },
                setState(() {
                  _idButtonText = "중복 확인";
                })
              });
    } else {
      setState(() {
        _idButtonText = "중복 확인";
      });
    }
  }

  _handleSignup() async {
    bool hasError = false;

    if (_nameController.text == "") {
      _isNameNotFilledOut = true;
      hasError = true;
    } else {
      _isNameNotFilledOut = false;
    }

    if (_emailController.text == "") {
      _isEmailNotFilledOut = true;
      _isEmailNotEmail = false;
      hasError = true;
    } else if (!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text))) {
      _isEmailNotFilledOut = false;
      _isEmailNotEmail = true;
      hasError = true;
    } else {
      _isEmailNotFilledOut = false;
      _isEmailNotEmail = false;
    }

    if (_idController.text == "") {
      _isIdNotFilledOut = true;
      _isIdNotValid = false;
      _isNeedingIdCheck = false;
      hasError = true;
    } else if (_idController.text.length < 6) {
      _isIdNotFilledOut = false;
      _isIdNotValid = true;
      _isNeedingIdCheck = false;
      hasError = true;
    } else if (_idController.text != _checkedIdText) {
      _isIdNotFilledOut = false;
      _isIdNotValid = false;
      _isNeedingIdCheck = true;
      hasError = true;
    } else {
      _isIdNotFilledOut = false;
      _isIdNotValid = false;
      _isNeedingIdCheck = false;
    }

    if (_isIdAvailable == false) {
      hasError = true;
    }

    if (_passwordController.text == "") {
      _isPasswordNotFilledOut = true;
      _isPasswordNotValid = false;
      hasError = true;
    } else if (_passwordController.text.length < 6) {
      _isPasswordNotFilledOut = false;
      _isPasswordNotValid = true;
      hasError = true;
    } else {
      _isPasswordNotFilledOut = false;
      _isPasswordNotValid = false;
    }

    if (_passwordCheckController.text == "") {
      _isPasswordCheckNotFilledOut = true;
      _isPasswordNotMatch = false;
      hasError = true;
    } else if (_passwordController.text != _passwordCheckController.text) {
      _isPasswordCheckNotFilledOut = false;
      _isPasswordNotMatch = true;
      hasError = true;
    } else {
      _isPasswordCheckNotFilledOut = false;
      _isPasswordNotMatch = false;
    }

    if (_cellphoneOneController.text == "" ||
        _cellphoneTwoController.text == "" ||
        _cellphoneThreeController.text == "") {
      _isCellphoneNotFilled = true;
      _isCellphoneNotValid = false;
      hasError = true;
    } else if (!(RegExp(r"^[0-9]{3}").hasMatch(_cellphoneOneController.text)) ||
        !(RegExp(r"^[0-9]{4}").hasMatch(_cellphoneTwoController.text)) ||
        !(RegExp(r"^[0-9]{4}").hasMatch(_cellphoneThreeController.text))) {
      _isCellphoneNotFilled = false;
      _isCellphoneNotValid = true;
      hasError = true;
    } else {
      _isCellphoneNotFilled = false;
      _isCellphoneNotValid = false;
    }

    if (_isCheckedTos == false) {
      _isNeedingTosCheck = true;
      hasError = true;
    } else {
      _isNeedingTosCheck = false;
    }

    var myResult;
    if (!hasError) {
      appService
          .signup(_nameController.text, _emailController.text, _idController.text, _passwordController.text,
              _cellphoneOneController.text + _cellphoneTwoController.text + _cellphoneThreeController.text)
          .then((result) => {
                myResult = result,
              })
          .catchError((Object error) => {
                debugPrint(error.toString()),
                Fluttertoast.showToast(
                  msg: "An error occured while trying to signup",
                  toastLength: Toast.LENGTH_LONG,
                ),
              })
          .whenComplete(() => {
                if (myResult['res_code'] == 1)
                  {
                    _saveUserInfo(
                      myResult['user_id'],
                      _nameController.text,
                      _emailController.text,
                      _idController.text,
                      _cellphoneOneController.text + _cellphoneTwoController.text + _cellphoneThreeController.text,
                    ),
                    Navigator.of(context).popUntil((route) => route.isFirst),
                  }
                else if (myResult['res_code'] == 2)
                  {
                    Fluttertoast.showToast(
                      msg: "사용중인 이메일 입니다.",
                      toastLength: Toast.LENGTH_LONG,
                    ),
                  }
                else
                  {
                    debugPrint(myResult['res_msg'].toString()),
                    Fluttertoast.showToast(
                      msg: "An error occured while trying to signup",
                      toastLength: Toast.LENGTH_LONG,
                    ),
                  },
              });
    } else {
      setState(() {
        debugPrint("resetting state");
      });
    }
  }

  _saveUserInfo(id, fullname, email, username, cellphone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    prefs.setString('fullname', fullname);
    prefs.setString('email', email);
    prefs.setString('username', username);
    prefs.setString('cellphone', cellphone);
    prefs.setInt('role', 2);
    prefs.setString('photoUrl', "https://i1.tbox.media/tempimage/defpf.svg");
    prefs.setString('zipNo', "");
    prefs.setString('jibunAddr', "");
    prefs.setString('roadAddr', "");
    prefs.setString('detailJuso', "");
    prefs.setBool('loggedIn', true);
  }
}
