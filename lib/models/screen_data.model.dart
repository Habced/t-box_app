import 'package:tboxapp/models/banner.model.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/models/vod_cate.model.dart';

class FrontPageData {
  // List<Banner> banners;
  Vod latestVod;
  List<VodMinimal> latestVods;
  List<PcLatestVods> pcLatestVods;

  FrontPageData();
}
