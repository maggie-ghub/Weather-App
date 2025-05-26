import 'dart:convert';

import 'package:flutter/material.dart';
import 'citySearch.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final Location location;
  final CurrentWeather current;

  const WeatherData({required this.location, required this.current});
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
    );
  }
}

class Location {
  final String name, region, country;
  final double lat, lon;

  const Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class CurrentWeather {
  final double tempC, isday;
  final String lastUpdated;
  final Condition condition;

  const CurrentWeather({
    required this.tempC,
    required this.isday,
    required this.lastUpdated,
    required this.condition,
  });
  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: json['temp_c'],
      isday: json['is_day'],
      lastUpdated: json['last_updated'],
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Condition {
  final String text, icon;

  const Condition({required this.text, required this.icon});
  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'], icon: json['icon']);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather-App',
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<WeatherData> futureWeatherData;

  String cityName = '';
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  Future<WeatherData> fetchWeather() async {
    const apikey = '6314d69de83f4b8aa45113550252105';
    String city = cityName.isEmpty ? 'Mekelle' : cityName;
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/current.json?key=$apikey&q=$city&aqi=no',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Load Weather Data');
    }
  }

  @override
  void initState() {
    super.initState();
    futureWeatherData = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0B91),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text('Weather App', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          // IconButton(
          //   onPressed: () => {},
          //   icon: Icon(Icons.settings),
          //   color: Colors.white,
          // ),
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CitySearch()),
              );
              if (result != null) {
                setState(() {
                  cityName = result;
                  futureWeatherData = fetchWeather();
                });
              }
            },
            icon: Icon(Icons.search),
            color: Colors.white,
          ),
        ],
        backgroundColor: Color(0xFF1111D3),
      ),
      body: Center(
        child: FutureBuilder<WeatherData>(
          future: futureWeatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 55.0),
                child: Column(
                  children: [
                    Text(
                      snapshot.data!.location.name,
                      style: TextStyle(fontSize: 30, color: Color(0xffffffff)),
                    ),
                    // SizedBox(height: 10),
                    Text(
                      'Updated ${snapshot.data!.current.lastUpdated}',
                      style: TextStyle(color: Color(0xffffffff)),
                    ),
                    SizedBox(height: 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          'https:${snapshot.data!.current.condition.icon}',
                          scale: 0.7,
                        ),
                        Text(
                          '${snapshot.data!.current.tempC.toString()}°',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xffffffff),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.location.lat.toString(),
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            Text(
                              snapshot.data!.location.lon.toString(),
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      snapshot.data!.current.condition.text,
                      style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
                style: TextStyle(color: Color(0xFFFFFFFF)),
              );
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
