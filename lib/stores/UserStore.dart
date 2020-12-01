import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/model/User.dart';
import 'package:rec_you/network/AuthenticationActions.dart';
import 'package:rec_you/network/UserActions.dart';

import '../views/MainScreen.dart';
import '../util/SharedPreferencesData.dart';

part 'UserStore.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final AuthenticationActions authClient = AuthenticationActions();
  final UserActions userClient = UserActions();

  /// Selected picture when registering
  @observable
  File picture;

  /// List of users (all and filtered)
  @observable
  ObservableFuture<List<User>> userListFuture;

  /// Result for login and register calls
  @observable
  ObservableFuture<String> networkCallResult;

  /// Conditional variables to show errors
  @observable
  bool error = false;
  @observable
  String errorText = "";
  @observable
  Color borderColor = Colors.white;

  /// Check if user exists
  ///
  /// Returns true and false as String
  /// (backend/frontend limitation)
  @observable
  ObservableFuture<String> userExist;

  /// Get all users and assign it to [userListFuture]
  @action
  Future fetchUsers() => userListFuture =
      ObservableFuture(userClient.getUsers().then((users) => users));

  /// Get users by username and assign it to [userListFuture]
  @action
  Future fetchFilteredUsers(String filteredUsername) =>
      userListFuture = ObservableFuture(
          userClient.getFilteredUsers(filteredUsername).then((users) => users));

  /// Login user and assign the result to [networkCallResult]
  @action
  Future login(String username, String pass) => networkCallResult =
      ObservableFuture(authClient.login(username, pass).then((done) => done));

  /// Register an user and assign the result to [networkCallResult]
  @action
  Future register(String username, String pass, File picUrl) =>
      networkCallResult = ObservableFuture(
          authClient.register(username, pass, picUrl).then((done) => done));

  /// Check if an user exists [userExist]
  @action
  Future userAlreadyExist(String username) => userExist = ObservableFuture(
      userClient.userExist(username).then((userExist) => userExist));

  /// Sets the error state
  ///
  /// Adds a text and changes the border color of TextEdit to red
  @action
  setError(bool value, String errorT) async {
    error = value;
    borderColor = Colors.red;
    errorText = errorT;
  }

  /// Logic abstraction that uses [login()] and checks the result
  ///
  /// Sets the error message if the credentials are wrong
  /// Navigates to the [HomePage] and updates the global [SharedPreferences()]
  Future<void> logInUser(String user, String pass, BuildContext context) async {
    await login(user, pass);

    if (await networkCallResult == "Unauthorized" ||
        await networkCallResult == "Error in URL") {
      setError(true, "Invalid credentials");
    } else {
      SharedPreferencesData sharedPref =
          Provider.of<SharedPreferencesData>(context, listen: false);
      sharedPref.reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  /// Logic abstraction that uses [register()] and checks the result
  ///
  /// Sets an error message if the user exists or passwords are not the same
  /// Navigates to the [HomePage] and updates the global [SharedPreferences()]
  Future<void> registerUser(
      String user, String pass, String repass, BuildContext context) async {
    await userAlreadyExist(user);

    if (user.isEmpty ||
        pass.isEmpty ||
        repass.isEmpty ||
        user.contains(" ") ||
        pass.contains(" ") ||
        repass.contains(" ")) {
      setError(true, "Fields cannot be empty or contain spaces");
    } else if (pass != repass) {
      setError(true, "The passwords must be the same");
    } else if (await userExist == "true") {
      setError(true, "The username already exists");
    } else {
      await register(user, pass, picture);
      SharedPreferencesData sharedPref =
          Provider.of<SharedPreferencesData>(context, listen: false);
      sharedPref.reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}
