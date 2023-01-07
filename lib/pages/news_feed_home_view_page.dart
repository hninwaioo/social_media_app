import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/news_feed_bloc.dart';
import 'package:social_media_app/pages/login_view_page.dart';
import 'package:social_media_app/pages/text_detection_page.dart';
import 'package:social_media_app/resources/colors.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/widgets/typical_text.dart';
import '../data/vos/news_feed_vo.dart';
import '../viewitems/news_feed_item_view.dart';
import 'add_new_post_view_page.dart';

class NewsFeedHomeViewPage extends StatelessWidget {
  const NewsFeedHomeViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsFeedBloc(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.only(left: MARGIN_MEDIUM),
              child: Center(
                  child: TypicalText("Social",Colors.black,TEXT_REGULAR_1X,isFontWeight: true)
            ),
            ),
            actions:[
              Container(
                  margin: EdgeInsets.only(right: MARGIN_MEDIUM_2),
                  child: GestureDetector(
                    onTap: (){
                      _navigateToTextDetectorScreen(context);
                    },
                      child: Icon(Icons.face,color: PRIMARY_HINT_COLOR,)
                  )
              ),
              Container(
                  margin: EdgeInsets.only(right: MARGIN_MEDIUM_2),
                  child: Icon(Icons.search,color: PRIMARY_HINT_COLOR,)
              ),
              Consumer<NewsFeedBloc>(
                  builder: (context, bloc, child) => GestureDetector(
                    onTap: (){
                      bloc.onTapLogout().then((_){
                        navigateToScreen(context, LoginViewPage());
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: MARGIN_MEDIUM_LARGE),
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: MARGIN_MEDIUM_LARGE,
                      ),
                    ),
                  )
              )
            ]
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Selector<NewsFeedBloc,List<NewsFeedVO>?>(
                selector: (context,bloc) => bloc.newsFeed,
                shouldRebuild: (previous, next) => true,
                builder: (context, newsFeedList, child) =>

                    // TypicalText("text", Colors.black, 16)
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: newsFeedList?.length??0,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, int index) {
                    return
                      NewsFeedItemView(
                                newsFeedVO: newsFeedList?[index],
                                onTapDelete: (newsFeedId){
                                  var bloc = Provider.of<NewsFeedBloc>(context,listen: false);
                                  bloc.onTapDeletePost(newsFeedId);
                                },
                                onTapEdit: (newsFeedId){
                                  Future.delayed(const Duration(milliseconds: 1000))
                                      .then((value){
                                    _navigateToEditPostScreen(context,newsFeedId);
                                  });
                                },

                    );
                  },
                ),

              // Consumer<NewsFeedBloc>(
              //     builder: (context, bloc, child) =>

                // TypicalText("HHHH", Colors.black, 16)
                // Center(child: TypicalText("HHHH", Colors.black, 16))

                // Center(child: TypicalText("HHHH", Colors.black, 16))

                // ListView.builder(
                //   shrinkWrap: true,
                //           itemCount: newsFeedList?.length,
                //           physics: NeverScrollableScrollPhysics(),
                //         itemBuilder: (context, index) {
                //
                //         return
                //           // Center(child: TypicalText("HHHH", Colors.black, 16));
                //
                //           NewsFeedItemView(
                //           newsFeedVO: newsFeedList?[index],
                //           onTapDelete: (newsFeedId){
                //             var bloc = Provider.of<NewsFeedBloc>(context,listen: false);
                //             bloc.onTapDeletePost(newsFeedId);
                //           },
                //           onTapEdit: (newsFeedId){
                //             Future.delayed(const Duration(milliseconds: 1000))
                //                 .then((value){
                //               _navigateToEditPostScreen(context,newsFeedId);
                //             });
                //           },
                //         );
                //
                //       },),

              )
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            _navigateToAddNewPostScreen(context);

            // Firebase Crashlytics
            // FirebaseCrashlytics.instance.crash();
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add_sharp,color: Colors.white,),
        ),
      ),

    );
  }

  Future<dynamic> _navigateToAddNewPostScreen(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddNewPostViewPage()
    )
    );
  }

  Future<dynamic> _navigateToTextDetectorScreen(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(
        builder: (context) => TextDetectionPage()
    )
    );
  }

  Future<dynamic> _navigateToEditPostScreen(BuildContext context,int newsfeedId) {
    return Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddNewPostViewPage(
          newsfeedId: newsfeedId
        )
    )
    );
  }
}
