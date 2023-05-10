import 'package:appmid/constant.dart';
import 'package:appmid/models/api_response.dart';
import 'package:appmid/models/post.dart';
import 'package:appmid/screens/comment_screen.dart';
import 'package:appmid/screens/full_screen.dart';
import 'package:appmid/services/post_service.dart';
import 'package:appmid/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import 'login.dart';
import 'post_form.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // post like dislik
  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrievePosts();
            },
            child: ListView.builder(
                itemCount: _postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = _postList[index];
                  final themeListener =
                      Provider.of<ThemeProvider>(context, listen: true);

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    color: themeListener.isDark ? Colors.black87 : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              post.user!.id == userId
                                  ? PopupMenuButton(
                                      child: const Icon(
                                        Icons.more_vert,
                                        color: Color.fromARGB(255, 22, 21, 21),
                                      ),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                            value: 'edit',
                                            child: Text('تعديل')),
                                        const PopupMenuItem(
                                            value: 'delete', child: Text('حذف'))
                                      ],
                                      onSelected: (val) {
                                        if (val == 'edit') {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostForm(
                                                        title: 'تعديل المنشور',
                                                        post: post,
                                                      )));
                                        } else {
                                          _handleDeletePost(post.id ?? 0);
                                        }
                                      },
                                    )
                                  : const SizedBox(),
                              Row(
                                children: [
                                  Text(
                                    '${post.user!.name}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        color: themeListener.isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                        image: post.user!.image != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    '${post.user!.image}'),
                                              )
                                            : const DecorationImage(
                                                image:
                                                    AssetImage('assets/mm.jpg'),
                                                fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color.fromARGB(
                                            255, 184, 28, 173)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${post.body} ',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: themeListener.isDark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          post.image != null
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => FullScreen(
                                                  url: post.image.toString(),
                                                )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                NetworkImage('${post.image}'),
                                            fit: BoxFit.cover)),
                                  ),
                                )
                              : SizedBox(
                                  height: post.image != null ? 0 : 10,
                                  width: post.image != null ? 0 : 10,
                                ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              kLikeAndComment(
                                  post.likesCount ?? 0,
                                  post.selfLiked == true
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  post.selfLiked == true
                                      ? Colors.red
                                      : Colors.black54, () {
                                _handlePostLikeDislike(post.id ?? 0);
                              }),
                              Container(
                                height: 25,
                                width: 0.5,
                                color: Colors.black38,
                              ),
                              kLikeAndComment(post.commentsCount ?? 0,
                                  Icons.sms_outlined, Colors.black54, () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                          postId: post.id,
                                        )));
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }
}
