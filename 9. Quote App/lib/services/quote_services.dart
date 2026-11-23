import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String _endpoint = 'https://dummyjson.com/quotes/random';

  Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse(_endpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'API request failed with status ${response.statusCode}.',
        );
      }

      if (response.body.trim().isEmpty) {
        throw Exception('Empty response received from server.');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected JSON format received.');
      }

      return Quote.fromJson(decoded);
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException {
      throw Exception('Failed to parse server response as JSON.');
    } catch (e) {
      rethrow;
    }
  }
}
