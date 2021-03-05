import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
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
              FlatButton(
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
    var myMatCtrls;
    if (widget.myVod.pcType == 0) {
      // None
      myMatCtrls = MaterialControls(myDataWidget: null);
    } else if (widget.myVod.pcType == 1) {
      // T-Cycling
      myMatCtrls = MaterialControls(myDataWidget: CadenceDataRight());
    } else if (widget.myVod.pcType == 2) {
      // T-Box
      myMatCtrls = MaterialControls(myDataWidget: TBoxDataRight());
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
    if (_chewieController != null && _chewieController.videoPlayerController.value.initialized) {
      return SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Chewie(controller: _chewieController)],
        ),
      );
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
              FlatButton(
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
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
