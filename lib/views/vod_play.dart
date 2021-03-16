import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tboxapp/components/video_mat_controls.dart';
import 'package:tboxapp/components/video_player.dart';
import 'package:tboxapp/models/vod.model.dart';
import 'package:tboxapp/shared/global_vars.dart';
import 'package:tboxapp/services/app_service.dart' as appService;
import 'package:video_player/video_player.dart';

class VodPlayScreen extends StatefulWidget {
  final int uid;
  final Vod myVod;

  VodPlayScreen({Key key, @required this.uid, @required this.myVod}) : super(key: key);
  @override
  VodPlayScreenState createState() => VodPlayScreenState();
}

class VodPlayScreenState extends State<VodPlayScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  GlobalKey<CadenceDataRightState> _matCadenceKey = GlobalKey();
  GlobalKey<TBoxDataRightState> _matTboxKey = GlobalKey();

  int _uRole;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    initializePlayer();
  }

  _checkPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uRole = prefs.getInt('role') ?? -1;
    if (_uRole == -1 || !widget.myVod.viewableTo.contains(_uRole)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You do not have permssion to view this video'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    appService.addVodPlay(widget.myVod.id, widget.uid);
  }

  Future<void> initializePlayer() async {
    MyMaterialControls myMatCtrls;
    // myMatCtrls = MyMaterialControls();
    if (widget.myVod.pcType == 0) {
      // None
      // myMatCtrls = MaterialControls(myDataWidget: null);
      myMatCtrls = MyMaterialControls();
    } else if (widget.myVod.pcType == 1) {
      // T-Cycling
      // myMatCtrls = MaterialControls(key: _matCadenceKey, myDataWidget: CadenceDataRight());
      myMatCtrls = CyclingMatCtrl(onDataChanged: _handleDataChanged);
    } else if (widget.myVod.pcType == 2) {
      // T-Box
      // myMatCtrls = MaterialControls(key: _matTboxKey, myDataWidget: TBoxDataRight());
      myMatCtrls = TboxMatCtrl(onDataChanged: _handleDataChanged);
    }

    _videoPlayerController = VideoPlayerController.network(widget.myVod.vod);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      autoInitialize: true,
      looping: true,
      customControls: Stack(
        children: <Widget>[myMatCtrls],
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: MyPrimaryYellowColor),
      ),
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // ignore: null_aware_in_logical_operator
    if (_chewieController != null && _chewieController.videoPlayerController.value?.initialized) {
      return Center(
        child: Wrap(direction: Axis.horizontal, children: [
          TextButton(
            onPressed: () {
              print('dodododoodododo');
            },
            child: Text(
              'ffffffffffffffffffff',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Chewie(controller: _chewieController),
        ]),
      );
      // return SizedBox.expand(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      //       Chewie(controller: _chewieController),
      //       TextButton(onPressed: () {}, child: Text("aaaaaa"))
      //     ],
      //   ),
      // );
    } else if (_chewieController != null && _chewieController.videoPlayerController.value.hasError) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Failed to load the video'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      return SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading'),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  void dispose() {
    _saveDataThenDispose();
    super.dispose();
  }

  void _saveDataThenDispose() async {
    // TODO call API and save the data before disposeing
    // add tracking data for time watched
    // add tracking data for distance or touch
    // if success, add point gained through vod

    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  _handleDataChanged(String incomingData) {
    print(incomingData);
  }
}
