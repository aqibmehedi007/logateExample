import 'package:flutter/material.dart';
import 'LoqateService.dart';

class AddressSearchScreen extends StatefulWidget {
  @override
  _AddressSearchScreenState createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final LoqateService _loqateService = LoqateService();
  List<Map<String, String>> _suggestions = [];
  TextEditingController _controller = TextEditingController();

  // Controllers for each address field
  TextEditingController _streetNumberController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();

  void _searchAddress(String query) async {
    if (query.isNotEmpty) {
      final results = await _loqateService.searchAddress(query);
      setState(() {
        _suggestions = results;
      });
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  void _selectAddress(Map<String, String> selectedSuggestion) async {
    final details = await _loqateService.getAddressDetails(selectedSuggestion['Id']!);

    setState(() {
      _streetNumberController.text = details['streetNumber'] ?? '';
      _streetNameController.text = details['streetName'] ?? '';
      _cityController.text = details['city'] ?? '';
      _stateController.text = details['state'] ?? '';
      _postalCodeController.text = details['postalCode'] ?? '';
      _suggestions = [];
      _controller.text = '${selectedSuggestion['Text']}, ${selectedSuggestion['Description']}';
    });

    print("Selected Address Details: $details"); // Debug line to check details
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Address Search')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter Address'),
              onChanged: _searchAddress,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_suggestions[index]['Text']}, ${_suggestions[index]['Description']}'),
                    onTap: () {
                      _selectAddress(_suggestions[index]);
                    },
                  );
                },
              ),
            ),
            // Additional address fields
            TextField(
              controller: _streetNumberController,
              decoration: InputDecoration(labelText: 'Street Number'),
            ),
            TextField(
              controller: _streetNameController,
              decoration: InputDecoration(labelText: 'Street Name'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: _postalCodeController,
              decoration: InputDecoration(labelText: 'Postal Code'),
            ),
          ],
        ),
      ),
    );
  }
}
