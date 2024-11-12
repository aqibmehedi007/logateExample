import 'package:flutter/material.dart';

import 'LoqateService.dart';


class AddressSearchScreen extends StatefulWidget {
  @override
  _AddressSearchScreenState createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final LoqateService _loqateService = LoqateService();
  List<String> _suggestions = [];
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

  void _selectAddress(String address) async {
    // Fetch detailed address information
    final details = await _loqateService.getAddressDetails(address);

    setState(() {
      // Update controllers with selected address details
      _streetNumberController.text = details['streetNumber'] ?? '';
      _streetNameController.text = details['streetName'] ?? '';
      _cityController.text = details['city'] ?? '';
      _stateController.text = details['state'] ?? '';
      _postalCodeController.text = details['postalCode'] ?? '';
      _suggestions = []; // Clear suggestions after selection
      _controller.text = address; // Update the main search field
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
                  return ListTile(
                    title: Text(_suggestions[index]),
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
