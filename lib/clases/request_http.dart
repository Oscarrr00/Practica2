import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHttp {
  final String url = "https://api.audd.io/";

  RequestHttp._internal();

  static final RequestHttp _httpHandler = RequestHttp._internal();

  factory RequestHttp() {
    return _httpHandler;
  }

  Future<Map<String, dynamic>> post_request(
      String audio, String? api_key) async {
    Map<String, dynamic> body = {
      "api_token": "${api_key}",
      "audio": "${audio}",
      "return": 'apple_music,spotify,deezer',
      "method": 'recognize',
    };

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('No se encontro la cancion');
    }
  }
}
