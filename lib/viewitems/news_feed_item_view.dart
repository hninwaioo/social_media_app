import 'package:flutter/material.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/resources/colors.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/widgets/typical_text.dart';

class NewsFeedItemView extends StatelessWidget {
  NewsFeedVO? newsFeedVO;
  final Function(int) onTapDelete;
  final Function(int) onTapEdit;
  NewsFeedItemView({required this.newsFeedVO, required this.onTapDelete, required this.onTapEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2,vertical: MARGIN_MEDIUM_2),
          child: Row(
            children: [
              ProfileImageView(
                  profileImage:
                  // "https://w0.peakpx.com/wallpaper/224/824/HD-wallpaper-beauty-red-model-rose-girl-hand-flower-face-woman.jpg"
                  newsFeedVO?.profilePicture

              ),
              SizedBox(width: MARGIN_MEDIUM_2,),
              NameLocationAndTimeAgoView(
                  userName:
                  // "Hnin Wai"
              newsFeedVO?.userName,
              ),
              Spacer(),
              MoreButtonView(
                onTapDelete: (){
                  onTapDelete(newsFeedVO?.id ??0 );
                },
                onTapEdit: (){
                  onTapEdit(newsFeedVO?.id ??0 );
                },
              )
            ],
          ),
        ),

        SizedBox(height: MARGIN_MEDIUM_2,),

        Container(
          margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: PostImageAndDescriptionView(
            postImage:
            // "https://cf.ltkcdn.net/life-with-pets/find-your-pet/images/std-xs/321177-340x227-cat-love.jpg",
            newsFeedVO?.postImage,
            postDescription:
            // "Cats have very soft coats of fur, which makes them look like soft rugs, and once you pet them, you don't want to stop because they are so soft. My pet cat loves to play with my family and me. My pet cat is the most attached to the person who gives him or her treats. All my friends and relatives also love my pet cat "
            newsFeedVO?.description,
          ),
        ),

        SizedBox(height: MARGIN_MEDIUM_2,),
        SeeCommentAndLikeView(),
        SizedBox(height: MARGIN_MEDIUM_LARGE,),

      ],
    );
  }
}

class MoreButtonView extends StatelessWidget {
  final Function onTapDelete;
  final Function onTapEdit;

  MoreButtonView({
    required this.onTapDelete,
    required this.onTapEdit
  });

  @override
  Widget build(BuildContext context) {
    return
      PopupMenuButton(
          icon: Icon(Icons.more_vert_sharp, color: PRIMARY_HINT_COLOR,),
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: (){
              onTapEdit();
            },
              child: Text("Edit"),
            value: 1,
          ),
            PopupMenuItem(
            onTap: (){
              onTapDelete();
              },
            child: Text("Delete"),
            value: 1,
          ),
        ],
      );
  }
}

class ProfileImageView extends StatelessWidget {

  String? profileImage;
  ProfileImageView({required this.profileImage});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: CircleAvatar(
        backgroundImage: NetworkImage(profileImage??""),
        radius: 100,
      ),
    );
  }
}

class NameLocationAndTimeAgoView extends StatelessWidget {
  String? userName;
  NameLocationAndTimeAgoView({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TypicalText(userName ?? "", Colors.black, TEXT_REGULAR_1X,isFontWeight: true,),
              TypicalText("  -  ", PRIMARY_HINT_COLOR, TEXT_REGULAR),
              TypicalText("1 hours", PRIMARY_HINT_COLOR, TEXT_REGULAR_SMALL)
            ],
          ),
          TypicalText("Yangon", PRIMARY_HINT_COLOR, TEXT_REGULAR_SMALL)
        ],
      ),
    );
  }
}

class PostImageAndDescriptionView extends StatelessWidget {
  String? postImage;
  String? postDescription;
  PostImageAndDescriptionView({required this.postImage, required this.postDescription});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            child:  Image.network(
              postImage??"",
              fit:BoxFit.cover,
              height: 180,
              width: double.infinity,
            )
        ),

        SizedBox(height: MARGIN_MEDIUM_2,),

        TypicalText(
            postDescription??"",
            Colors.black,
            isCenterText: false,
            TEXT_REGULAR
        )
      ],
    );
  }
}

class SeeCommentAndLikeView extends StatelessWidget {
  const SeeCommentAndLikeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Row(
        children: [
          TypicalText("See Comments", PRIMARY_HINT_COLOR, TEXT_REGULAR_SMALL),

          Spacer(),

          Icon(Icons.messenger_outline, color: PRIMARY_HINT_COLOR,),

          SizedBox(width: MARGIN_SMALL,),

          Icon(Icons.favorite_outline, color: PRIMARY_HINT_COLOR,)

        ],
      ),
    );
  }
}
