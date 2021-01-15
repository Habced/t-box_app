import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tboxapp/models/juso.model.dart';
import 'package:tboxapp/shared/utils.dart';

var jusoApiUrl = 'https://www.juso.go.kr/addrlink/addrLinkApi.do';
var myConfmKey = 'U01TX0FVVEgyMDE5MDMyNTE2NDExNTEwODYwMTQ=';
var myResultType = 'json';

// With Coordinates Version
var jusoCoorUrl = 'https://www.juso.go.kr/addrlink/addrCoordApi.do';
var myCoorConfmKey = 'U01TX0FVVEgyMDE5MDQwOTE0MzgyNzEwODYzNzI=';
var myCoorResultType = 'json';

Future<List<Juso>> getJusos(jusoKeyword) async {
  final response = await http.get(jusoApiUrl +
      '?confmKey=' +
      myConfmKey +
      '&resultType=' +
      myResultType +
      '&keyword=' +
      jusoKeyword);

  if (response.statusCode != 200) {
    throw Exception('Failed to load login data');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  List loadedJuso = extractedData['results']['juso'];
  List<Juso> _jusoItems = [];

  for (var i in loadedJuso) {
    _jusoItems.add(Juso(
      roadAddr: i['roadAddr'],
      roadAddrPart1: i['roadAddrPart1'],
      roadAddrPart2: i['roadAddrPart2'],
      jibunAddr: i['jibunAddr'],
      engAddr: i['engAddr'],
      zipNo: i['zipNo'],
      admCd: i['admCd'],
      rnMgtSn: i['rnMgtSn'],
      bdMgtSn: i['bdMgtSn'],
      detBdNmList: i['detBdNmList'],
      bdNm: i['bdNm'],
      bdKdcd: i['bdKdcd'],
      siNm: i['siNm'],
      sggNm: i['sggNm'],
      emdNm: i['emdNm'],
      liNm: i['liNm'],
      rn: i['rn'],
      udrtYn: i['udrtYn'],
      buldMnnm: i['buldMnnm'],
      buldSlno: i['buldSlno'],
      mtYn: i['mtYn'],
      lnbrMnnm: i['lnbrMnnm'],
      lnbrSlno: i['lnbrSlno'],
      emdNo: i['emdNo'],
    ));
  }

  return _jusoItems;
}

Future<JusoCoor> getJusoCoor(juso) async {
  final response = await http.get(jusoCoorUrl +
      '?confmKey=' +
      myCoorConfmKey +
      '&resultType=' +
      myCoorResultType +
      '&admCd=' +
      juso.admCd +
      '&rnMgtSn=' +
      juso.rnMgtSn +
      '&udrtYn=' +
      juso.udrtYn +
      '&buldMnnm=' +
      juso.buldMnnm +
      '&buldSlno=' +
      juso.buldSlno +
      '&resultType=' +
      myCoorResultType);

  if (response.statusCode != 200) {
    throw Exception('Failed to load login data');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  List loadedJuso = extractedData['results']['juso'];

  var ll = convert4326to5179(
      double.parse(loadedJuso[0]['entX']), double.parse(loadedJuso[0]['entY']));

  JusoCoor jc = JusoCoor(
    entX: loadedJuso[0]['entX'],
    entY: loadedJuso[0]['entY'],
    longitude: ll.x.toString(),
    latitude: ll.y.toString(),
  );

  return jc;
}
