import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import '../channel_drawer_page.dart';
import '../video_hold_bg.dart';

class TvPage extends StatefulWidget {
  final Map<String, dynamic>? videoMap;
  final String? channelName;
  final String? groupName;
  final String? sourceName;
  final Function(String group, String channel)? onTapChannel;

  final VideoPlayerController? controller;
  final GestureTapCallback? changeChannelSources;
  final String? toastString;
  final bool isLandscape;
  final bool isBuffering;
  final bool isPlaying;
  final double aspectRatio;

  const TvPage({
    Key? key,
    this.videoMap,
    this.groupName,
    this.channelName,
    this.sourceName,
    this.onTapChannel,
    this.controller,
    this.changeChannelSources,
    this.toastString,
    this.isLandscape = false,
    this.isBuffering = false,
    this.isPlaying = false,
    this.aspectRatio = 16 / 9,
  }) : super(key: key);

  @override
  State<TvPage> createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  final _videoNode = FocusNode();

  _focusEventHandle(BuildContext context, KeyEvent e) {
    final isUpKey = e is KeyUpEvent;
    if (!isUpKey) return;
    switch (e.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        print('按了右键');
        break;
      case LogicalKeyboardKey.arrowLeft:
        print('按了左键');
        break;
      case LogicalKeyboardKey.arrowUp:
        print('按了上键');
        widget.changeChannelSources?.call();
        break;
      case LogicalKeyboardKey.arrowDown:
        print('按了下键');
        break;
      case LogicalKeyboardKey.select:
        print('按了确认键');
        if (!widget.isPlaying) {
          widget.controller?.play();
          return;
        }
        if (!Scaffold.of(context).isDrawerOpen) {
          Scaffold.of(context).openDrawer();
        }
        break;
      case LogicalKeyboardKey.goBack:
        print('按了返回键');
        break;
      case LogicalKeyboardKey.contextMenu:
        print('按了菜单键');
        break;
      case LogicalKeyboardKey.audioVolumeUp:
        print('按了音量加键');
        break;
      case LogicalKeyboardKey.audioVolumeDown:
        print('按了音量减键');
        break;
      case LogicalKeyboardKey.f5:
        // 不同品牌的可能不一样
        print('按了语音键');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      drawer: ChannelDrawerPage(
        videoMap: widget.videoMap,
        channelName: widget.channelName,
        groupName: widget.groupName,
        onTapChannel: widget.onTapChannel,
        isLandscape: true,
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.3,
      drawerScrimColor: Colors.transparent,
      body: Builder(builder: (context) {
        return KeyboardListener(
          focusNode: _videoNode,
          autofocus: true,
          onKeyEvent: (KeyEvent e) => _focusEventHandle(context, e),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: widget.controller?.value.isInitialized ?? false
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: widget.aspectRatio,
                        child: SizedBox(
                            width: double.infinity,
                            child: Text('hahah') //VideoPlayer(widget.controller!),
                            ),
                      ),
                      if (!widget.isPlaying)
                        GestureDetector(
                            onTap: () {
                              widget.controller?.play();
                            },
                            child: const Icon(Icons.play_circle_outline,
                                color: Colors.white, size: 50)),
                      if (widget.isBuffering) const SpinKitSpinningLines(color: Colors.white)
                    ],
                  )
                : VideoHoldBg(toastString: widget.toastString),
          ),
        );
      }),
    );
  }
}
