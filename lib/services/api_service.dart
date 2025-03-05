import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://your_server_ip:8000"; // Jina AI API adresi

  Future<String> getJinaResponse(String userQuery) async {
    final response = await http.post(
      Uri.parse("$baseUrl/search"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": userQuery}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["result"];
    } else {
      throw Exception("Jina AI çağrısı başarısız oldu");
    }
  }
}
