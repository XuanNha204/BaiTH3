import 'package:flutter/material.dart';

class WeatherIconWidget extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIconWidget({
    super.key,
    required this.iconCode,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểu dáng và màu sắc mô phỏng chính xác các biểu tượng thời tiết trong đề bài
    if (iconCode.startsWith('01d')) {
      // Bầu trời quang đãng (Mặt trời cam như trong ảnh)
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFFF06543),
          shape: BoxShape.circle,
        ),
      );
    } else if (iconCode.startsWith('02d')) {
      // Mây thưa (Mặt trời cam kết hợp mây)
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size * 0.1,
              left: size * 0.1,
              child: Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF06543),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.cloud,
                size: size * 0.7,
                color: Colors.blueGrey.shade300,
              ),
            ),
          ],
        ),
      );
    } else if (iconCode.startsWith('01n')) {
      // Ban đêm quang đãng (Vòng tròn tối như New York trong ảnh)
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF4A4E54),
          shape: BoxShape.circle,
        ),
      );
    } else if (iconCode.startsWith('03') || iconCode.startsWith('04')) {
      // Mây rải rác / mây cụm (Biểu tượng đám mây xám sẫm như Tokyo, Paris)
      return Icon(
        Icons.cloud,
        size: size,
        color: const Color(0xFF5A6065),
      );
    } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      // Mưa
      return Icon(
        Icons.beach_access,
        size: size,
        color: const Color(0xFF3B82F6),
      );
    } else if (iconCode.startsWith('11')) {
      // Sấm sét
      return Icon(
        Icons.flash_on,
        size: size,
        color: Colors.amber,
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFFF06543),
          shape: BoxShape.circle,
        ),
      );
    }
  }
}
