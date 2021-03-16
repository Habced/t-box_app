import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/top_app_bar.dart';
import 'package:tboxapp/models/juso.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/juso_service.dart' as jusoService;
import 'package:tboxapp/services/app_service.dart' as appService;

class UpdateAddressScreen extends StatefulWidget {
  @override
  UpdateAddressScreenState createState() => UpdateAddressScreenState();
}

class UpdateAddressScreenState extends State<UpdateAddressScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TextStyle myStyle = TextStyle(fontSize: 20.0, color: Colors.white);

  final _zipNoController = TextEditingController();
  final _jusoController = TextEditingController();
  final _detailJusoController = TextEditingController();
  bool _isJusoNotValid;
  bool _isDetailJusoNotFilled;
  bool _hasError;
  var _selectedJuso;
  var _toSaveJuso;

  final _searchJusoText = TextEditingController();

  Future<List<Juso>> futureJuso;

  @override
  void initState() {
    super.initState();
    _isJusoNotValid = false;
    _isDetailJusoNotFilled = false;
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
    final zipNoField = TextField(
      controller: _zipNoController,
      obscureText: false,
      style: myStyle,
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "Zip No.",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final jusoField = TextField(
      controller: _jusoController,
      obscureText: false,
      style: myStyle,
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "주소",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    final detailJusoField = TextField(
      controller: _detailJusoController,
      obscureText: false,
      style: myStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
        hintText: "상세 주소",
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
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
                  "주소 변경",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "변경할 주소를 입력해 주세요.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: zipNoField,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                          color: MyPrimaryYellowColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            _findJusos(context);
                          },
                          child: Text("주소 검색", style: TextStyle(color: Colors.black))),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                jusoField,
                _isJusoNotValid ? Text("주소를 입력해 주세요.", style: TextStyle(color: Colors.red)) : Container(),
                SizedBox(height: 15),
                detailJusoField,
                _isDetailJusoNotFilled ? Text("상세 주소를 입력해 주세요.", style: TextStyle(color: Colors.red)) : Container(),
                SizedBox(height: 30),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: FlatButton(
                      color: MyPrimaryYellowColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        _handleUpdateAddress();
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

  _findJusos(context) {
    final searchJusoField = TextField(
      controller: _searchJusoText,
      obscureText: false,
      style: TextStyle(fontSize: 14.0, color: Colors.white),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
          hintText: "지번 밎 도로명 주소",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (bc, state) {
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * .7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "주소검색",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "지번 및 도로명 주소로 검색이 가능합니다.",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      "(예시: 연수구 송도동 하모니로 35번길 2)",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 1),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: searchJusoField,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                              color: MyPrimaryYellowColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(new FocusNode());
                                futureJuso = jusoService.getJusos(_searchJusoText.text);
                              },
                              child: Text("주소 검색", style: TextStyle(color: Colors.black))),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 150,
                      child: FutureBuilder<List<Juso>>(
                        future: futureJuso,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: snapshot.data
                                    .map((e) => GestureDetector(
                                        onTap: () {
                                          updateSelectedJuso(state, e);
                                        },
                                        child: Text(e.jibunAddr)))
                                    .toList(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            Fluttertoast.showToast(
                              msg: "An error occured while retrieving addresses",
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "선택된 주소",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _selectedJuso == null
                        ? Container()
                        : Text(
                            _selectedJuso.jibunAddr,
                          ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                            color: MyPrimaryYellowColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              setState(() => {
                                    _toSaveJuso = _selectedJuso,
                                    _zipNoController.text = _toSaveJuso.zipNo,
                                    _jusoController.text = _toSaveJuso.jibunAddr,
                                    Navigator.pop(context),
                                  });
                            },
                            child: Text("저장", style: TextStyle(color: Colors.black))),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Future<Null> updateSelectedJuso(StateSetter updateState, newSelectedJuso) async {
    updateState(() {
      _selectedJuso = newSelectedJuso;
    });
  }

  _handleUpdateAddress() async {
    _hasError = false;

    if (_zipNoController.text == "") {
      _isJusoNotValid = true;
      _hasError = true;
    } else if (_jusoController.text == "") {
      _isJusoNotValid = true;
      _hasError = true;
    } else {
      _isJusoNotValid = false;
    }

    if (_detailJusoController.text == "") {
      _isDetailJusoNotFilled = true;
      _hasError = true;
    } else {
      _isDetailJusoNotFilled = false;
    }

    var myResult;
    if (!_hasError) {
      // convert4326to5179( _toSaveJuso['entX'], _toSaveJuso['entY'] );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      JusoCoor myJc = await jusoService.getJusoCoor(_toSaveJuso);
      appService
          .updateUserAddress(prefs.getInt('id'), _toSaveJuso, myJc, _detailJusoController.text)
          .then((result) => {
                myResult = result,
                if (myResult['res_code'] == 1)
                  {
                    prefs.setString('zipNo', _toSaveJuso.zipNo),
                    prefs.setString('jibunAddr', _toSaveJuso.jibunAddr),
                    prefs.setString('roadAddr', _toSaveJuso.roadAddr),
                    prefs.setString('detailJuso', _detailJusoController.text),
                    Fluttertoast.showToast(
                      msg: "Successfully saved the new address",
                      toastLength: Toast.LENGTH_LONG,
                    ),
                    Navigator.pop(context, true),
                  }
                else if (myResult['res_code'] == 0)
                  {
                    debugPrint(myResult['res_msg'].toString()),
                    Fluttertoast.showToast(
                      msg: "An error occured while trying to save address.",
                      toastLength: Toast.LENGTH_LONG,
                    ),
                  }
              })
          .catchError((Object error) => {
                debugPrint(error.toString()),
                Fluttertoast.showToast(
                  msg: "An error occured while trying to update Address",
                  toastLength: Toast.LENGTH_LONG,
                ),
              })
          .whenComplete(() => {});
    } else {
      setState(() {});
    }
  }
}
