
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hackathon_vegas/models/locker_model.dart';

final storage = const FlutterSecureStorage();

Future<void> saveLockerToken(LockerToken token) async {
  final jsonString = jsonEncode(token.toJson());
  await storage.write(key: 'locker_${token.lockerId}_token', value: jsonString);
}

Future<LockerToken?> getLockerToken(String lockerId) async {
  final jsonString = await storage.read(key: 'locker_${lockerId}_token');
  if (jsonString == null) return null;

  final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  return LockerToken.fromJson(jsonMap);
}

Future<void> deleteLockerToken(String lockerId) async {
  await storage.delete(key: 'locker_${lockerId}_token');
}

Future<void> deleteAllLockerTokens() async {
  final allKeys = await storage.readAll();
  for (final key in allKeys.keys) {
    if (key.startsWith('locker_') && key.endsWith('_token')) {
      await storage.delete(key: key);
    }
  }
}

