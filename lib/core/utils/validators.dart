class Validators {
  Validators._();
  static String email(String name) =>
      !(RegExp(r'^[A-Za-z]{3}\.[0-9]{4}@izam\.co$').hasMatch(name) ||
              name.isEmpty)
          ? "Wrong email format"
          : "";
  static String password(String name) => !(RegExp(
            r'^(?=.*[0-9])(?=.*[!\$#^*])[a-zA-Z0-9!\$#^*]{8,}'
            
          ).hasMatch(name) ||
          name.isEmpty)
      ? "Wrong password format"
      : "";
}
