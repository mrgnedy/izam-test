import 'package:daftra/core/utils/result_state.dart';

enum FieldType { email, password }

// enum Result { init, loading, success, done, error }

class FieldItem {
  final String name;
  final FieldType? type;
  final String errorText;
  const FieldItem({
      this.name = '',
      this.type ,
      this.errorText ='',
  });
bool get isValid => name.isNotEmpty && errorText.isEmpty;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FieldItem &&
        other.name == name &&
        other.type == type &&
        other.errorText == errorText;
  }

  @override
  int get hashCode => name.hashCode ^ type.hashCode ^ errorText.hashCode;

  FieldItem copyWith({
    String? name,
    FieldType? type,
    String? errorText,
  }) {
    return FieldItem(
      name: name ?? this.name,
      type: type ?? this.type,
      errorText: errorText ?? this.errorText,
    );
  }
}

class AuthStateModel {
  final FieldItem email;
  final FieldItem password;
  final Result state;

  const  AuthStateModel(
      {  this.email=const FieldItem(),   this.password=const FieldItem(),   this.state =const Result.init()});

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) return true;

    return other is AuthStateModel &&
        other.email == email &&
        other.password == password &&
        other.state == state;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ state.hashCode;

  AuthStateModel copyWith({
    FieldItem? email,
    FieldItem? password,
    Result? state,
  }) {
    return AuthStateModel(
      email: email ?? this.email,
      password: password ?? this.password,
      state: state ?? this.state,
    );
  }
}
