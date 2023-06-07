import 'package:bloc/bloc.dart';
import 'package:daftra/core/utils/extensions.dart';
import 'package:daftra/core/utils/result_state.dart';
import 'package:daftra/core/utils/validators.dart';
import 'package:daftra/features/auth/data/models/auth_state_model.dart';
import 'package:daftra/features/auth/data/repo.dart';
import 'package:drift/drift.dart';

class AuthCubit extends Cubit<AuthStateModel> {
  // There's a fancier way of implementing this feature by creating a behaviouralSubject for each input field
  // and in OnChange function of the textField we keep checking the input against the given RegEx if it matches
  // The input string is added to the sink of the input's stream or else, an error is added to sink,
  // Then by using RxDart's combineLatest we check the latest values added to the streams to make sure all fields
  // pass the validation check.
  AuthCubit(this.repo) : super(const AuthStateModel());
  final LocalDBRepo repo;
  onEmailChanged(String? email) {
    emit(state.copyWith(state: const Result.init()));
    final validationError = Validators.email(email ?? '');

    emit(
      state.copyWith(
        state: const Result.done(),
        email: state.email.copyWith(
          name: email,
          errorText: validationError,
        ),
      ),
    );
  }

  onPasswordChanged(String? password) {
    final validationError = Validators.password(password ?? '');
    emit(
      state.copyWith(
        state: const Result.done(),
        password: state.password.copyWith(
          name: password,
          errorText: validationError,
        ),
      ),
    );
  }

  login() async {
    emit(state.copyWith(state: const Result.loading()));
    if (state.email.isValid && state.password.isValid) {
      try {
        final loginCount =
            await repo.login(state.email.name, state.password.name);
        emit(state.copyWith(state: Result.success(loginCount)));
      } catch (e) {
        emit(state.copyWith(state: Result.error("$e")));
      }
    } else {
      emit(
        state.copyWith(
          state: const Result.error(
              "Log in failed please check your credentianls!"),
        ),
      );
    }
  }
}
