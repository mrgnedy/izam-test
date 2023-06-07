import 'package:daftra/const/resource.dart';
import 'package:daftra/core/const/colors.dart';
import 'package:daftra/core/const/styles.dart';
import 'package:daftra/core/helperWidgets/app_textfield.dart';
import 'package:daftra/core/utils/extensions.dart';
import 'package:daftra/core/utils/result_state.dart';
import 'package:daftra/core/utils/snack_bar.dart';
import 'package:daftra/features/auth/data/models/auth_state_model.dart';
import 'package:daftra/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: OrientationBuilder(builder: (context, orientation) {
            return Flex(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.values[1 - orientation.index],
              children: [
                Image.asset(R.ASSETS_IMAGES_LOGO_PNG),
                55.allPad,
                Material(
                  elevation: 5,
                  shadowColor: Colors.grey[50],
                  borderRadius: 20.brc,
                  child: Container(
                    width: double.infinity.clamp(0.0, 350),
                    padding: 30.padH + 40.padV,
                    decoration: BoxDecoration(
                      color: AppColors.containerWhite,
                      borderRadius: 20.brc,
                    ),
                    child: BlocConsumer<AuthCubit, AuthStateModel>(
                      listener: _authCubitListener,
                      builder: (context, state) {
                        final cubit = BlocProvider.of<AuthCubit>(context);
                        return LoginForm(cubit: cubit);
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  _authCubitListener(BuildContext context, AuthStateModel state) {
    if (state.state is SuccessResult) {
      final count = state.state.getSuccessData();
      AppSnackBar.show(
        context,
        isError: false,
        message: "Logged In Successfully (${count}) times, Welcome Baack!",
      );
    } else if (state.state is ErrorResult) {
      final error = state.state.getErrorMessage();
      AppSnackBar.show(
        context,
        isError: true,
        message: error!,
      );
    }
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.cubit,
  });

  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //TODO: Add string literals to seprate file for easier localization impl. in the future
        const Text("Welcome, log In", style: AppStyles.title),
        30.vPad,
        AppTextField(
          label: "Email Address",
          onChanged: cubit.onEmailChanged,
          validationError: cubit.state.email.errorText,
        ),
        8.vPad,
        AppTextField(
          label: "Password",
          onChanged: cubit.onPasswordChanged,
          validationError: cubit.state.password.errorText,
        ),
        Padding(
          padding: 16.padV,
          child: const Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text("Forgot Password?")),
        ),
        LoginButton(onTap: cubit.login, state: cubit.state.state)
      ],
    );
  }
}
