import 'dart:convert';
import 'package:agro_plus_app/config.dart';
import 'package:http/http.dart' as http;

String apiUrl = AppConfig.apiHostname;

Future<List<Map<String, dynamic>>> fetchCombinedData(String sellerId) async {
  try {
    print(sellerId);
    // Fetch product data
    final response = await http
        .get(Uri.parse('${AppConfig.apiHostname}getCombineData/$sellerId'));

    if (response.statusCode == 200) {
      final dynamic decodedData = json.decode(response.body);

      //if combined key exists
      if (decodedData.containsKey('combinedData')) {
        final List<dynamic> combinedData = decodedData['combinedData'];
        // Proceed to cast it to the desired type
        final List<Map<String, dynamic>> data =
            combinedData.cast<Map<String, dynamic>>();
        print(data);
        return data;
      } else {
        throw Exception('Key combinedData" not found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}
