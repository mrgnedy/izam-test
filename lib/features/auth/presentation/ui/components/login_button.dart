
import 'package:daftra/core/const/colors.dart';
import 'package:daftra/core/const/styles.dart';
import 'package:daftra/core/utils/extensions.dart';
import 'package:daftra/core/utils/result_state.dart';
import 'package:daftra/features/auth/data/models/auth_state_model.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function() onTap;
  final Result state;
  const LoginButton(
      {super.key, required this.onTap, this.state = const Result.init()});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: state is LoadingResult
            ? null
            : BoxDecoration(
                color: state is ErrorResult
                    ? Colors.red
                    : AppColors.buttonBlue,
                borderRadius: 4.brc,
              ),
        child: state is  LoadingResult
            ? const Center(child: CircularProgressIndicator())
            : Padding(
        padding: 22.padH + 18.padV,

              child: Text(
                  "Login",
                  style: AppStyles.buttonText
                      .copyWith(color: AppColors.containerWhite),
                ),
            ),
      ),
    );
  }
}
