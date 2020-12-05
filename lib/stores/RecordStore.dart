import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec_you/network/AudioActions.dart';

part 'RecordStore.g.dart';

class RecordStore = _RecordStore with _$RecordStore;

abstract class _RecordStore with Store {
  final AudioActions httpClient = AudioActions();

  @observable
  FlutterSoundRecorder recorder = FlutterSoundRecorder();

  @observable
  FlutterSoundPlayer player = FlutterSoundPlayer();

  @observable
  ObservableFuture<String> urlAudioFuture;

  @action
  Future uploadAudio(String description, File audio) =>
      urlAudioFuture = ObservableFuture(
          httpClient.uploadAudio(description, audio).then((users) => users));

  Future<void> uploadRecording(String description, BuildContext context) async {
    if(description.isEmpty) {
      description = "Checkout this audio!";
    }
    Directory tempDir = await getTemporaryDirectory();
    await uploadAudio(
        description, File('${tempDir.path}/flutter_sound-tmp.aac'));
    urlAudioFuture = null;
    Navigator.pushNamed(context, "/homepage");
  }

  Future<void> uploadFile(
      String description, File audio, BuildContext context) async {
    if(description.isEmpty) {
      description = "Checkout this audio!";
    }
    await uploadAudio(description, audio);
    urlAudioFuture = null;
    Navigator.pushNamed(context, "/homepage");
  }

  void startRecording() async {
    recorder = await FlutterSoundRecorder().openAudioSession();
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");

    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');
    recorder.startRecorder(toFile: outputFile.path, codec: Codec.defaultCodec);
  }

  void startPlaying() async {
    player = await FlutterSoundPlayer().openAudioSession();
    Directory tempDir = await getTemporaryDirectory();
    File fin = File('${tempDir.path}/flutter_sound-tmp.aac');
    await player.startPlayer(
      fromURI: fin.path,
      whenFinished: () {
        print('I hope you enjoyed listening to this song');
        player.closeAudioSession();
      },
    );
  }

  void playUrl(String url) async {
    player = await FlutterSoundPlayer().openAudioSession();
    await player.startPlayer(
      fromURI: url,
      whenFinished: () {
        print('I hope you enjoyed listening to this song');
        player.closeAudioSession();
      },
    );
  }
}
