// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfileStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileStore on _ProfileStore, Store {
  final _$profileAtom = Atom(name: '_ProfileStore.profile');

  @override
  ObservableFuture<FullUser> get profile {
    _$profileAtom.reportRead();
    return super.profile;
  }

  @override
  set profile(ObservableFuture<FullUser> value) {
    _$profileAtom.reportWrite(value, super.profile, () {
      super.profile = value;
    });
  }

  final _$profileTextAtom = Atom(name: '_ProfileStore.profileText');

  @override
  ObservableFuture<Text> get profileText {
    _$profileTextAtom.reportRead();
    return super.profileText;
  }

  @override
  set profileText(ObservableFuture<Text> value) {
    _$profileTextAtom.reportWrite(value, super.profileText, () {
      super.profileText = value;
    });
  }

  final _$_ProfileStoreActionController =
      ActionController(name: '_ProfileStore');

  @override
  Future<dynamic> fetchProfile(String username) {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.fetchProfile');
    try {
      return super.fetchProfile(username);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> follow(String userToFollow) {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.follow');
    try {
      return super.follow(userToFollow);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> unfollow(String userToUnfollow) {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.unfollow');
    try {
      return super.unfollow(userToUnfollow);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeOld() {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.removeOld');
    try {
      return super.removeOld();
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePost(String id) {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.removePost');
    try {
      return super.removePost(id);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profile: ${profile},
profileText: ${profileText}
    ''';
  }
}
