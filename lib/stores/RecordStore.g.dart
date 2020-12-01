// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecordStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RecordStore on _RecordStore, Store {
  final _$recorderAtom = Atom(name: '_RecordStore.recorder');

  @override
  FlutterSoundRecorder get recorder {
    _$recorderAtom.reportRead();
    return super.recorder;
  }

  @override
  set recorder(FlutterSoundRecorder value) {
    _$recorderAtom.reportWrite(value, super.recorder, () {
      super.recorder = value;
    });
  }

  final _$playerAtom = Atom(name: '_RecordStore.player');

  @override
  FlutterSoundPlayer get player {
    _$playerAtom.reportRead();
    return super.player;
  }

  @override
  set player(FlutterSoundPlayer value) {
    _$playerAtom.reportWrite(value, super.player, () {
      super.player = value;
    });
  }

  final _$urlAudioFutureAtom = Atom(name: '_RecordStore.urlAudioFuture');

  @override
  ObservableFuture<String> get urlAudioFuture {
    _$urlAudioFutureAtom.reportRead();
    return super.urlAudioFuture;
  }

  @override
  set urlAudioFuture(ObservableFuture<String> value) {
    _$urlAudioFutureAtom.reportWrite(value, super.urlAudioFuture, () {
      super.urlAudioFuture = value;
    });
  }

  final _$_RecordStoreActionController = ActionController(name: '_RecordStore');

  @override
  Future<dynamic> uploadAudio(String description, File audio) {
    final _$actionInfo = _$_RecordStoreActionController.startAction(
        name: '_RecordStore.uploadAudio');
    try {
      return super.uploadAudio(description, audio);
    } finally {
      _$_RecordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
recorder: ${recorder},
player: ${player},
urlAudioFuture: ${urlAudioFuture}
    ''';
  }
}
