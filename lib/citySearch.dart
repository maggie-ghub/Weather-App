import 'package:flutter/material.dart';

class CitySearch extends StatefulWidget {
  const CitySearch({super.key});

  @override
  State<CitySearch> createState() => _CitySearchState();
}

class _CitySearchState extends State<CitySearch> {
  final List<String> _cityList = [];
  final TextEditingController _cityController = TextEditingController();

  citySearch() {
    if (_cityController.text.isNotEmpty) {
      setState(() {
        _cityList.add(_cityController.text);
        _cityController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('City', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Color(0xC91712BE),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter City',
                  hintText: 'Mekelle',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: () => {
                if (_cityController.text.isNotEmpty)
                  {Navigator.pop(context, _cityController.text)},
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }
}
