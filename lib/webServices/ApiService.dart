import 'dart:convert';
import 'package:flutter_player/utils/ApiUrls.dart';
import 'package:http/http.dart' as http;
import '../model/task_model.dart';

class ApiService {
  final String wakeup = ApiUrls.modelServiceAPI;
  static Future<Game> fetchGameData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedResponseBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponseBody);
      // print('success to load tasks:${Game.fromJson(data)} ');
      return Game.fromJson(data);
    } else {
      throw Exception('Failed to load game data');
    }
  }

  static Future<void> wakeUp() async {
    final url = Uri.parse('${ApiUrls.modelServiceAPI}/wakeup');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Wakeup successful: ${response.body}');
      } else {
        print('Failed to wake up: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during wakeup: $e');
    }
  }

  static Future<void> wakeUpbackend() async {
    final url = Uri.parse('${ApiUrls.modelServiceAPI}/wakeup');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Wakeup successful: ${response.body}');
      } else {
        print('Failed to wake up: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during wakeup: $e');
    }
  }
}
