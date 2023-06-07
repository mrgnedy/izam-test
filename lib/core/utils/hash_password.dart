import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String password){
  final bytes = utf8.encode(password);
  final hashedPassword = sha256.convert(bytes).toString();
  return hashedPassword;
}