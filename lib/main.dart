import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyVideoPlayer());
  }
}

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({super.key});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

int _myindex = 0;
List videos = ['assets/v1.mp4', 'assets/v2.mp4', 'assets/v3.mp4'];

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late FlickManager flickManager;
  late bool isPlaying;

  @override
  void initState() {
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.asset(videos[_myindex]))
      ..flickControlManager?.addListener(() {
        _onFlickControlChange();
      });
    isPlaying = flickManager.flickVideoManager?.isPlaying ?? false;
    super.initState();
  }

  void _playVideo(int index) async {
    await flickManager.flickControlManager?.pause();
    await flickManager.flickControlManager?.seekTo(Duration.zero);

    VideoPlayerController newController =
        VideoPlayerController.asset(videos[index]);
    await newController.initialize();

    setState(() {
      flickManager.handleChangeVideo(newController);
      _myindex = index;
      isPlaying = flickManager.flickVideoManager?.isPlaying ?? false;
      print(_myindex);
    });
  }

  void _onFlickControlChange() {
    setState(() {
      isPlaying = flickManager.flickVideoManager?.isPlaying ?? false;
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: FlickVideoPlayer(flickManager: flickManager),
            ),
            Container(
              height: 50,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _playVideo(_myindex - 1);
                          },
                          icon: Icon(Icons.arrow_circle_left)),
                      IconButton(
                        onPressed: () {
                          flickManager.flickControlManager?.togglePlay();
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _playVideo(_myindex + 1);
                          },
                          icon: Icon(Icons.arrow_circle_right))
                    ],
                  ),
                  Container()
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _playVideo(index);
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 50,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Video ${index + 1}')
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
