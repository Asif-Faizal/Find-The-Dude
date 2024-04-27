// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      'http://your-server-ip:3000/api/images'; // Update with your API endpoint

  static Future<List<String>> fetchImageUrls() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> imageUrls =
            data.map((imageUrl) => imageUrl.toString()).toList();
        return imageUrls;
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error getting images: $e');
      throw Exception('Failed to load images');
    }
  }
}
