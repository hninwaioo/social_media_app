import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/models/authentication_model.dart';
import 'package:social_media_app/models/authentication_model_impl.dart';
import 'package:social_media_app/models/social_model.dart';
import 'package:social_media_app/network/social_data_agent.dart';

// import '../network/cloud_firestore_data_agent_impl.dart';
import '../network/real_time_database_data_agent_impl.dart';

// const fileUploadRef = "uploads";

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();
  var firebaseStorage = FirebaseStorage.instance;

  factory SocialModelImpl(){
    return _singleton;
  }
  SocialModelImpl._internal();
  SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();
  // SocialDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  AuthenticationModel _authenticationModel = AuthenticationModelImpl();


  @override
  Stream<List<NewsFeedVO>?> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description, File? imageFile) {
    // var currentMilliseconds = DateTime.now().microsecondsSinceEpoch;
    // var newPost = NewsFeedVO(
    //     id: currentMilliseconds,
    //     description: description,
    //     profilePicture: "https://media.allure.com/photos/5a26c1d8753d0c2eea9df033/3:4/w_1262,h_1683,c_limit/mostbeautiful.jpg",
    //     userName: "Kitty",
    //     postImage:""
    // );
    // return mDataAgent.addNewPost(newPost);

    if(imageFile != null){
      return mDataAgent
          .uploadFileToFirebase(imageFile)
          .then((downloadUrl) => craftNewsFeedVO(description, downloadUrl))
          .then((newPost) => mDataAgent.addNewPost(newPost));
    }else {
      return craftNewsFeedVO(description, "")
          .then((newPost) => mDataAgent.addNewPost(newPost));
    }
  }

  Future<NewsFeedVO> craftNewsFeedVO(String description, String imageUrl){
    var currentMilliseconds = DateTime.now().microsecondsSinceEpoch;
    var newPost = NewsFeedVO(
        id: currentMilliseconds,
        description: description,
        profilePicture: "https://media.allure.com/photos/5a26c1d8753d0c2eea9df033/3:4/w_1262,h_1683,c_limit/mostbeautiful.jpg",
        userName: _authenticationModel.getLoggedInUser().userName,
        postImage: imageUrl
    );
    return Future.value(newPost);
  }

  @override
  Future<void> deletePost(int postId){
    return mDataAgent.deletePost(postId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsfeed, File? imageFile) {
    return mDataAgent.addNewPost(newsfeed);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsfeedId) {
    return mDataAgent.getNewsFeedById(newsfeedId);
  }

  @override
  Future<String> uploadFileToFirebase(File image){
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }
}