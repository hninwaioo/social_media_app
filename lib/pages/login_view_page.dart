import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/pages/add_new_post_view_page.dart';
import 'package:social_media_app/pages/news_feed_home_view_page.dart';
import 'package:social_media_app/pages/register_view_page.dart';
import 'package:social_media_app/resources/colors.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';
import 'package:social_media_app/widgets/typical_text.dart';
import 'package:social_media_app/utils/extensions.dart';
import '../blocs/login_bloc.dart';
import '../resources/strings.dart';
import '../widgets/label_and_text_field_view.dart';

class LoginViewPage extends StatelessWidget {
  const LoginViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (context) => LoginBloc(),
        child: Scaffold(
        body:
          Selector<LoginBloc, bool>(
            selector: (context, bloc) => bloc.isLoading,
            builder: (context, isLoading, child) =>
                Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: MARGIN_XXLARGE,
                            bottom: MARGIN_MEDIUM_LARGE,
                            left: MARGIN_XLARGE,
                            right: MARGIN_XLARGE
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TypicalText(LBL_LOGIN, Colors.black, TEXT_HEADING_2x,isFontWeight: true,),
                            const SizedBox(height: MARGIN_XXLARGE,),

                            Consumer<LoginBloc>(
                              builder: (context,bloc,child) =>
                                  LabelAndTextFieldView(
                                      label: LBL_EMAIL,
                                      hint: HINT_EMAIL,
                                      onChanged: (email) {
                                        bloc.onEmailChanged(email);
                                  }),
                            ),

                            SizedBox(height: MARGIN_XXLARGE,),

                            Consumer<LoginBloc>(
                              builder: (context,bloc,child) =>
                                  LabelAndTextFieldView(
                                      label: LBL_PASSWORD,
                                      hint: HINT_PASSWORD,
                                      onChanged: (password){
                                        bloc.onPasswordChanged(password);
                                      },
                                    isSecure: true,
                                      ),
                            ),

                            SizedBox(height: MARGIN_XXLARGE,),

                            Consumer<LoginBloc>(
                                builder: (context, bloc, child) =>
                                    TextButton(
                                      onPressed: () {
                                        bloc.onTapLogin()
                                            .then((_) => navigateToScreen(
                                            context, const NewsFeedHomeViewPage()
                                        )).catchError((error) => showSnackBarWithMessage(
                                            context, error.toString()
                                        ));
                                        },
                                      child: PrimaryButtonView(
                                        label: LBL_LOGIN,
                                      )
                                      // TypicalText(
                                      //    LBL_LOGIN,Colors.white,TEXT_REGULAR_1X
                                      // ),
                                    )

                                // GestureDetector(
                                //   onTap: (){
                                //     bloc.onTapLogin()
                                //         .then((_) => navigateToScreen(
                                //         context, const NewsFeedHomeViewPage()
                                //     )).catchError((error) => showSnackBarWithMessage(
                                //         context, error.toString()
                                //     ));
                                //   },
                                //   child: Container(
                                //     width: double.infinity,
                                //     height: MARGIN_XXLARGE,
                                //     decoration: BoxDecoration(
                                //         color: Colors.black,
                                //         borderRadius: BorderRadius.circular(MARGIN_MEDIUM_LARGE)
                                //     ),
                                //     child: Center(
                                //       child: TypicalText(LBL_LOGIN, Colors.white,TEXT_REGULAR_1X,isFontWeight: true),
                                //     ),
                                //   ),
                                // )
                            ),
                            const SizedBox(
                              height: MARGIN_XXLARGE,
                            ),
                            Center(child: TypicalText("OR", Colors.black, TEXT_REGULAR_2x)),

                            const SizedBox(
                              height: MARGIN_XLARGE,
                            ),
                            const RegisterTriggerView()
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: isLoading,
                        child: Container(
                            color: Colors.black12,
                            child: Center(
                              child: LoadingView(),
                            )
                        )
                    )
                  ],
                ),
          ),
        
        ),
      );
  }
}

class RegisterTriggerView extends StatelessWidget {
  const RegisterTriggerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TypicalText(LBL_DONT_HAVE_AN_ACCOUNT, TEXT_PRIMARY_COLOR, TEXT_REGULAR),
        SizedBox(width: MARGIN_SMALL,),
        GestureDetector(
          onTap: () => navigateToScreen(
            context,
            RegisterViewPage()
          ),
          child: Text(
            LBL_REGISTER,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline
            ),
          ),
        )
      ],
    );
  }
}

// class PrimaryButtonView extends StatelessWidget {
//   const PrimaryButtonView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AddNewPostBloc>(
//         builder: (context,bloc,child) =>
//             GestureDetector(
//               onTap: (){
//                 bloc.onTapAddNewPost().then((value){
//                   Navigator.pop(context);
//                 });
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: MARGIN_XXLARGE,
//                 decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(MARGIN_MEDIUM_LARGE)
//                 ),
//                 child: Center(
//                   child: TypicalText("POST", Colors.white,TEXT_REGULAR_2x,isFontWeight: true),
//                 ),
//               ),
//             )
//     );
//   }
// }

