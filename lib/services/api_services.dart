// Services
import 'dart:convert';

import 'package:hackathon_vegas/models/invoice_model.dart';
import 'package:hackathon_vegas/models/locker_model.dart';
import 'package:hackathon_vegas/models/locker_token.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://0.0.0.0:8080';
  final http.Client _client = http.Client();

  Future<List<Locker>> getLockers() async {
    final response = await _client.get(Uri.parse('$_baseUrl/lockers'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['error'] != null) {
        throw Exception(data['error']);
      }

      final List<dynamic> lockersJson = data['data'];
      return lockersJson.map((json) => Locker.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lockers');
    }
  }

  Future<LockerToken> useLocker(int lockerId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/use_locker/$lockerId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['error'] != null) {
        throw Exception(data['error']);
      }

      return LockerToken.fromJson(data['data']);
    } else {
      throw Exception('Failed to use locker');
    }
  }

  Future<Invoice> payForUsage(int lockerId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/pay_for_usage/$lockerId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['error'] != null) {
        throw Exception(data['error']);
      }

      return Invoice.fromJson(data['data']['invoice']);
    } else {
      throw Exception('Failed to generate invoice');
    }
  }

  Future<LockerToken> getPaymentReceipt(String paymentHash) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/payment_receipt/$paymentHash'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return LockerToken.fromJson(data);
    } else {
      throw Exception('Payment not confirmed');
    }
  }

  Future<List<Locker>> getMyLockers(LockerToken token) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/my_lockers'),
      headers: {
        'Authorization': 'Bearer ${jsonEncode(token.toJson())}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['error'] != null) {
        throw Exception(data['error']);
      }

      final List<dynamic> lockersJson = data['data']['lockers'];
      return lockersJson.map((json) => Locker.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch my lockers');
    }
  }
}
