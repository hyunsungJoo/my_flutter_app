import 'package:flutter/material.dart';

class CityPage extends StatefulWidget {

  const CityPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CityPageState();
  }

}

class _CityPageState extends State<CityPage> {
  final List<String> cities = ['Seoul', 'Tokyo', 'Inchon'];
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도시 리스트뷰')),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return RadioListTile<String>(
                        title: Text(cities[index]),
                        value: cities[index],
                        groupValue: selectedCity,
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        });
                  })
          ),
          Padding(padding: const EdgeInsets.all(16),
            child: ElevatedButton(
                onPressed: selectedCity != null
                    ? () => Navigator.pop(context, selectedCity)
                    : null,
                child: const Text('선택완료')),)
        ],
      )
      );
  }
  
}