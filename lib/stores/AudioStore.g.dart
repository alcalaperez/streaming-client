// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AudioStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AudioStore on _AudioStore, Store {
  final _$postsListFutureAtom = Atom(name: '_AudioStore.postsListFuture');

  @override
  ObservableList<Post> get postsListFuture {
    _$postsListFutureAtom.reportRead();
    return super.postsListFuture;
  }

  @override
  set postsListFuture(ObservableList<Post> value) {
    _$postsListFutureAtom.reportWrite(value, super.postsListFuture, () {
      super.postsListFuture = value;
    });
  }

  final _$currentIconAtom = Atom(name: '_AudioStore.currentIcon');

  @override
  Icon get currentIcon {
    _$currentIconAtom.reportRead();
    return super.currentIcon;
  }

  @override
  set currentIcon(Icon value) {
    _$currentIconAtom.reportWrite(value, super.currentIcon, () {
      super.currentIcon = value;
    });
  }

  final _$_AudioStoreActionController = ActionController(name: '_AudioStore');

  @override
  void setCurrentIndex(int index) {
    final _$actionInfo = _$_AudioStoreActionController.startAction(
        name: '_AudioStore.setCurrentIndex');
    try {
      return super.setCurrentIndex(index);
    } finally {
      _$_AudioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void play(String audioUrl, int indexPlay) {
    final _$actionInfo =
        _$_AudioStoreActionController.startAction(name: '_AudioStore.play');
    try {
      return super.play(audioUrl, indexPlay);
    } finally {
      _$_AudioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stop(int indexStop) {
    final _$actionInfo =
        _$_AudioStoreActionController.startAction(name: '_AudioStore.stop');
    try {
      return super.stop(indexStop);
    } finally {
      _$_AudioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
postsListFuture: ${postsListFuture},
currentIcon: ${currentIcon}
    ''';
  }
}
