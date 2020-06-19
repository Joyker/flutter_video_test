import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;
class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {

  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        //'https://streamvideo.luxnet.ua/news24/smil:news24.stream.smil/playlist.m3u8',
        'http://cdn1.live-tv.od.ua:8081/mobileenglishclub/eclub-abr-lq/playlist.m3u8',
        //'https://59e5d081ab116.streamlock.net/Kids/Kids/playlist.m3u8',
        //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        //'https://player.vimeo.com/external/342264984.sd.mp4?s=8cd77fb6b79637c7dd183156eb7612781b7d79af&profile_id=139&oauth2_token_id=388034055'
    );
    _controller.seekTo( new Duration(seconds:30));
    _controller.addListener(() {

      setState(() {});
    });
    _controller.setLooping(false);

    _controller.initialize();
    _controller.play();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
        Container(
          padding: const EdgeInsets.all(0),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            //aspectRatio: MediaQuery.of(context).devicePixelRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                ClosedCaption(text: _controller.value.caption.text),
                _PlayPauseOverlay(controller: _controller),
                //VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          ),
        ),

    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      developer.log('pressed', name: 'row');
                    },
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause(): controller.play();
            developer.log('pressed', name: 'overlay');
          },
        ),
      ],
    );
  }
}
