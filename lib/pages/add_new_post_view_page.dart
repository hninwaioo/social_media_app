import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/widgets/typical_text.dart';
import '../blocs/add_new_post_bloc.dart';
import '../resources/dimens.dart';
import '../viewitems/news_feed_item_view.dart';

class AddNewPostViewPage extends StatelessWidget {
  final int? newsfeedId;

  const AddNewPostViewPage({Key? key, this.newsfeedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostBloc(newsfeedId: newsfeedId),
      child: Selector<AddNewPostBloc, bool>(
        selector: (context, bloc) => bloc.isLoading,
        builder: (context, isLoading, child) =>
            Stack(
              children: [
                Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    centerTitle: false,
                    title: Container(
                      margin: EdgeInsets.only(left: MARGIN_MEDIUM),
                      child: TypicalText("Add New Post", Colors.black, TEXT_REGULAR_1X,isFontWeight: true,),
                    ),

                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_new,color: Colors.black,size: MARGIN_XLARGE,),
                    ),
                  ),

                  body: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: MARGIN_XLARGE),
                      padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          ProfileImageAndNameSectionView(),
                          SizedBox(height: MARGIN_MEDIUM_LARGE,),
                          AddNewPostTextFieldView(),
                          SizedBox(height: MARGIN_MEDIUM,),
                          PostDescriptionErrorView(),
                          SizedBox(height: MARGIN_MEDIUM_2,),
                          PostImageView(),
                          SizedBox(height: MARGIN_MEDIUM_LARGE,),
                          PrimaryButtonPostView(),
                          SizedBox(height: MARGIN_MEDIUM_LARGE,),

                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: isLoading,
                    child: Container(
                      color: Colors.black12,
                      child: const Center(
                        child: LoadingView(),
                      ),
                    )
                )
              ],
            ),
      ),

    );
  }
}


class PrimaryButtonPostView extends StatelessWidget {
  const PrimaryButtonPostView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) =>
      PostButtonView(
        themeColor: bloc.themeColor,
      ),
    );
  }
}

class ProfileImageAndNameSectionView extends StatelessWidget {
  const ProfileImageAndNameSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc,child) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileImageView(
              profileImage: bloc.profilePicture??""
          ),
          SizedBox(width: MARGIN_MEDIUM_2,),
          TypicalText(bloc.userName??"", Colors.black, TEXT_REGULAR_1X,isFontWeight: true,)
        ],
      ),
    );
  }
}

class AddNewPostTextFieldView extends StatelessWidget {
  const AddNewPostTextFieldView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
        builder: (context, bloc, child) =>
            SizedBox(
              height: 200,
              // ADD_NEW_POST_TEXTFIELD_HEIGHT,
              child: TextField(
                maxLines: 24,
                controller: TextEditingController(text: bloc.newPostDescription),
                onChanged: (text){
                  bloc.onNewPostTextChanged(text);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
                    borderSide: BorderSide(width: 1,color: Colors.grey)
                  ),
                  hintText: "What's on your mind?"
                ),
              ),
            )
    );
  }
}

class PostDescriptionErrorView extends StatelessWidget {
  const PostDescriptionErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) =>
      Visibility(
        visible: bloc.isAddNewPostError,
          child: TypicalText("Post should not be empty", Colors.red, TEXT_REGULAR,isFontWeight: true),

      ),
    );
  }
}

class PostButtonView extends StatelessWidget {
  final Color themeColor;
  const PostButtonView({Key? key, this.themeColor = Colors.black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
        builder: (context,bloc,child) =>
            GestureDetector(
              onTap: (){
                bloc.onTapAddNewPost().then((value){
                  Navigator.pop(context);
                });
              },
              child: Container(
                width: double.infinity,
                height: MARGIN_XXLARGE,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(MARGIN_MEDIUM_LARGE)
                ),
                child: Center(
                  child: TypicalText("POST", Colors.white,TEXT_REGULAR_2x,isFontWeight: true),
                ),
              ),
            )
    );
  }
}

class PostImageView extends StatelessWidget{
  const PostImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
        builder: (context, bloc, child) => Container(
          padding: EdgeInsets.all(MARGIN_MEDIUM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Stack(
            children: [
              Container(
                child: (bloc.chosenImageFile == null)
                ?
                GestureDetector(
                  child: SizedBox(
                    height: 250,
                    child: Image.network(
                        "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?b=1&s=170667a&w=0&k=20&c=LEhQ7Gji4-gllQqp80hLpQsLHlHLw61DoiVf7XJsSx0=",
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () async{
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery);
                    if(image != null){
                      bloc.onImageChosen(File(image.path));
                    }
                  },
                ) :
                    SizedBox(
                      height: 250,
                      child: Image.file(bloc.chosenImageFile ?? File(""),
                      fit: BoxFit.cover,
                      ),
                    )
              ),
              Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: bloc.chosenImageFile != null,
                    child: GestureDetector(
                      onTap: (){
                        bloc.onTapDeleteImage();
                      },
                      child: Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                    ),
                ),
              )
            ],
          ),
        )
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: SizedBox(
          width: MARGIN_XXLARGE,
          height: MARGIN_XXLARGE,
          child: LoadingIndicator(
            indicatorType: Indicator.audioEqualizer,
            colors: [Colors.white],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}


