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

  // Additional controllers
  TextEditingController _unitOrFlatNoController = TextEditingController();
  TextEditingController _streetNumberController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _suburbController = TextEditingController();
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
    final id = selectedSuggestion['Id']!;
    final details = await _loqateService.getAddressDetails(id);

    setState(() {
      // Update controllers with the address details
      _unitOrFlatNoController.text = details['unitOrFlatNo'] ?? '';
      _streetNumberController.text = details['streetNumber'] ?? '';
      _streetNameController.text = '${details['streetName'] ?? ''}, ${details['suburb'] ?? ''}';
      _cityController.text = details['city'] ?? '';
      _stateController.text = details['state'] ?? '';
      _postalCodeController.text = details['postalCode'] ?? '';
      _suggestions = [];
      _controller.text = '${selectedSuggestion['Text']}, ${selectedSuggestion['Description']}';
    });
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
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text('${suggestion['Text']}, ${suggestion['Description']}'),
                    onTap: () {
                      _selectAddress(suggestion);
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _unitOrFlatNoController,
              decoration: InputDecoration(labelText: 'Unit or Flat No'),
            ),
            TextField(
              controller: _streetNumberController,
              decoration: InputDecoration(labelText: 'Street Number'),
            ),
            TextField(
              controller: _streetNameController,
              decoration: InputDecoration(labelText: 'Street Name/Suburb'),
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
