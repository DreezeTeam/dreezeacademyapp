import 'package:flutter/services.dart';
import 'package:kindergaten/Model/playModel.dart';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:kindergaten/screen/homescreen.dart';
import '../provider/databaseHelper.dart';
import 'package:kindergaten/screen/mycourses.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:neeko/neeko.dart';
import 'package:http/http.dart' as http;
import '../widgets/single_video.dart';
import 'package:provider/provider.dart';


class PlayScreen extends StatefulWidget {
  static final routeName = '/class';
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  Stream<List<VideosModelProvider>> stream;
  VideosModelProvider _currentPlaying = VideosModelProvider();
  VideosModelProvider _recentPlaying = VideosModelProvider();
  List<VideosModelProvider> topics = [];
 VideoControllerWrapper videoControllerWrapper;
  int _playingIndex = -1;
  var _disposed = false;
  var _isplaying = false;
  var _duration;
  var _recentduration;
  var _recentposition;
  var _position;
   final dbHelper = DataBaseOpener.instance;
  String error = "";
  Future<List<VideosModelProvider>> getData(String topic) async {
    List<VideosModelProvider> list = [];
    var map = {"videoT": "fractions"};
    var uri = Uri.https('www.dreezeacademy.com', '/videos_app.php', map);
    var url = 'https://www.dreezeacademy.com/videos_app.php?videoT=fractions';

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      try {
        var parsedJson = jsonDecode(response.body) as Map<String, dynamic>;

        parsedJson.forEach((key, value) {
          var second = value as Map<String, dynamic>;
          VideosModelProvider _json = VideosModelProvider.fromJson(second);
          list.add(_json);
        });

        setState(() {
          topics = list;
          _currentPlaying = list[0];
        });
        _initializeAndPlay(list);
        // print("${_currentPlaying.videoSource.replaceAll(' ', "%20")}");
        // player.setDataSource("https://www.dreezeacademy.com${_currentPlaying.videoSource.replaceAll(' ', "%20")}", autoPlay: true,);
        return list;
      } catch (Exception) {
        print(Exception.toString());
        return list;
      }
    } else {
      return list;
    }
  }


  void _initializeAndPlay(List<VideosModelProvider> lists)  async{



     setState(() {
       _playingIndex =0;
    });

    videoControllerWrapper = VideoControllerWrapper(
    DataSource.network(
    'https://www.dreezeacademy.com${_currentPlaying.videoSource.replaceAll(' ', "%20")}'),onControllerUpdated);

    // try {
    //   final controller = VideoPlayerController.network(
    //       "https://www.dreezeacademy.com${_currentPlaying.videoSource.replaceAll(' ', "%20")}");
    //   final old = _controller;
    //   _controller = controller;
    //   if (old != null) {
    //     old.removeListener(_onControllerUpdated);
    //     await old.pause();
    //   }
    //   setState(() {
    //     //   _title =widget.channels[pageIndex].subhead[index].title;
    //     debugPrint("---- controller changed");
    //   });
    //
    //   controller
    //     ..initialize().then((_) {
    //       debugPrint("---- controller initialized");
    //       old?.dispose();
    //       controller.addListener(_onControllerUpdated);
    //       controller.play();
    //       setState(() {
    //         _playing = 0;
    //       });
    //     });

      // flickManager = FlickManager(
      //     autoPlay: true,
      //     autoInitialize: true,
      //     videoPlayerController: controller);

  }
  Future<void> onControllerUpdated() async {
    if (_disposed) return;
    final controller = videoControllerWrapper.controller;
    if (controller == null) return;
    if (!controller.value.initialized) return;
    final position = await controller.position;
    final duration = controller.value.duration;
    if (position == null || duration == null) return;

    final playing = controller.value.isPlaying;
    final isEndOfClip =
        position.inMilliseconds > 0 && position.inSeconds == duration.inSeconds;

    // blocking too many updation
    final interval = position.inMilliseconds / 250.0;

    if (playing) {
      setState(() {

        _isplaying =   playing ;
        _duration = duration.inMilliseconds;
        _position = position.inMilliseconds;
      });
    }


    // handle clip end
  }
  void _changeVideo(int index)async{
    print("-------_initializeAndPlay-$index-------->");

    setState(() {
      _recentPlaying = _currentPlaying;
      _currentPlaying = topics[index];
      _playingIndex = index;
      _recentduration = _duration;
      _recentposition = _position;
      _position = 0;
      _duration = 0;
      _isplaying=false;
    });
    print('https://www.dreezeacademy.com${_currentPlaying.videoSource.replaceAll(' ', "%20")}');
    _recently(_recentPlaying, _recentposition, _recentduration);


    _playingIndex = index;
    videoControllerWrapper.prepareDataSource(  DataSource.network(
        'https://www.dreezeacademy.com${_currentPlaying.videoSource.replaceAll(' ', "%20")}'), onControllerUpdated);
    setState(() {});

  }



  @override
  void didChangeDependencies() {
    // final args =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // String topic = args['topic'];

   // Provider.of<VideosModelProvider>(context).getData("topic").then((value) {
   //   setState(() {
   //     topics = value;
   //     _currentPlaying = value[0];
   //   });
   //   _initializeAndPlay(value);
   //
   // });
  stream = new Stream.fromFuture(getData("topic"));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    _disposed = true;
    // videoControllerWrapper.controller?.pause(); // mute instantly
    // videoControllerWrapper.controller?.dispose();
  //  videoControllerWrapper.controller = null;
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: appThemeDark.backgroundColor,
      body: SafeArea(
        child:  topics.length >0
            ? Container(
          child: Column(
            children: [

              playinWidget(context),
                     Expanded(
                       child: ListView.builder(
                              padding: const EdgeInsets.only(left: 23, right: 23, top: 10),
                              itemCount: topics.length,
                             physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                            itemBuilder: (ctx , index){
                              return ChangeNotifierProvider(
                                create: (context)=>topics[index],
                                // builder: (context) => topics[index],
                               // value:topics[index],
                                //  builder: (c) => topics[index],
                                 child: SingleVideo(index, _playingIndex,
                                     _isplaying, _position,
                                     _duration, _changeVideo)

                                );


                              // ChangeNotifierProvider(
                              //   builder: (c) => products[index],
                              //   child: ProductGridItem(),
                              // );

                                //
                            },
                              // itemBuilder: (ctx, index) {
                              //

                                ),
                     )


            ],
          ),
        ):
        Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Colors.blue),
            )),
      ),
    );
  }

  Widget  playinWidget(BuildContext context){
    return ChangeNotifierProvider(
      create: (_) => _currentPlaying,

      child: Container(
        height: Config.yMargin(context, 33),
        //color: Colors.red,
    child:Consumer<VideosModelProvider>(
      builder: (context, currentvideo, child) {
        return Column(
     children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: NeekoPlayerWidget(
                  playerOptions: NeekoPlayerOptions(
                    autoPlay: true,
                    loop: true,

                  ),
             videoControllerWrapper: videoControllerWrapper,
            onSkipNext: (){

            },
            onSkipPrevious: (){
            print(_position);
            },
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print("share");
                  })
            ],
          ),
        ),

              Container(
            padding: const EdgeInsets.only(left: 5, right: 23),
            color: Colors.black12,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back), onPressed: () {
                  Navigator.of(context).pushNamed(HomeScreen.routeName);
                }),
                Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () {
                          currentvideo.likeMethod();
                        }),
                    Positioned(
                        right: 0,
                        top: 7,

                        child: Text("${currentvideo.likes}"))
                  ],
                ),
                SizedBox(width: 20,),
                Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.thumb_down), onPressed: () {
                   //  Provider.of<VideosModelProvider>(context, listen: false).likeMethod();
                      currentvideo.unlikeMethod();
                    }),

                    Positioned(
                        left: 0,
                        bottom: 7,
                        child: Text("${currentvideo.unlikes}")
                    ),
                  ],
                ),
                Expanded(child: Container()),
                IconButton(icon: Icon(
                    currentvideo.bookMark?
                    Icons.bookmark
                        :
                    Icons.bookmark_border), onPressed: () {
                  currentvideo.bookMarkMethod();
                  _bookMarked(currentvideo);
                  print('bookMarked');
                }),
                IconButton(icon: Icon(Icons.share), onPressed: () {})
              ],
            ),
          ),


      ],
    );
    }  ),
    ));
  }

  void _bookMarked(VideosModelProvider videosModelProvider) async{


       Map<String, dynamic> row = {
         DataBaseOpener.theme: '${videosModelProvider.theme}',
         DataBaseOpener.videoTitle: '${videosModelProvider.videoTitle}',
         DataBaseOpener.videoSource: '${videosModelProvider.videoSource}',
         DataBaseOpener.videoName: '${videosModelProvider.videoName}',
         DataBaseOpener.videoAbout: '${videosModelProvider.videoAbout}',
         DataBaseOpener.videoNote: '${videosModelProvider.videoNote}'

       };
     await dbHelper.insertrecently(row);

  }


  void _recently(VideosModelProvider videosModelProvider, var position, var duration) async{
      videosModelProvider.updatePercentage("bidex",position, duration);
    // Map<String, dynamic> row = {
    //   DataBaseOpener.theme: '${videosModelProvider.theme}',
    //   DataBaseOpener.videoTitle: '${videosModelProvider.videoTitle}',
    //   DataBaseOpener.videoSource: '${videosModelProvider.videoSource}',
    //   DataBaseOpener.videoName: '${videosModelProvider.videoName}',
    //   DataBaseOpener.videoAbout: '${videosModelProvider.videoAbout}',
    //   DataBaseOpener.videoNote: '${videosModelProvider.videoNote}'
    //
    // };
    //  dbHelper.insertrecently(row);



  }




}

