import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/stores/PostStore.dart';
import 'package:rec_you/stores/RecordStore.dart';
import 'package:flutter/animation.dart';
import 'package:rec_you/util/Animators.dart';

import '../components/CustomComponents.dart';


class Record extends StatefulWidget {
  @override
  _Record createState() => _Record();
}

class _Record extends State<Record> with TickerProviderStateMixin {
  AnimationController _controller;
  RecordStore rstore;
  PostStore pstore;

  final TextEditingController _description = TextEditingController();
  bool recordingButton = false;
  bool recorded = false;
  File _audioFile;
  AudioPlayer audioPlayer = AudioPlayer();
  bool fileTooBig = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    pstore = Provider.of<PostStore>(context);
    rstore = Provider.of<RecordStore>(context);
    super.didChangeDependencies();
  }

  uploadRecord(String description, BuildContext context) async {
    if (_audioFile != null) {
      await rstore.uploadFile(description, _audioFile, context);
    } else {
      await rstore.uploadRecording(description, context);
    }
    pstore.getThePosts();
  }

  openFilePicker() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      if (result.files.first.size > 10000) {
        setState(() {
          fileTooBig = true;
        });
      } else {
        _audioFile = File(result.files.first.path);
      }
    }
  }

  Object recordText() {
    if (recordingButton) {
      return Text("Recording...", style: TextStyle(color: Colors.red));
    } else if (fileTooBig) {
      fileTooBig = false;
      return Text(
        "The file limit is 10mb.",
        style: TextStyle(color: Colors.red),
      );
    } else if (_audioFile != null) {
      return Text(
        _audioFile.path.split('/').last,
        style: TextStyle(color: Colors.red),
      );
    } else if (recorded) {
      return Text(
        "Audio recorded correctly",
        style: TextStyle(color: Colors.red),
      );
    } else {
      return SizedBox();
    }
  }

  Icon iconState() {
    if (audioPlayer.state == AudioPlayerState.COMPLETED) {
      return new Icon(Icons.play_circle_filled);
    } else if (audioPlayer.state == AudioPlayerState.PLAYING) {
      return new Icon(Icons.stop_circle_outlined);
    } else if (audioPlayer.state == AudioPlayerState.STOPPED) {
      return new Icon(Icons.play_circle_filled);
    }

    return new Icon(Icons.play_circle_filled);
  }

  @override
  void dispose() {
    _controller.dispose();
    if (rstore.recorder != null) {
      rstore.recorder.closeAudioSession();
      rstore.player = null;
    }
    super.dispose();
  }

  Widget _button() {
    return Center(
        child: InkWell(
      onTap: () {
        rstore.recorder.stopRecorder();
        rstore.recorder.closeAudioSession();
        setState(() {
          recordingButton = false;
          recorded = true;
          _audioFile = null;
        });
      }, // handle your onTap here
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                Colors.red,
                Color.lerp(Colors.red, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.90, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: CurveWave(),
                ),
              ),
              child: Icon(
                Icons.record_voice_over,
                size: 70,
              )),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(centerTitle: true, title: Text("Record audio")),
        body: Observer(builder: (_) {
          if (rstore.urlAudioFuture == null) {
            return Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 2,
                                      maxLength: 60,
                                      maxLengthEnforced: true,
                                      obscureText: false,
                                      controller: _description,
                                      decoration: InputDecoration(
                                        labelText: "Description",
                                        labelStyle: TextStyle(color: Colors.white),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 15.0, 20.0, 15.0),
                                        hintText: "Insert your text here",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      )),
                                ))
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (recordingButton)
                                  ? CustomPaint(
                                      painter: CirclePainter(
                                        _controller,
                                        color: Colors.red,
                                      ),
                                      child: SizedBox(
                                        width: 80.0 * 4.125,
                                        height: 80.0 * 4.125,
                                        child: _button(),
                                      ),
                                    )
                                  : Container(
                                      child: new RaisedButton(
                                          onPressed: () {
                                            audioPlayer.stop();
                                            rstore.startRecording();
                                            setState(() {
                                              recordingButton = true;
                                              _audioFile = null;
                                            });
                                          },
                                          color: Colors.transparent,
                                          child: Icon(Icons.stop_circle,
                                              size: 100, color: Colors.red),
                                          shape: CircleBorder(
                                            side: BorderSide(color: Colors.red, width: 4),
                                          ),
                                          padding: EdgeInsets.all(60.0),
                                          elevation: 20.0),
                                    ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (!recordingButton && recorded ||
                                    _audioFile != null && !recordingButton)
                                ? IconButton(
                                    icon: iconState(),
                                    iconSize: 80,
                                    onPressed: () async {
                                      if (audioPlayer.state ==
                                          AudioPlayerState.PLAYING) {
                                        audioPlayer.stop();
                                        setState(() {});
                                      } else {
                                        if (_audioFile != null) {
                                          audioPlayer.play(_audioFile.path);
                                          setState(() {});
                                        } else {
                                          Directory tempDir =
                                              await getTemporaryDirectory();
                                          audioPlayer.play(
                                              '${tempDir.path}/flutter_sound-tmp.aac');
                                          setState(() {});
                                        }
                                      }
                                    },
                                  )
                                : SizedBox(),
                            (!recordingButton)
                                ? IconButton(
                                    icon: Icon(Icons.search),
                                    iconSize: 80,
                                    onPressed: () async {
                                      audioPlayer.stop();
                                      await openFilePicker();
                                      setState(() {});
                                    },
                                  )
                                : SizedBox(),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [recordText()])
                      ])),
                  (!recordingButton && recorded || _audioFile != null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomComponents.customButton("Upload", context, () async {
                              uploadRecord(_description.text, context);
                            })
                            ])
                      : SizedBox(),
                  SizedBox(height: 20),
                ]));
          } else {
            switch (rstore.urlAudioFuture.status) {
              case FutureStatus.pending:
                return Center(
                    child: SpinKitFadingCube(
                        color: Colors.red,
                        duration: Duration(milliseconds: 850)));
              default:
                return SizedBox();
            }
          }
        }));
  }
}


