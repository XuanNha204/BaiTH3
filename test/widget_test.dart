import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:th3_du_bao_thoi_tiet/main.dart';
import 'package:th3_du_bao_thoi_tiet/models/weather_model.dart';
import 'package:th3_du_bao_thoi_tiet/screens/detail_screen.dart';

void main() {
  test('WeatherData.fromJson should parse correctly', () {
    final mockJson = {
      'name': 'Hà Nội',
      'main': {
        'temp': 32.0,
        'feels_like': 34.4,
        'humidity': 50,
        'pressure': 1002,
      },
      'wind': {
        'speed': 8.07,
      },
      'weather': [
        {
          'description': 'bầu trời quang đãng',
          'icon': '01d',
        }
      ]
    };

    final weather = WeatherData.fromJson(mockJson);

    expect(weather.cityName, 'Hà Nội');
    expect(weather.temperature, 32.0);
    expect(weather.feelsLike, 34.4);
    expect(weather.humidity, 50);
    expect(weather.pressure, 1002);
    expect(weather.windSpeed, 8.07);
    expect(weather.description, 'bầu trời quang đãng');
    expect(weather.iconCode, '01d');
  });

  testWidgets('WeatherApp smoke test and navigation to DetailScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());

    // Kiểm tra các thành phần của Màn hình chính (Hình 1)
    expect(find.text('2224801030048 - Dự báo thời tiết'), findsOneWidget);
    expect(find.text('Nhập tên thành phố (vd: Hà Nội)...'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Chờ tải danh sách thành phố nổi bật
    await tester.pumpAndSettle();
    expect(find.text('Thành phố nổi bật'), findsOneWidget);
    expect(find.text('Hà Nội'), findsWidgets);

    // Nhấn vào thành phố Hà Nội trên ListView để chuyển sang Màn hình chi tiết (Hình 4)
    await tester.tap(find.text('Hà Nội').first);
    await tester.pumpAndSettle();

    // Kiểm tra màn hình chi tiết hiển thị đầy đủ thông tin:
    expect(find.text('Cảm giác'), findsOneWidget);
    expect(find.text('Độ ẩm'), findsOneWidget);
    expect(find.text('Sức gió'), findsOneWidget);
    expect(find.text('Áp suất'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

    // Bấm nút quay lại để về màn hình chính
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();
    expect(find.text('Thành phố nổi bật'), findsOneWidget);
  });

  testWidgets('DetailScreen displays all weather metrics accurately', (WidgetTester tester) async {
    final weather = WeatherData(
      cityName: 'Đà Nẵng',
      temperature: 31.0,
      feelsLike: 33.2,
      humidity: 55,
      windSpeed: 5.2,
      pressure: 1010,
      description: 'bầu trời quang đãng',
      iconCode: '01d',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DetailScreen(weather: weather),
      ),
    );

    expect(find.text('Đà Nẵng'), findsOneWidget);
    expect(find.text('31.0°C'), findsOneWidget);
    expect(find.text('BẦU TRỜI QUANG ĐÃNG'), findsOneWidget);
    expect(find.text('33.2°C'), findsOneWidget);
    expect(find.text('55%'), findsOneWidget);
    expect(find.text('5.20 m/s'), findsOneWidget);
    expect(find.text('1010 hPa'), findsOneWidget);
  });
}
