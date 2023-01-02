import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/pages/add_new_post_view_page.dart';
import 'package:social_media_app/resources/colors.dart';
import 'package:social_media_app/resources/strings.dart';
import 'package:social_media_app/utils/extensions.dart';
import '../blocs/register_bloc.dart';
import '../resources/dimens.dart';
import '../widgets/label_and_text_field_view.dart';
import '../widgets/typical_text.dart';

class RegisterViewPage extends StatelessWidget {
  const RegisterViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        body:
        SingleChildScrollView(
          child: Selector<RegisterBloc, bool>(
            selector: (context, bloc) => bloc.isLoading,
            builder: (context, isLoading, child) =>
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: MARGIN_XXLARGE,
                          bottom: MARGIN_MEDIUM_LARGE,
                          left: MARGIN_XLARGE,
                          right: MARGIN_XLARGE
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypicalText(LBL_REGISTER, Colors.black, TEXT_HEADING_2x, isFontWeight: true,),
                          const SizedBox(height: MARGIN_XXLARGE,),

                          Consumer<RegisterBloc>(
                            builder: (context,bloc,child) =>
                                LabelAndTextFieldView(
                                    label: LBL_EMAIL,
                                    hint: HINT_EMAIL,
                                    onChanged: (email){
                                bloc.onEmailChanged(email);
                                }),
                          ),

                          SizedBox(height: MARGIN_XLARGE,),

                          Consumer<RegisterBloc>(
                            builder: (context,bloc,child) =>
                                LabelAndTextFieldView(
                                    label: LBL_USER_NAME,
                                    hint: HINT_USER_NAME,
                                    onChanged: (username){
                                bloc.onUserNameChanged(username);
                                }),
                          ),

                          SizedBox(height: MARGIN_XLARGE,),

                          Consumer<RegisterBloc>(
                            builder: (context,bloc,child) =>
                                LabelAndTextFieldView(
                                    label: LBL_PASSWORD,
                                    hint: HINT_PASSWORD,
                                    onChanged: (password){
                                bloc.onPasswordChanged(password);
                                }),
                          ),

                          SizedBox(height: MARGIN_XXLARGE,),

                          Consumer<RegisterBloc>(
                              builder: (context, bloc, child) =>
                                  // TextButton(
                                  //   onPressed: () {
                                  //     bloc.onTapRegister()
                                  //         .then((value) => Navigator.pop(context))
                                  //     .catchError((error) => showSnackBarWithMessage(
                                  //         context, error.toString()
                                  //     ));
                                  //   },
                                  //   child: TypicalText(
                                  //     LBL_REGISTER,Colors.white,TEXT_REGULAR_1X
                                  // ),
                                  // )

                              GestureDetector(
                                onTap: (){
                                  bloc.onTapRegister()
                                      .then((value) => Navigator.pop(context))
                                      .catchError((error) => showSnackBarWithMessage(
                                      context, error.toString()
                                  ));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: MARGIN_XXLARGE,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(MARGIN_MEDIUM_LARGE)
                                  ),
                                  child: Center(
                                    child: TypicalText(LBL_LOGIN, Colors.white,TEXT_REGULAR_1X,isFontWeight: true),
                                  ),
                                ),
                              )

                          ),
                          const SizedBox(
                            height: MARGIN_XLARGE,
                          ),

                          Center(child: TypicalText("OR", Colors.black, TEXT_REGULAR_2x)),

                          const SizedBox(
                            height: MARGIN_XLARGE,
                          ),
                          const LoginTriggerView(),

                          const SizedBox(
                            height: MARGIN_XLARGE,
                          ),
                        ],
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
      ),
    );
  }
}

class LoginTriggerView extends StatelessWidget {
  const LoginTriggerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TypicalText(LBL_ALREADY_HAVE_AN_ACCOUNT, TEXT_PRIMARY_COLOR, TEXT_REGULAR),
        SizedBox(width: MARGIN_SMALL,),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            },
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

