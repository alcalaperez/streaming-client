import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rec_you/model/Post.dart';
import 'package:rec_you/network/AudioActions.dart';

part 'AudioStore.g.dart';

class AudioStore = _AudioStore with _$AudioStore;

abstract class _AudioStore with Store {
  final AudioActions httpClient = AudioActions();
  AudioPlayer audioPlayer = AudioPlayer();

  @observable
  ObservableList<Post> postsListFuture = ObservableList<Post>();

  int indexPlaying = -1;

  @observable
  Icon currentIcon = new Icon(Icons.play_circle_filled);

  @action
  void setCurrentIndex(int index) => indexPlaying = index;

  @action
  void play(String audioUrl, int indexPlay) {
    audioPlayer.play(audioUrl);
    indexPlaying = indexPlay;
    currentIcon = new Icon(Icons.stop_circle_outlined);
  }

  @action
  void stop(int indexStop) {
    audioPlayer.stop();
    indexPlaying = indexStop;
    currentIcon = new Icon(Icons.play_circle_filled);
  }
}
