import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tboxapp/models/banner.model.dart';
import 'package:tboxapp/models/faq.model.dart';
import 'package:tboxapp/models/inquiry.model.dart';
import 'package:tboxapp/models/newsfeed.model.dart';
import 'package:tboxapp/models/screen_data.model.dart';
import 'package:tboxapp/models/store.model.dart';
import 'package:tboxapp/models/user_points.model.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/models/vod_cate.model.dart';

// https://flutter.dev/docs/cookbook/networking/fetch-data

// For multipart form data
// https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
// var uriAuthority = 'http://req.tbox.media';
String uriAuthority = 'req.tbox.media';
String uriTbfAppUnencodedPath = '/kr/tbfapp/';
// TODO switch URL and API is done
// var url = uriAuthority + uriTbfAppUnencodedPath;
String url = "https://req.tbox.media/kr/tbfapp";
var myHeader = {'Content-Type': 'application/json'};

Future<dynamic> dupUsernameCheck(username) async {
  final response = await http.post('$url/dup_username_check/$username/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to load duplicate username data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> signup(fullname, email, username, password, cellphone) async {
  var body = jsonEncode({
    'fullname': fullname,
    'email': email,
    'username': username,
    'password': password,
    'cellphone': cellphone,
  });
  final response = await http.post('$url/register/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to load login data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> login(email, pw) async {
  var body = jsonEncode({'user': email, 'password': pw});

  final response = await http.post('$url/login/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to load login data');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));
  return extractedData;
}

