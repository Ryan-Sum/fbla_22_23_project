import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../functions/post.dart';

class ImageTile extends StatefulWidget {
  final String author;
  final String imageUrl;
  final String caption;
  final List<dynamic> likes;
  final String id;
  final AsyncSnapshot<List<Post>> posts;
  final int index;
  final DateTime date;

  const ImageTile({
    super.key,
    required this.author,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.id,
    required this.posts,
    required this.index,
    required this.date,
  });

  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile>
    with AutomaticKeepAliveClientMixin {
  Future<String?> getImage(String gsPath) async {
    final gsReference = FirebaseStorage.instance.refFromURL(gsPath);
    String? value;
    try {
      value = await gsReference.getDownloadURL();
    } on FirebaseException catch (e) {
      value = e.message;
    }
    return value;
  }

  void likeImage() {
    String currentId = FirebaseAuth.instance.currentUser!.uid;
    bool alreadyLiked = false;
    for (var element in widget.likes) {
      if (element == currentId) {
        alreadyLiked = true;
      }
    }
    List<dynamic> newLikes = widget.likes;

    if (alreadyLiked == false) {
      newLikes.add(currentId);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .update({'likes': newLikes});
    } else {
      newLikes.remove(currentId);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .update({'likes': newLikes});
    }
  }

  bool alreadyLiked() {
    String currentId = FirebaseAuth.instance.currentUser!.uid;
    bool value = false;
    for (var element in widget.likes) {
      if (element == currentId) {
        value = true;
      }
    }
    return value;
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        FutureBuilder(
            future: getImage(widget.imageUrl),
            builder: (context, future) {
              if (future.hasData) {
                return Image.network(
                  future.data!,
                  width: MediaQuery.of(context).size.width,
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
        Container(
          color: Colors.white,
          height: (MediaQuery.of(context).size.width * 0.2),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  GestureDetector(
                      onTap: () => likeImage(),
                      child: alreadyLiked()
                          ? const Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border_rounded)),
                  const SizedBox(
                    width: 8,
                  ),
                  Text('${widget.likes.length} Likes'),
                  const Spacer(),
                  Text(
                      '${widget.author} ∙ ${DateFormat('M/d/yy').format(widget.date)}')
                ]),
                const Spacer(),
                Text(widget.caption),
              ],
            ),
          ),
        )
      ],
    );
  }
}
