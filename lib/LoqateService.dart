// loqate_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logate_example/ConstantValues.dart';

class LoqateService {
  final String apiKey = Constants.apiSecretKey; // Replace with your actual API key

  // Method to search for address suggestions in Australia
  Future<List<String>> searchAddress(String query) async {
    final String url =
        'https://api.addressy.com/Capture/Interactive/Find/v1.10/json3.ws?Key=$apiKey&Text=$query&IsMiddleware=false&Language=en-gb&Limit=10&Countries=AU';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Items'] != null) {
        // Combine 'Text' and 'Description' for a complete suggestion
        return data['Items']
            .where((item) => item['Text'] != null && item['Description'] != null)
            .map<String>((item) => '${item['Text']}, ${item['Description']}')
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load address suggestions');
    }
  }

  // Method to get detailed address information based on the selected address
  Future<Map<String, String>> getAddressDetails(String query) async {
    final String url =
        'https://api.addressy.com/Capture/Interactive/Find/v1.10/json3.ws?Key=$apiKey&Text=$query&IsMiddleware=false&Language=en-gb&Limit=1&Countries=AU';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: $data');

      if (data['Items'] != null && data['Items'].isNotEmpty) {
        final item = data['Items'][0];

        // Extract full address and description
        final fullAddress = item['Text'] ?? '';
        final description = item['Description'] ?? '';

        // Example parsing logic (modify based on real data patterns)
        final streetNumber = fullAddress.split(' ').first;
        final streetName = fullAddress.substring(streetNumber.length).trim().split(',').first;
        final city = description.split(' ').first; // Use this if city is reliably first in description
        final postalCode = description.split(' ').last; // Use if postal code is reliably last

        return {
          'streetNumber': streetNumber,
          'streetName': streetName,
          'city': city,
          'state': '', // Not provided in current response
          'postalCode': postalCode,
        };
      }
    }
    throw Exception('Failed to load address details');
  }
}