Future<dynamic> logout(email) async {
  var body = jsonEncode({
    'email': email,
  });
  final response = await http.post('$url/logout/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to logout');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> sendUsernameEmail(fullname, email) async {
  var body = jsonEncode({'fullname': fullname, 'email': email});
  final response = await http.post('$url/send_username_email/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to send username data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> sendResetPasswordEmail(username, fullname, email) async {
  var body = jsonEncode({'username': username, 'fullname': fullname, 'email': email});
  final response = await http.post('$url/send_reset_pw_email/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to send password data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> updatePassword(userId, oldPw, newPw) async {
  var body = jsonEncode({'old_pw': oldPw, 'new_pw': newPw});
  final response = await http.post('$url/update_password/$userId/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to update password data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> updateUserCellphone(userId, cellphone) async {
  var body = jsonEncode({'cellphone': cellphone});
  final response = await http.put('$url/update_user_cellphone/$userId/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to update cellphone data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> updateUserAddress(userId, addr, coor, detailJuso) async {
  // CoordinateReferenceSystem
  var body = jsonEncode({
    'detBdNmList': addr.detBdNmList,
    'engAddr': addr.engAddr,
    'rn': addr.rn,
    'emdNm': addr.emdNm,
    'zipNo': addr.zipNo,
    'roadAddrPart2': addr.roadAddrPart2,
    'emdNo': addr.emdNo,
    'sggNm': addr.sggNm,
    'jibunAddr': addr.jibunAddr,
    'siNm': addr.siNm,
    'roadAddrPart1': addr.roadAddrPart1,
    'bdNm': addr.bdNm,
    'admCd': addr.admCd,
    'udrtYn': addr.udrtYn,
    'lnbrMnnm': addr.lnbrMnnm,
    'roadAddr': addr.roadAddr,
    'lnbrSlno': addr.lnbrSlno,
    'buldMnnm': addr.buldMnnm,
    'bdKdcd': addr.bdKdcd,
    'liNm': addr.liNm,
    'rnMgtSn': addr.rnMgtSn,
    'mtYn': addr.mtYn,
    'bdMgtSn': addr.bdMgtSn,
    'buldSlno': addr.buldSlno,
    'entX': coor.entX,
    'entY': coor.entY,
    'longitude': coor.longitude,
    'latitude': coor.latitude,
    'detail_juso': detailJuso,
  });
  final response = await http.put('$url/update_user_address/$userId/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to update address data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getAllBanner() async {
  final response = await http.get('$url/get_all_banner/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get all newsfeed');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getAllNewsFeed() async {
  final response = await http.get('$url/get_all_newsfeed/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get all newsfeed');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));
  List loadedNf = extractedData['results'];

  var myNfList = NewsfeedList(
    newsfeed: List<Newsfeed>(),
    totalUnread: extractedData['total_unread'],
  );

  for (var i in loadedNf) {
    myNfList.newsfeed.add(Newsfeed(
      id: i['id'],
      title: i['title'],
      body: i['body'],
      clickCount: i['click_count'],
      pin: i['pin'],
      hasRead: i['has_read'],
      createDate: i['create_date'],
      lastUpdate: i['last_update'],
    ));
  }

  return myNfList;
}

Future<NewsfeedList> getAllNewsFeedWoBody() async {
  final response = await http.get('$url/get_all_newsfeed_wo_body/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get all newsfeed wo body');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  var myNfList = NewsfeedList(
    newsfeed: List<Newsfeed>(),
    totalUnread: extractedData['total_unread'],
  );
  List loadedNf = extractedData['results'];

  for (var i in loadedNf) {
    myNfList.newsfeed.add(Newsfeed(
      id: i['id'],
      title: i['title'],
      body: "",
      clickCount: i['click_count'],
      pin: i['pin'],
      hasRead: i['has_read'],
      createDate: i['create_date'],
      lastUpdate: i['last_update'],
    ));
  }

  return myNfList;
}

Future<dynamic> getNewsfeedBody(nfId) async {
  final response = await http.get('$url/get_newsfeed_body/$nfId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get newsfeed body');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addNewsfeedClick(userId, nfId) async {
  var body = jsonEncode({
    'user_id': userId,
  });

  final response = await http.post('$url/add_newsfeed_click/$nfId/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add newsfeed click');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getTotalUnreadNewsfeed(userId) async {
  final response = await http.put('$url/get_total_unread_newsfeed/$userId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to add newsfeed pin');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<FaqList> getAllFaq() async {
  final response = await http.get('$url/get_all_faq/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get all faq');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));
  List loadedFaq = extractedData['results'];

  var myFaqList = FaqList(
    faq: List<Faq>(),
  );

  for (var i in loadedFaq) {
    myFaqList.faq.add(Faq(
      id: i['id'],
      question: i['question'],
      answer: i['answer'],
      clickCount: i['click_count'],
      createDate: i['create_date'],
      lastUpdate: i['last_update'],
    ));
  }

  return myFaqList;
}

Future<FaqList> getAllFaqWoAnswer() async {
  final response = await http.get('$url/get_all_faq_wo_answer/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get all faq wo answer');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  var myFaqList = FaqList(
    faq: List<Faq>(),
  );
  List loadedFaq = extractedData['results'];

  for (var i in loadedFaq) {
    myFaqList.faq.add(Faq(
      id: i['id'],
      question: i['question'],
      answer: "",
      clickCount: i['click_count'],
      createDate: i['create_date'],
      lastUpdate: i['last_update'],
    ));
  }

  return myFaqList;
}

Future<dynamic> getFaqAnswer(faqId) async {
  final response = await http.get('$url/get_faq_answer/$faqId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get faq body');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addFaqClick(userId, faqId) async {
  var body = jsonEncode({
    'user_id': userId,
  });
  final response = await http.post('$url/add_faq_click/$faqId/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add faq click');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addInquiry(userId, title, inquiry) async {
  var body = jsonEncode({
    'user_id': userId,
    'title': title,
    'inquiry': inquiry,
  });
  final response = await http.post('$url/add_inquiry/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add inquiry');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<List<Inquiry>> getInquiryByUser(userId, withReplies) async {
  var queryParam = {'with_replies': withReplies.toString()};

  var uri = new Uri.http(uriAuthority, uriTbfAppUnencodedPath + 'get_inquiry_by_user/$userId/', queryParam);

  // final response = await http.get(uri, headers: myHeader);
  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Failed to delete getInquiryByUser');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));
  // print(extractedData);
  List loadedInquiries = extractedData['results'];
  List<Inquiry> _inquiry = [];

  for (var i in loadedInquiries) {
    var tempInquiry = Inquiry(
      id: i['inquiry_id'],
      title: i['title'],
      inquiry: i['inquiry'],
      isExpanded: false,
      replies: [],
    );
    for (var j in i['replies']) {
      tempInquiry.replies.add(InquiryReply(
        userFullname: j['user_fullname'],
        replyId: j['reply_id'],
        reply: j['reply'],
        createDate: j['create_date'],
      ));
    }
    _inquiry.add(tempInquiry);
  }
  return _inquiry;
}

Future<List<PcScV>> getAllVod(limit) async {
  var response;
  if (limit == null) {
    response = await http.get('$url/get_all_vod/', headers: myHeader);
  } else {
    var queryParam = {'limit': limit.toString()};
    var uri = new Uri.http(uriAuthority, uriTbfAppUnencodedPath + 'get_all_vod/', queryParam);
    response = await http.get(uri);
  }

  if (response.statusCode != 200) {
    throw Exception('Failed to get all vod');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));
  List loadedPcSc = extractedData['cates'];
  List loadedV = extractedData['results'];
  List<PcScV> _pcScV = [];

  int skipAmount = 0;
  // Add the Primary Cates
  for (int i = 0; i < loadedPcSc.length; i++) {
    if (loadedPcSc[i]['primary_cate']['is_active'] == false) {
      skipAmount++;
      continue;
    }
    _pcScV.add(
      PcScV(
        pc: PrimaryCate(
          id: loadedPcSc[i]['primary_cate']['id'],
          title: loadedPcSc[i]['primary_cate']['title'],
          // img: 'https://i1.tbox.media/' + loadedPcSc[i]['primary_cate']['img'],
          isTboxCategory: loadedPcSc[i]['primary_cate']['tbfapp_pc_type'] == 2 ? true : false,
          isTcyclingCategory: loadedPcSc[i]['primary_cate']['tbfapp_pc_type'] == 1 ? true : false,
          isVisible: loadedPcSc[i]['primary_cate']['is_visible'],
          ordering: loadedPcSc[i]['primary_cate']['ordering'],
        ),
      ),
    );

    // Add the Secondary Cates into Primary Cates
    _pcScV[i - skipAmount].sc = [];
    for (var j = 0; j < loadedPcSc[i]['secondary_cates'].length; j++) {
      var myJ = loadedPcSc[i]['secondary_cates'][j];
      _pcScV[i - skipAmount].sc.add(
            SecondaryCateVods(
              sc: SecondaryCate(
                id: myJ['id'],
                primaryCateId: loadedPcSc[i]['primary_cate']['id'],
                title: myJ['title'],
                img: 'https://i1.tbox.media/' + myJ['img'],
                color: myJ['color'],
                isVisible: myJ['is_visible'],
                ordering: myJ['ordering'],
              ),
            ),
          );
      _pcScV[i - skipAmount].sc[j].vodList = [];
    }
  }

  // Add the Vods into secondary Cates
  for (var i in loadedV) {
    bool isFound = false;
    for (var pc in _pcScV) {
      for (var sc in pc.sc) {
        if (pc.pc.title == i['primary_cate_title'] && sc.sc.title == i['secondary_cate_title']) {
          isFound = true;
          sc.vodList.add(Vod(
            id: i['id'],
            title: i['title'],
            contents: i['contents'],
            vod: i['vod'],
            mrbg: i['mrbg'],
            thumbnail: 'https://i1.tbox.media/' + i['thumbnail'],
            pcType: i['tbfapp_pc_type'],
            pcTitle: i['primary_cate_title'],
            scTitle: i['secondary_cate_title'],
            levelId: i['level_id'],
            viewableTo: json.decode(i['viewable_to']),
            usingPoints: i['using_points'],
            earnablePoints: i['earnable_points'],
            earnableTimes: i['earnable_times'],
            sensingType: i['sensing_type'],
            sensingStartMin: i['sensing_start_min'],
            sensingStartSec: i['sensing_start_sec'],
            sensingEndMin: i['sensing_end_min'],
            sensingEndSec: i['sensing_end_sec'],
            pointGoal: i['point_goal'],
            pointSuccess: i['point_success'],
            // isFavorite: i['is_favorite'],
          ));
          break;
        }
      }
      if (isFound == true) {
        break;
      }
    }
  }

  return _pcScV;
}

Future<dynamic> getVodList(pcId, scId, limit) async {
  final Map<String, String> queryParam = {};
  if (pcId != null) {
    queryParam['primary_cate_id'] = pcId;
  } else if (scId != null) {
    queryParam['secondary_cate_id'] = scId;
  }
  if (limit != null) {
    queryParam['limit'] = limit;
  }

  var response;
  if (pcId == null && scId == null && limit == null) {
    response = await http.get(url + 'get_vod_list/', headers: myHeader);
  } else {
    var uri = new Uri.http(uriAuthority, uriTbfAppUnencodedPath + 'get_vod_list/', queryParam);
    response = await http.get(uri);
  }

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod list');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<Vod> getVod(vodId) async {
  final response = await http.get('$url/get_vod/$vodId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  return Vod(
    id: extractedData['results']['id'],
    title: extractedData['results']['title'],
    contents: extractedData['results']['contents'],
    vod: extractedData['results']['vod'],
    mrbg: extractedData['results']['mrbg'],
    thumbnail: extractedData['results']['thumbnail'],
    pcType: extractedData['results']['tbfapp_pc_type'],
    pcTitle: extractedData['results']['primary_cate_title'],
    scTitle: extractedData['results']['secondary_cate_title'],
    levelId: extractedData['results']['level_id'],
    viewableTo: json.decode(extractedData['results']['viewable_to']),
    usingPoints: extractedData['results']['using_points'],
    earnablePoints: extractedData['results']['earnable_points'],
    earnableTimes: extractedData['results']['earnable_times'],
    sensingType: extractedData['results']['sensing_type'],
    sensingStartMin: extractedData['results']['sensing_start_min'],
    sensingStartSec: extractedData['results']['sensing_start_sec'],
    sensingEndMin: extractedData['results']['sensing_end_min'],
    sensingEndSec: extractedData['results']['sensing_end_sec'],
    pointGoal: extractedData['results']['point_goal'],
    pointSuccess: extractedData['results']['point_success'],
    isFavorite: false,
  );
}

Future<Vod> getVodForUser(vodId, userId) async {
  final response = await http.get('$url/get_vod_for_user/$vodId/$userId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod for user.');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  return Vod(
    id: extractedData['results']['id'],
    title: extractedData['results']['title'],
    contents: extractedData['results']['contents'],
    vod: extractedData['results']['vod'],
    mrbg: extractedData['results']['mrbg'],
    thumbnail: extractedData['results']['thumbnail'],
    pcType: extractedData['results']['tbfapp_pc_type'],
    pcTitle: extractedData['results']['primary_cate_title'],
    scTitle: extractedData['results']['secondary_cate_title'],
    levelId: extractedData['results']['level_id'],
    viewableTo: json.decode(extractedData['results']['viewable_to']),
    usingPoints: extractedData['results']['using_points'],
    earnablePoints: extractedData['results']['earnable_points'],
    earnableTimes: extractedData['results']['earnable_times'],
    sensingType: extractedData['results']['sensing_type'],
    sensingStartMin: extractedData['results']['sensing_start_min'],
    sensingStartSec: extractedData['results']['sensing_start_sec'],
    sensingEndMin: extractedData['results']['sensing_end_min'],
    sensingEndSec: extractedData['results']['sensing_end_sec'],
    pointGoal: extractedData['results']['point_goal'],
    pointSuccess: extractedData['results']['point_success'],
    isFavorite: extractedData['results']['is_favorite'],
  );
}

Future<dynamic> addVodClick(vodId) async {
  final response = await http.post('$url/add_vod_click/$vodId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to add vod click');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addVodPlay(vodId, userId) async {
  var body = jsonEncode({
    'vod_id': vodId,
    'user_id': userId,
  });
  final response = await http.post('$url/add_vod_play/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add vod play.');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<List<VodShort>> getPlayedVods(userId) async {
  final response = await http.get('$url/get_played_vods/$userId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get played vods');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  List loadedVodShort = extractedData['results'];
  List<VodShort> _vods = [];

  for (var i in loadedVodShort) {
    var myVod = VodShort(
      id: i['id'],
      title: i['title'],
      contents: i['contents'],
      thumbnail: i['thumbnail'],
      pcTitle: i['primary_cate_title'],
      scTitle: i['secondary_cate_title'],
      timestamp: i['timestamp'],
    );
    myVod.isFavorite = i['is_favorite'];
    _vods.add(myVod);
  }
  print(_vods);
  return _vods;
}

Future<dynamic> addVodToFavorites(vodId, userId) async {
  var body = jsonEncode({
    'vod_id': vodId,
    'user_id': userId,
  });
  final response = await http.post('$url/add_vod_to_favorites/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add vod to favorites.');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> removeVodFromFavorites(vodId, userId) async {
  var body = jsonEncode({
    'vod_id': vodId,
    'user_id': userId,
  });
  final response = await http.post('$url/remove_vod_from_favorites/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to remove vod from favorites.');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<List<VodShort>> getVodInFavorites(userId) async {
  final response = await http.get('$url/get_vod_in_favorites/$userId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod in favorites');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  List loadedVodShort = extractedData['results'];
  List<VodShort> _vods = [];

  for (var i in loadedVodShort) {
    _vods.add(VodShort(
      id: i['id'],
      title: i['title'],
      contents: i['contents'],
      thumbnail: i['thumbnail'],
      pcTitle: i['primary_cate_title'],
      scTitle: i['secondary_cate_title'],
      timestamp: i['timestamp'],
    ));
  }
  return _vods;
}

Future<dynamic> getPurchasedMembershipVoucher(userId) async {
  final response = await http.get('$url/get_purchased_membership_voucher/$userId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to load StoreItem');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<List<StoreItem>> getAllStoreItem() async {
  final response = await http.get('$url/get_all_store_item/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to load StoreItem');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));
  // print(extractedData);
  List loadedStore = extractedData['results'];
  List<StoreItem> _storeItems = [];

  for (var i in loadedStore) {
    for (var j in i['results']) {
      _storeItems.add(StoreItem(
        cateId: i['store_cate_id'],
        cate: i['store_cate'],
        id: j['id'],
        name: j['name'],
        price: j['price'],
        onSale: j['onsale'],
        salePrice: j['sale_price'],
        mainImg: j['main_img'],
        naverStoreLink: j['naver_store'],
        interparkStoreLink: j['interpark_store'],
      ));
    }
  }
  return _storeItems;
}

Future<dynamic> addPointsGained(userId, label, amount) async {
  var body = jsonEncode({
    'user_id': userId,
    'label': label,
    'amount': amount,
  });
  final response = await http.post('$url/add_points_gained/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to load StoreItem');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addPointsUsage(userId, label, amount) async {
  var body = jsonEncode({
    'user_id': userId,
    'label': label,
    'amount': amount,
  });
  final response = await http.post('$url/add_points_usage/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to load StoreItem');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addPointsGainedThroughVod(userId, vodId) async {
  var body = jsonEncode({
    'user_id': userId,
    'vod_id': vodId,
  });
  final response = await http.post('$url/add_points_gained_through_vod/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to load StoreItem');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addPointsUsageThroughStore(userId, storeItemId) async {
  var body = jsonEncode({
    'user_id': userId,
    'store_item_id': storeItemId,
  });
  final response = await http.post('$url/add_points_usage_through_store/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to load StoreItem');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<UserPointsList> getPointsUsageByUser(userId) async {
  final response = await http.get('$url/get_point_usage_by_user/$userId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get point usage by user');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  List loadedUserPoint = extractedData['results'];
  List<UserPoints> _ups = [];

  for (var i in loadedUserPoint) {
    _ups.add(UserPoints(
      id: i['id'],
      amount: i['amount'],
      label: i['label'],
      createDate: i['create_date'],
      lastUpdate: i['last_update'],
    ));
  }

  UserPointsList _upl = UserPointsList(userPoints: _ups, totalPoints: extractedData['total_points']);
  return _upl;
}

Future<int> getTotalPointForUser(userId) async {
  final response = await http.get('$url/get_total_point_for_user/$userId/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get Total Point For User');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  return extractedData['total_points'];
}

Future<FrontPageData> getFrontPageData() async {
  final response = await http.get('$url/get_front_page_data/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get Front Page Data');
  }

  final extractedData = json.decode(utf8.decode(response.bodyBytes));

  var loadedFrontPageData = extractedData['results'];
  FrontPageData fpd = FrontPageData();

  for (var i in loadedFrontPageData['banners']) {
    fpd.banners.add(Banner(id: i['banner_id'], img: i['img']));
  }
  for (var i in loadedFrontPageData['latest_vods']) {
    fpd.lastestVods.add(VodMinimal(id: i['vod_id'], title: i['title'], thumbnail: i['thumbnail']));
  }
  for (var i in loadedFrontPageData['cate_vods']) {
    var plc = PcLatestVods(pc: PcShort(id: i['pc_id'], title: i['title']));
    for (var j in i['latest_vods']) {
      plc.vodList.add(VodMinimal(id: j['vod_id'], title: j['title'], thumbnail: j['thumbnail']));
    }
    fpd.pcLatestVods.add(plc);
  }
  return fpd;
}

Future<dynamic> addTrackingData(userId, dataCate, dataStr, dataInt) async {
  var body = jsonEncode({
    'user_id': userId,
    'data_category': dataCate,
    'data_str': dataStr,
    'data_int': dataInt,
  });
  final response = await http.post('$url/add_tracking_data/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add Tracking Data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getTrackingDataForUser(userId, dataCate) async {
  final Map<String, String> queryParam = {};
  if (dataCate != null) {
    queryParam['data_category'] = dataCate;
  }

  var response;
  if (dataCate == null) {
    response = await http.get('$url/get_tracking_data/', headers: myHeader);
  } else {
    var uri = new Uri.http(uriAuthority, uriTbfAppUnencodedPath + 'get_tracking_data/', queryParam);
    response = await http.get(uri);
  }

  if (response.statusCode != 200) {
    throw Exception('Failed to get Tracking Data For User');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getTrackingDataForUserShort(userId) async {
  var response = await http.get('$url/get_tracking_data/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get Tracking Data For User Short');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}
