import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/stores/AudioStore.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class PlayerWidget extends StatefulWidget {
  String url;
  PlayerMode mode;

  PlayerWidget(
      {Key key, @required this.url, this.mode = PlayerMode.MEDIA_PLAYER})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, mode);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  PlayerMode mode;
  AudioStore audioStore;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  _PlayerWidgetState(this.url, this.mode);

  @override
  void didUpdateWidget(PlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initAudioPlayer();
    _stop();
    play(widget.url);
  }

  @override
  void initState() {
    super.initState();
    audioStore = Provider.of<AudioStore>(context, listen: false);
    _initAudioPlayer();
    _stop();
    play(widget.url);
  }

  @override
  void dispose() {
    _stop();
    audioStore.audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  Object currentIcon() {
    if (_isPlaying) {
      return IconButton(
        key: Key('pause_button'),
        onPressed: _isPlaying ? () => _pause() : null,
        iconSize: 32.0,
        icon: Icon(Icons.pause),
        color: Colors.white,
      );
    } else {
      return IconButton(
        key: Key('play_button'),
        onPressed: () async {
          if(_isPaused){
            final result = await audioStore.audioPlayer.resume();
            if (result == 1) setState(() => _playerState = PlayerState.playing);
          } else {
            play(widget.url);
          }
        },
        iconSize: 32.0,
        icon: Icon(Icons.play_arrow),
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            currentIcon(),
            Container(
               width: MediaQuery.of(context).size.width*0.75-70,
                child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                thumbColor: Colors.red[400],
              ),
              child: Slider(
                onChanged: (v) {
                  final position = v * _duration.inMilliseconds;
                  audioStore.audioPlayer.seek(Duration(milliseconds: position.round()));
                },
                divisions: 100,
                label: (_position != null &&
                        _duration != null &&
                        _position.inMilliseconds > 0 &&
                        _position.inMilliseconds < _duration.inMilliseconds)
                    ? (_position.inSeconds).toString() + ' sec.'
                    : '0 sec.',
                value: (_position != null &&
                        _duration != null &&
                        _position.inMilliseconds > 0 &&
                        _position.inMilliseconds < _duration.inMilliseconds)
                    ? _position.inMilliseconds / _duration.inMilliseconds
                    : 0.0,
              ),
            )),
            Text(
              _position != null ? _positionText : '',
              style: TextStyle(fontSize: 10.0),
            ),
          ],
        ),
      ],
    );
  }

  void _initAudioPlayer() {
    _durationSubscription = audioStore.audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // Implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        audioStore.audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        audioStore.audioPlayer.setNotification(
          title: 'RecYou',
          // forwardSkipInterval: const Duration(seconds: 30), // default is 30s
          // backwardSkipInterval: const Duration(seconds: 30), // default is 30s
          duration: duration,
          elapsedTime: Duration(seconds: 0),
          hasNextTrack: true,
          hasPreviousTrack: false,
        );
      }
    });

    _positionSubscription =
        audioStore.audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        audioStore.audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = audioStore.audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _playerControlCommandSubscription =
        audioStore.audioPlayer.onPlayerCommand.listen((command) {
      print('command');
    });

    audioStore.audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    audioStore.audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> play(String url) async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    audioStore.audioPlayer.stop();
    final result = await audioStore.audioPlayer.play(url);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    audioStore.audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await audioStore.audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await audioStore.audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
