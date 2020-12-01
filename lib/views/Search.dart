import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rec_you/model/User.dart';
import 'package:rec_you/views/UserProfile.dart';

import '../stores/UserStore.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  UserStore store;
  final TextEditingController _searchQuery = TextEditingController();

  filterUsers(String filteredUsername) {
    store.fetchFilteredUsers(filteredUsername);
  }

  @override
  Widget build(BuildContext context) {
    store = Provider.of<UserStore>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            // action button
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                filterUsers(_searchQuery.text);
              },
            ),
          ],
          title: TextField(
            autofocus: true,
            controller: _searchQuery,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search users",
                hintStyle: TextStyle(color: Colors.black)),
          ),
        ),
        body: Observer(builder: (_) {
          if (store.userListFuture == null) {
            return SizedBox();
          } else {
            switch (store.userListFuture.status) {
              case FutureStatus.pending:
                return Center(
                    child: SpinKitFadingCube(
                        color: Colors.red,
                        duration: Duration(milliseconds: 850)));
              case FutureStatus.fulfilled:
                final List<User> users = store.userListFuture.result;
                if (users.length == 0) {
                  return Center(child: Text("No results"));
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                        title: Text(user.username),
                        onTap: () {
                          Navigator.pushNamed(context, UserProfile.routeName,
                              arguments: user.username);
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        ));
                  },
                );
              default:
                return SizedBox();
            }
          }
        }));
  }
}
