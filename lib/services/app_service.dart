import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tboxapp/models/faq.model.dart';
import 'package:tboxapp/models/inquiry.model.dart';
import 'package:tboxapp/models/newsfeed.model.dart';
import 'package:tboxapp/models/store.model.dart';

// https://flutter.dev/docs/cookbook/networking/fetch-data

// For multipart form data
// https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
// var uriAuthority = 'http://req.tbox.media';
var uriAuthority = 'req.tbox.media';
var uriTbfAppUnencodedPath = '/kr/tbfapp/';
// TODO switch URL and API is done
// var url = uriAuthority + uriTbfAppUnencodedPath;
var url = "https://req.tbox.media/kr/tbfapp/";
var myHeader = {'Content-Type': 'application/json'};

Future<dynamic> dupUsernameCheck(username) async {
  final response = await http.post(
    url + 'dup_username_check/$username/',
    headers: myHeader,
  );

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
  final response = await http.post(url + 'register/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to load login data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> login(email, pw) async {
  var body = jsonEncode({'user': email, 'password': pw});

  final response = await http.post(url + 'login/', headers: myHeader, body: body);

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
  final response = await http.post(url + 'logout/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to logout');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> sendUsernameEmail(fullname, email) async {
  var body = jsonEncode({'fullname': fullname, 'email': email});
  final response = await http.post(url + 'send_username_email/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to send username data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> sendResetPasswordEmail(username, fullname, email) async {
  var body = jsonEncode({'username': username, 'fullname': fullname, 'email': email});
  final response = await http.post(url + 'send_reset_pw_email/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to send password data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> updatePassword(userId, oldPw, newPw) async {
  var body = jsonEncode({'old_pw': oldPw, 'new_pw': newPw});
  final response = await http.post(url + 'update_password/' + userId.toString() + '/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to update password data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> updateUserCellphone(userId, cellphone) async {
  var body = jsonEncode({'cellphone': cellphone});
  final response =
      await http.put(url + 'update_user_cellphone/' + userId.toString() + '/', headers: myHeader, body: body);

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
  final response =
      await http.put(url + 'update_user_address/' + userId.toString() + '/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to update address data');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getAllBanner() async {
  final response = await http.get(
    url + 'get_all_banner/',
    headers: myHeader,
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to get all newsfeed');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getAllNewsFeed() async {
  final response = await http.get(
    url + 'get_all_newsfeed/',
    headers: myHeader,
  );

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
  final response = await http.get(
    url + 'get_all_newsfeed_wo_body/',
    headers: myHeader,
  );

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
  final response = await http.get(url + 'get_newsfeed_body/' + nfId.toString() + '/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get newsfeed body');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addNewsfeedClick(userId, nfId) async {
  var body = jsonEncode({
    'user_id': userId,
  });
  final response = await http.put(url + 'add_newsfeed_click/' + nfId.toString() + '/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add newsfeed click');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getTotalUnreadNewsfeed(userId) async {
  final response = await http.put(
    url + 'get_total_unread_newsfeed/' + userId.toString() + '/',
    headers: myHeader,
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add newsfeed pin');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<FaqList> getAllFaq() async {
  final response = await http.get(url + 'get_all_faq/', headers: myHeader);

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
  final response = await http.get(
    url + 'get_all_faq_wo_answer/',
    headers: myHeader,
  );

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
  final response = await http.get(url + 'get_faq_answer/' + faqId.toString() + '/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get faq body');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addFaqClick(userId, faqId) async {
  var body = jsonEncode({
    'user_id': userId,
  });
  final response = await http.post(url + 'add_faq_click/' + faqId.toString() + '/', headers: myHeader, body: body);

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
  final response = await http.post(url + 'add_inquiry/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add inquiry');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<List<Inquiry>> getInquiryByUser(userId, withReplies) async {
  var queryParam = {'with_replies': withReplies.toString()};
  print(uriTbfAppUnencodedPath.toString() + 'get_inquiry_by_user/' + userId.toString() + '/');
  var uri = new Uri.http(uriAuthority.toString(),
      uriTbfAppUnencodedPath.toString() + 'get_inquiry_by_user/' + userId.toString() + '/', queryParam);

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

Future<List<StoreItem>> getAllStoreItem() async {
  final response =
      // await http.get(url + 'get_all_store_item/', headers: myHeader);
      await http.get('https://req.tbox.media/kr/' + 'get_all_store_item/', headers: myHeader);

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

Future<dynamic> getAllVod(limit) async {
  var response;
  if (limit == null) {
    response = await http.get(url + 'get_all_vod/', headers: myHeader);
  } else {
    var queryParam = {'limit': limit.toString()};
    var uri = new Uri.http(uriAuthority.toString(), uriTbfAppUnencodedPath.toString() + 'get_all_vod/', queryParam);
    response = await http.get(uri);
  }

  if (response.statusCode != 200) {
    throw Exception('Failed to get all vod');
  }

  return json.decode(utf8.decode(response.bodyBytes));
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
    var uri = new Uri.http(uriAuthority.toString(), uriTbfAppUnencodedPath.toString() + 'get_vod_list/', queryParam);
    response = await http.get(uri);
  }

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod list');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getVod(vodId) async {
  final response = await http.get(url + 'get_vod/' + vodId.toString() + '/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getVodForUser(vodId, userId) async {
  final response =
      await http.get(url + 'get_vod_for_user/' + vodId.toString() + '/' + userId.toString() + '/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod for user.');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addVodClick(vodId) async {
  final response = await http.post(url + 'add_vod_click/' + vodId + '/', headers: myHeader);

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
  final response = await http.post(url + 'add_vod_play/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to add vod play.');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getPlayedVods(userId) async {
  final response = await http.get(url + 'get_played_vods/' + userId.toString() + '/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get played vods');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> addVodToFavorites(vodId, userId) async {
  var body = jsonEncode({
    'vod_id': vodId,
    'user_id': userId,
  });
  final response = await http.post(url + 'add_vod_to_favorites/', headers: myHeader, body: body);

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
  final response = await http.post(url + 'remove_vod_from_favorites/', headers: myHeader, body: body);

  if (response.statusCode != 200) {
    throw Exception('Failed to remove vod from favorites.');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}

Future<dynamic> getVodInFavorites(userId) async {
  final response = await http.get(url + 'get_vod_in_favorites/' + userId.toString() + '/', headers: myHeader);

  if (response.statusCode != 200) {
    throw Exception('Failed to get vod in favorites');
  }

  return json.decode(utf8.decode(response.bodyBytes));
}
