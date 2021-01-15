import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/shared/global_vars.dart';

class ProfileMyScreen extends StatefulWidget {
  @override
  ProfileMyScreenState createState() => ProfileMyScreenState();
}

class ProfileMyScreenState extends State<ProfileMyScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  int _uid;
  String _ufullname;
  String _uemail;
  String _uusername;
  String _uphotoUrl;
  int _urole;
  String _ucellphone;
  String _uzipNo;
  String _ujibunAddr;
  String _uroadAddr;
  String _udetailJuso;
  bool _uloggedIn;

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => {
          _uid = prefs.getInt('id') ?? -1,
          _ufullname = prefs.getString('fullname') ?? "",
          _uemail = prefs.getString('email') ?? "",
          _uusername = prefs.getString('username') ?? "",
          _uphotoUrl = prefs.getString('photoUrl') ?? "",
          _urole = prefs.getInt('role') ?? "",
          _ucellphone = prefs.getString('cellphone') ?? "",
          _uzipNo = prefs.getString('zipNo') ?? "",
          _ujibunAddr = prefs.getString('jibunAddr') ?? "",
          _uroadAddr = prefs.getString('roadAddr') ?? "",
          _udetailJuso = prefs.getString('detailJuso') ?? "",
          _uloggedIn = prefs.getBool('loggedIn') ?? "",
        });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    // TODO GET PROFILE COVER BANNER
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
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TODO Banner Profile Image and Name
              _buildProfileTop(),
              // TODO get proper data
              _buildProfileRow("회원등급", "TODO", null),
              // // TODO get proper data
              _buildProfileRow("포인트", "TODO", null),
              _buildProfileRow("아이디", _uusername.toString(), null),
              _buildProfileRow("이메일", _uemail.toString(), null),
              // _buildProfileRow(
              //     "휴대폰 번호", _ucellphone.toString(), "/update_cellphone"),
              _buildProfileRow("휴대폰 번호", _ucellphone.toString(), null),
              _buildProfileRow("주소", _ujibunAddr.toString(), "/update_address"),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: FlatButton(
                            color: MyPrimaryYellowColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              // TODO Navigat to view points page
                            },
                            child: Text("포인트 내역보기",
                                style: TextStyle(color: Colors.black))),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: FlatButton(
                            color: MyPrimaryYellowColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              // TODO Navigat to view payments page
                            },
                            child: Text("결제 내역보기",
                                style: TextStyle(color: Colors.black))),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: FlatButton(
                            color: MyPrimaryYellowColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/membership_voucher');
                            },
                            child: Text("멤버십 등록",
                                style: TextStyle(color: Colors.black))),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: FlatButton(
                            color: MyPrimaryYellowColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              Navigator.pushNamed(context, "/update_password");
                            },
                            child: Text("비밀번호 변경",
                                style: TextStyle(color: Colors.black))),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/deactivate_account');
                      },
                      child: Text(
                        "회원 탈퇴",
                        style: TextStyle(color: Colors.red),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTop() {
    String myDefaultImage = "assets/images/default_profile_pic.png";
    String imgType = "unknown";
    if (_uphotoUrl.substring(_uphotoUrl.length - 4) == ".svg") {
      imgType = "svg";
    } else if (_uphotoUrl.substring(_uphotoUrl.length - 4) == ".png" ||
        _uphotoUrl.substring(_uphotoUrl.length - 4) == ".jpg" ||
        _uphotoUrl.substring(_uphotoUrl.length - 4) == "jpeg") {
      imgType = "file";
    }
    return Container(
      // decoration: ,
      child: Column(
        children: [
          Container(
            // width: MediaQuery.of(context).size.width,
            child: imgType == "file"
                ? CircleAvatar(
                    // backgroundImage: NetworkImage(_uphotoUrl),
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_uphotoUrl),
                      radius: 47.0,
                    ))
                : Image(image: AssetImage(myDefaultImage)),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: Color(0x35000000),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              _ufullname,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(category, data, editLink) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 2, child: Text(category)),
            Expanded(
              flex: 6,
              child: Align(alignment: Alignment.centerRight, child: Text(data)),
            ),
            editLink != null
                ? Expanded(
                    flex: 1,
                    child: Container(
                        height: 30,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.blue, width: 2),
                        // ),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.edit,
                            size: 15,
                          ),
                          onPressed: () async {
                            var received =
                                await Navigator.pushNamed(context, editLink);
                            if (received == true) {
                              getSharedPrefs();
                            }
                          },
                        )))
                : Container()
          ],
        ),
      ),
    );
  }
}
