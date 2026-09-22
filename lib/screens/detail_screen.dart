import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../widgets/weather_icon.dart';

class DetailScreen extends StatelessWidget {
  final WeatherData weather;

  const DetailScreen({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CA0EE),
              Color(0xFF267FD8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Nút quay lại (<)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 8),

                // Tên thành phố
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Biểu tượng thời tiết
                WeatherIconWidget(
                  iconCode: weather.iconCode,
                  size: 76,
                ),

                const SizedBox(height: 20),

                // Nhiệt độ
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 8),

                // Mô tả thời tiết in hoa
                Text(
                  weather.description.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 36),

                // Khung hiển thị chi tiết 4 thông số (2x2) theo đúng Hình 4
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Hàng 1: Cảm giác & Độ ẩm
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                icon: Icons.thermostat_outlined,
                                label: 'Cảm giác',
                                value: '${weather.feelsLike.toStringAsFixed(1)}°C',
                              ),
                            ),
                            Expanded(
                              child: _buildDetailItem(
                                icon: Icons.water_drop_outlined,
                                label: 'Độ ẩm',
                                value: '${weather.humidity}%',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Hàng 2: Sức gió & Áp suất
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                icon: Icons.air,
                                label: 'Sức gió',
                                value: '${weather.windSpeed.toStringAsFixed(2)} m/s',
                              ),
                            ),
                            Expanded(
                              child: _buildDetailItem(
                                icon: Icons.speed,
                                label: 'Áp suất',
                                value: '${weather.pressure} hPa',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.9),
          size: 26,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
