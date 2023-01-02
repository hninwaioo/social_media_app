import 'package:flutter/material.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/widgets/typical_text.dart';

class PrimaryButtonView extends StatelessWidget {
  final String label;
  final Color themeColor;
  const PrimaryButtonView({
    Key? key,
    required this.label,
    this.themeColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MARGIN_XXLARGE,
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM_LARGE)
      ),
      child: Center(child: TypicalText(label, Colors.white, TEXT_REGULAR_1X,isFontWeight: true,isCenterText: true,)),
    );
  }
}