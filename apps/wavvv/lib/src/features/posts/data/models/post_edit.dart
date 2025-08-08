import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/shared_post.dart';

class PostEdit {
  CreatePostRequest? post;
  SharedPost? sharedPost;
  PostEdit({this.post, this.sharedPost});
}
