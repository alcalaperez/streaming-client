import 'package:mobx/mobx.dart';
import 'package:rec_you/model/Post.dart';
import 'package:rec_you/network/PostActions.dart';
import 'package:rec_you/stores/ProfileStore.dart';

part 'PostStore.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  final PostActions httpClient = PostActions();
  final profileStore = ProfileStore();
  String username;
  String picUrl;
  int selectedIndex = -1;

  @observable
  ObservableList<Post> postsListFuture = ObservableList<Post>();

  @observable
  bool loading = false;

  @action
  Future fetchPosts() async {
    loading = true;
    postsListFuture = await httpClient.getFeed();
    loading = false;
  }

  @action
  Future deletePost(String audioUrl) =>
      ObservableFuture(httpClient.removePost(audioUrl));

  Future<void> getThePosts() async {
    await fetchPosts();
  }

  Future<void> removePost(String id, String username) async {
    await deletePost(id);
    profileStore.getUserProfile(username);
  }

  Future<void> getThePostsAndFollow(String userToFollow) async {
    await profileStore.followUser(userToFollow);
    await fetchPosts();
  }

  Future<void> getThePostsAndUnfollow(String userToFollow) async {
    await profileStore.unfollowUser(userToFollow);
    await fetchPosts();
  }
}
