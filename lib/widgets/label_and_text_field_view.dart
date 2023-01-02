import 'package:flutter/material.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/widgets/typical_text.dart';

class LabelAndTextFieldView extends StatelessWidget {
  String label;
  String hint;
  Function onChanged;
  bool isSecure;

  LabelAndTextFieldView({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.isSecure = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypicalText(label,Colors.black,TEXT_REGULAR),
        SizedBox(height: MARGIN_MEDIUM,),
        Container(
            child: TextField(
              maxLines: 1,
              controller: TextEditingController(
                  text: ""
              ),

              onChanged: (text){
                onChanged(text);
                },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
                      borderSide: BorderSide(width: 1,color: Colors.grey)
                  ),
                  hintText: hint
              ),
            )
        ),
      ],
    );
  }
}
