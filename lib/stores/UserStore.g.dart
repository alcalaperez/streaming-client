// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  final _$pictureAtom = Atom(name: '_UserStore.picture');

  @override
  File get picture {
    _$pictureAtom.reportRead();
    return super.picture;
  }

  @override
  set picture(File value) {
    _$pictureAtom.reportWrite(value, super.picture, () {
      super.picture = value;
    });
  }

  final _$userListFutureAtom = Atom(name: '_UserStore.userListFuture');

  @override
  ObservableFuture<List<User>> get userListFuture {
    _$userListFutureAtom.reportRead();
    return super.userListFuture;
  }

  @override
  set userListFuture(ObservableFuture<List<User>> value) {
    _$userListFutureAtom.reportWrite(value, super.userListFuture, () {
      super.userListFuture = value;
    });
  }

  final _$doneAtom = Atom(name: '_UserStore.done');

  @override
  ObservableFuture<String> get networkCallResult {
    _$doneAtom.reportRead();
    return super.networkCallResult;
  }

  @override
  set networkCallResult(ObservableFuture<String> value) {
    _$doneAtom.reportWrite(value, super.networkCallResult, () {
      super.networkCallResult = value;
    });
  }

  final _$errorAtom = Atom(name: '_UserStore.error');

  @override
  bool get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(bool value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$borderColorAtom = Atom(name: '_UserStore.borderColor');

  @override
  Color get borderColor {
    _$borderColorAtom.reportRead();
    return super.borderColor;
  }

  @override
  set borderColor(Color value) {
    _$borderColorAtom.reportWrite(value, super.borderColor, () {
      super.borderColor = value;
    });
  }

  final _$errorTextAtom = Atom(name: '_UserStore.errorText');

  @override
  String get errorText {
    _$errorTextAtom.reportRead();
    return super.errorText;
  }

  @override
  set errorText(String value) {
    _$errorTextAtom.reportWrite(value, super.errorText, () {
      super.errorText = value;
    });
  }

  final _$userExistAtom = Atom(name: '_UserStore.userExist');

  @override
  ObservableFuture<String> get userExist {
    _$userExistAtom.reportRead();
    return super.userExist;
  }

  @override
  set userExist(ObservableFuture<String> value) {
    _$userExistAtom.reportWrite(value, super.userExist, () {
      super.userExist = value;
    });
  }

  final _$setErrorAsyncAction = AsyncAction('_UserStore.setError');

  @override
  Future setError(bool value, String errorT) {
    return _$setErrorAsyncAction.run(() => super.setError(value, errorT));
  }

  final _$_UserStoreActionController = ActionController(name: '_UserStore');

  @override
  Future<dynamic> fetchUsers() {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.fetchUsers');
    try {
      return super.fetchUsers();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> fetchFilteredUsers(String filteredUsername) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.fetchFilteredUsers');
    try {
      return super.fetchFilteredUsers(filteredUsername);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> login(String username, String pass) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.login');
    try {
      return super.login(username, pass);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> register(String username, String pass, File picUrl) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.register');
    try {
      return super.register(username, pass, picUrl);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> userAlreadyExist(String username) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.userAlreadyExist');
    try {
      return super.userAlreadyExist(username);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
picture: ${picture},
userListFuture: ${userListFuture},
done: ${networkCallResult},
error: ${error},
borderColor: ${borderColor},
errorText: ${errorText},
userExist: ${userExist}
    ''';
  }
}
