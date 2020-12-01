// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostStore on _PostStore, Store {
  final _$postsListFutureAtom = Atom(name: '_PostStore.postsListFuture');

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

  final _$loadingAtom = Atom(name: '_PostStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$fetchPostsAsyncAction = AsyncAction('_PostStore.fetchPosts');

  @override
  Future<dynamic> fetchPosts() {
    return _$fetchPostsAsyncAction.run(() => super.fetchPosts());
  }

  final _$_PostStoreActionController = ActionController(name: '_PostStore');

  @override
  Future<dynamic> deletePost(String audioUrl) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.deletePost');
    try {
      return super.deletePost(audioUrl);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
postsListFuture: ${postsListFuture},
loading: ${loading}
    ''';
  }
}
