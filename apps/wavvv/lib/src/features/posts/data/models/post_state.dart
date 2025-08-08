import 'post_response.dart';

class PostState {
  final bool isLoading;
  final PostResponse? postData;
  final List<PostResponse>? postListData;
  final String? errorMessage;

  PostState({
    this.isLoading = false,
    this.postData,
    this.postListData,
    this.errorMessage,
  });

  PostState copyWith({
    bool? isLoading,
    PostResponse? postData,
    List<PostResponse>? postListData,
    String? errorMessage,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      postData: postData ?? this.postData,
      postListData: postListData ?? this.postListData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
