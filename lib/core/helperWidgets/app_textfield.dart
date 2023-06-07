import 'package:daftra/core/const/colors.dart';
import 'package:daftra/core/const/styles.dart';
import 'package:daftra/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String validationError;
  final Function(String?)? onChanged;
    AppTextField({
    super.key,
    this.label,
    this.onChanged,
    this.validationError = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: 22.padH + 18.padV,
            labelText: label,
            labelStyle: AppStyles.label,
            border: InputBorder.none,
            filled: true,
            fillColor: AppColors.shadowColor,
          ),
        ),
        AnimatedSwitcher(
          duration: 100.ms,
          transitionBuilder: (child, animation) {
            return ClipRRect(
              child: SlideTransition(
            
                position: animation.drive(Offset(0, -1.0).tweenTo(Offset(0,0))),
                child: child,
              ),
            );
          },
          child: Text(
            validationError,
            key:Key(validationError),
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
