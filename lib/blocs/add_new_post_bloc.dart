import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/models/social_model_impl.dart';
import '../analytics/firebase_analytics_tracker.dart';
import '../data/vos/user_vo.dart';
import '../models/authentication_model.dart';
import '../models/authentication_model_impl.dart';
import '../models/social_model.dart';
import 'package:social_media_app/remote_config/firebase_remote_config.dart';

class AddNewPostBloc extends ChangeNotifier{

  ///State
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;
  bool isInEditMode = false;
  String? userName = "";
  String? profilePicture = "";
  NewsFeedVO? mNewsFeed;
  /// Image
  File? chosenImageFile;
  bool isLoading = false;

  /// UserVO
  UserVO? _loggedInUser;

  /// Remote Config Color
  Color themeColor = Colors.black;
  final FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig();

  ///Model
  final SocialModel _model = SocialModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  AddNewPostBloc({int? newsfeedId}){
    _loggedInUser = _authenticationModel.getLoggedInUser();
    if(newsfeedId != null){
      isInEditMode = true;
      _prepopulateDataForEditMode(newsfeedId);
    }else{
      _prepopulateDataForAddNewPost();
    }
    /// Analytics
    _sendAnalyticsData(addNewPostScreenReached, null);

    /// Remote Config
    _getRemoteConfigAndChangeTheme();
  }

  void _getRemoteConfigAndChangeTheme() {
    themeColor = _firebaseRemoteConfig.getThemeColorFromRemoteConfig();
    _notifySafety();
  }

  void _prepopulateDataForAddNewPost(){
    userName = _loggedInUser?.userName??"";
    profilePicture = "https://t3.ftcdn.net/jpg/03/55/66/32/360_F_355663236_ILrh4JIqDWc9OwvEiTUClmsJRrdIpucx.jpg";
    _notifySafety();
  }

  void _prepopulateDataForEditMode(int newsfeedId){
    _model.getNewsFeedById(newsfeedId).listen((newsfeed) {
      userName = newsfeed.userName ?? "";
      profilePicture = newsfeed.profilePicture ?? "";
      newPostDescription = newsfeed.description ?? "";
      mNewsFeed = newsfeed;
      _notifySafety();
    });
  }

  void onImageChosen(File imageFile){
    chosenImageFile = imageFile;
    _notifySafety();
  }

  void onTapDeleteImage(){
    chosenImageFile = null;
    _notifySafety();
  }

  void onNewPostTextChanged(String newPostDescription){
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost(){
    if(newPostDescription.isEmpty){
      isAddNewPostError = true;
      _notifySafety();
      return Future.error("Error");
    }
    else{
      isLoading = true;
      _notifySafety();
      isAddNewPostError = false;
      if(isInEditMode){
        return _editNewsFeedPost().then((value){
          isLoading = false;
          _notifySafety();
          _sendAnalyticsData(editPostAction, {postId: mNewsFeed?.id.toString() ?? ""});
        });
      }else{
        return _createNewNewsfeedPost().then((value){
          isLoading = false;
          _notifySafety();
          _sendAnalyticsData(addNewPostAction, null);
        });
      }
      // return _model.addNewPost(newPostDescription);
    }
  }

  void _notifySafety(){
    if(!isDisposed){
      notifyListeners();
    }
  }

  Future<dynamic> _editNewsFeedPost(){
    mNewsFeed?.description = newPostDescription;
    if(mNewsFeed != null){
      return _model.editPost(mNewsFeed!,chosenImageFile);
    }else {
      return Future.error("Error");
    }
  }

  Future<void> _createNewNewsfeedPost(){
    return _model.addNewPost(newPostDescription,chosenImageFile);
  }

  ///Analytics
  void _sendAnalyticsData(String name, Map<String, String>? parameters) async{
    await FirebaseAnalyticsTracker().logEvent(name, parameters);
  }

  @override
  void dispose(){
    super.dispose();
    isDisposed = true;
  }
}