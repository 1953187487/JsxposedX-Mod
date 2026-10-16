import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptUtil {
  EncryptUtil._();

  static String aesEncrypt(String plaintext, String password) {
    final encrypter = Encrypter(AES(_keyFromPassword(password)));
    final encrypted = encrypter.encrypt(plaintext, iv: _iv);
    return encrypted.base64;
  }

  static String aesDecrypt(String ciphertext, String password) {
    final encrypter = Encrypter(AES(_keyFromPassword(password)));
    return encrypter.decrypt64(ciphertext, iv: _iv);
  }

  static Key _keyFromPassword(String password) {
    final digest = sha256.convert(utf8.encode(password));
    return Key(Uint8List.fromList(digest.bytes));
  }

  static final IV _iv = IV.fromLength(16);
}
