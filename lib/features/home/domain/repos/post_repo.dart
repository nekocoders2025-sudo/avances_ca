

import 'package:coleccion_app/features/home/domain/entities/comment.dart';
import 'package:coleccion_app/features/home/domain/entities/post.dart';

abstract class PostRepo {
  // Post functionality
  Future<void> createPost(Post post);
  Future<void> deletePost(String id);
  Future<List<Post>> loadAllPosts();

  // Comment functionality
  Future<void> addComment(Comment comment);
  Future<void> deleteComment(String postId, String commentId);
  Future<List<Comment>> getComments(String postId);
}