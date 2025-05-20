import 'dart:convert';

import 'package:hackathon_vegas/models/locker_model.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  Future<bool> checkAvailability() async {
    return await NfcManager.instance.isAvailable();
  }

  Future<void> writeNfcTag(LockerToken token) async {
    try {
      final tokenJson = jsonEncode(token.toJson());
      final ndefRecord = NdefRecord.createText(tokenJson);
      final ndefMessage = NdefMessage([ndefRecord]);
      
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null) {
              throw 'Tag não suporta NDEF';
            }
            
            if (!ndef.isWritable) {
              throw 'Tag não é gravável';
            }
            
            await ndef.write(ndefMessage);
            
            NfcManager.instance.stopSession();
          } catch (e) {
            NfcManager.instance.stopSession(errorMessage: e.toString());
            rethrow;
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}