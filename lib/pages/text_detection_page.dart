import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/pages/add_new_post_view_page.dart';
import 'package:social_media_app/utils/extensions.dart';

import '../blocs/text_detection_bloc.dart';
import '../resources/dimens.dart';
import '../resources/strings.dart';
import '../widgets/primary_button_view.dart';

class TextDetectionPage extends StatelessWidget {
  const TextDetectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TextDetectionBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leadingWidth: 100,
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                SizedBox(width: MARGIN_MEDIUM,),
                Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                  size: MARGIN_XLARGE,
                ),
                SizedBox(width: MARGIN_SMALL,),
                Text(LBL_BACK, style: TextStyle(
                  color: Colors.black,
                  fontSize: TEXT_REGULAR_1X,
                  fontWeight: FontWeight.bold
                ),
                )
              ],
            ),
          ),
        ),

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_LARGE),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<TextDetectionBloc>(
                    builder: (context, bloc, child){
                      return Visibility(
                        visible: bloc.chosenImageFile != null,
                          child: Image.file(bloc.chosenImageFile ?? File(""),
                              width: 300,
                            height: 300,
                          )
                      );
                    }
                ),
                SizedBox(height: MARGIN_MEDIUM_LARGE,),
                Consumer<TextDetectionBloc>(
                    builder: (context, bloc, child) =>
                        GestureDetector(
                      onTap: (){
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((pickedImageFile) async{
                              var bytes = await pickedImageFile?.readAsBytes();
                              bloc.onImageChosen(
                                  File(pickedImageFile?.path??""),
                                  bytes ?? Uint8List(0),
                              );
                        }).catchError((error){
                          showSnackBarWithMessage(context, "Image Cannot be picked");
                        });
                      },
                          child: PrimaryButtonView(
                            label: LBL_CHOOSE_IMAGE,
                          ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
