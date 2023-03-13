import 'dart:convert';

import 'package:wingame/common/encrypt_service.dart';
class BidModel {
  String? amount;
  String? user_id;
  String? encryption_key;

  BidModel({
    this.amount,
    this.user_id,
    this.encryption_key,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'req_amount': amount,
      'user_id': user_id,
      'encryption_key': encryption_key,
      'req_message': "Debit",
    };
    return {'str': encryp(json.encode(map))};
  }
}