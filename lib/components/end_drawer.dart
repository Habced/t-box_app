import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tboxapp/services/tbox_service.dart' as tbService;

class EndDrawerWidget extends StatefulWidget {
  @override
  EndDrawerWidgetState createState() => EndDrawerWidgetState();
}

class EndDrawerWidgetState extends State<EndDrawerWidget> {
  var myListTextStyle = TextStyle(color: Color(0xFF757575), fontSize: 20);

  int _uid;
  String _uemail;
  String _uphotoUrl;
  String _ufullname;

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = prefs.getInt('id') ?? -1;
      _uemail = prefs.getString('email') ?? "";
      _uphotoUrl = prefs.getString('photoUrl') ?? "";
      _ufullname = prefs.getString('fullname') ?? "";
    });
    debugPrint(prefs.getInt('id').toString());
  }

  @override
  void initState() {
    super.initState();
    _uid = -1;
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    var membershipBtn = GestureDetector(
      onTap: () {
        Navigator.popAndPushNamed(context, '/TODO');
      },
      child: Column(
        children: [
          Container(
            height: 30,
            child: Image.asset(
              'assets/images/membership_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          Text("멤버십", style: myListTextStyle)
        ],
      ),
    );

    var loginBtn = GestureDetector(
      onTap: () {
        Navigator.popAndPushNamed(context, '/login');
      },
      child: Column(
        children: [
          Container(
            height: 30,
            width: 40,
            child: Image.asset(
              'assets/images/login_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          Text("로그인", style: myListTextStyle)
        ],
      ),
    );

    var logoutBtn = GestureDetector(
      onTap: () {
        handleLogout();
      },
      child: Column(
        children: [
          Container(
            height: 30,
            width: 40,
            child: Image.asset(
              'assets/images/logout_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          Text("로그아웃", style: myListTextStyle)
        ],
      ),
    );

    return Drawer(
      child: Stack(
        children: [
          Container(
            color: Color(0xFFF0F0F0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ClipRect(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 7.0),
                    child: DrawerHeader(
                      child: _uid == -1 ? _buildDrawerHeaderLogo() : _buildDrawerHeaderProfile(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg_logo_yellow.jpg'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE5E5E5),
                            blurRadius: 7,
                            spreadRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [membershipBtn, _uid == -1 ? loginBtn : logoutBtn],
                ),
                // _buildListTile(context, "설정", "/setting"),
                // _buildDivider(),
                _uid != -1 ? _buildListTile(context, "프로필", "/profile_my") : Container(),
                _uid != -1 ? _buildDivider() : Container(),
                _buildListTile(context, "공지사항", "/newsfeed"),
                _buildDivider(),
                _buildListTile(context, "FAQ", "/faq"),
                _buildDivider(),
                _buildListTile(context, "1:1 문의", "/qna"),
                _buildDivider(),
                _buildListTile(context, "스토어", "/store"),
                _buildDivider(),
              ],
            ),
          ),
          // _uid != -1 ? _buildLogout() : Container(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeaderLogo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Image(
        image: AssetImage('assets/images/logo.png'),
        fit: BoxFit.fitWidth,
        width: 10,
      ),
    );
  }

  Widget _buildDrawerHeaderProfile() {
    String myDefaultImage = "assets/images/default_profile_pic.png";
    String imgType = "unknown";
    if (_uphotoUrl.substring(_uphotoUrl.length - 4) == ".svg") {
      imgType = "svg";
    } else if (_uphotoUrl.substring(_uphotoUrl.length - 4) == ".png" ||
        _uphotoUrl.substring(_uphotoUrl.length - 4) == ".jpg" ||
        _uphotoUrl.substring(_uphotoUrl.length - 4) == "jpeg") {
      imgType = "file";
    }
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imgType == "file"
              ? CircleAvatar(
                  // backgroundImage: NetworkImage(_uphotoUrl),
                  backgroundColor: Colors.white,
                  radius: 50.0,
                  child: CircleAvatar(backgroundImage: NetworkImage(_uphotoUrl), radius: 47.0),
                )
              : Container(),
          imgType == "svg" ? Image(image: AssetImage(myDefaultImage)) : Container(),
          imgType == "unknown" ? Image(image: AssetImage(myDefaultImage)) : Container(),
          SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: "$_ufullname ",
                    style: TextStyle(fontSize: 22),
                    children: <TextSpan>[
                      TextSpan(text: "님", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ), //님"),
                Text(
                  _uemail,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(fontSize: 13, color: Color(0xFFB4B4B4)),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFFFFFF),
                      radius: 8,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF927721),
                        radius: 7,
                        child: Text("G", style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ),
                    SizedBox(width: 10),
                    // TODO implment getting role name
                    // TODO remove temp place holder
                    Text("XXXXXX", style: TextStyle(color: Color(0xFFB4B4B4)))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFFFFFF),
                      radius: 8,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFAD2F2F),
                        radius: 7,
                        child: Text("P", style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ),
                    SizedBox(width: 10),
                    // TODO implment getting role name
                    // TODO remove temp place holder
                    Text("XX,XXX pt", style: TextStyle(color: Color(0xFFB4B4B4)))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildLogout() => Align(
  //     alignment: Alignment.bottomRight,
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(10, 10, 15, 20),
  //       child: Material(
  //         type: MaterialType.transparency,
  //         child: InkWell(
  //           splashColor: Color(0xFF757575),
  //           onTap: () {
  //             handleLogout();
  //           },
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(
  //                 Icons.exit_to_app,
  //                 color: Color(0xFF757575),
  //               ),
  //               Text("로그아웃", style: myListTextStyle)
  //             ],
  //           ),
  //         ),
  //       ),
  //     ));

  Widget _buildDivider() {
    return Divider(
      color: Color(0xFFD0D0D0),
      indent: 10,
      endIndent: 20,
    );
  }

  Widget _buildListTile(cntx, name, route) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Color(0xFF757575),
        onTap: () {
          Navigator.popAndPushNamed(cntx, route);
        },
        child: ListTile(
          title: Text(name, style: myListTextStyle),
        ),
      ),
    );
  }

  void handleLogout() async {
    // TODO implement logout
    // var myResult;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // tbService
    //     .logout(_uemail)
    //     .then((result) => {
    //           myResult = result,
    //         })
    //     .catchError((Object error) => {})
    //     .whenComplete(() => {
    //           if (myResult['res_code'] == 1)
    //             {
    //               prefs.clear(),
    //               setState(() => {_uid = -1, _uemail = "", _uphotoUrl = ""}),
    //               Navigator.popAndPushNamed(context, '/'),
    //             }
    //           else
    //             {
    //               // TODO implement some sort of error handling
    //             }
    //         });
  }
}
