class WeatherData {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String iconCode;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.iconCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, {String? customCityName}) {
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weatherFirst = weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : {};
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};

    return WeatherData(
      cityName: customCityName ?? json['name'] as String? ?? 'Chưa rõ',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      pressure: (main['pressure'] as num?)?.toInt() ?? 1013,
      description: weatherFirst['description'] as String? ?? 'bầu trời quang đãng',
      iconCode: weatherFirst['icon'] as String? ?? '01d',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'description': description,
      'iconCode': iconCode,
    };
  }
}
