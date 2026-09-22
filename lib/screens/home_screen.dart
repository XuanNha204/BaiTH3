import 'dart:async';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_icon.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _suggestionTimer;

  List<WeatherData> _featuredCities = [];
  bool _isLoadingFeatured = true;

  WeatherData? _searchResult;
  bool _isSearching = false;
  String? _errorMessage;

  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _loadFeaturedCities();

    _searchController.addListener(_onSearchTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onSearchTextChanged() {
    final text = _searchController.text.trim();
    if (text.isNotEmpty && _focusNode.hasFocus) {
      setState(() {
        _filteredSuggestions = WeatherService.searchSuggestions
            .where((city) => city.toLowerCase().contains(text.toLowerCase()))
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _suggestionTimer?.cancel();
      _suggestionTimer = Timer(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showSuggestions = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _suggestionTimer?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadFeaturedCities() async {
    setState(() {
      _isLoadingFeatured = true;
    });

    final cities = await WeatherService.fetchFeaturedCities();

    if (mounted) {
      setState(() {
        _featuredCities = cities;
        _isLoadingFeatured = false;
      });
    }
  }

  Future<void> _performSearch(String cityName) async {
    final query = cityName.trim();
    if (query.isEmpty) return;

    _suggestionTimer?.cancel();
    _focusNode.unfocus();
    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _showSuggestions = false;
    });

    try {
      final weather = await WeatherService.fetchWeather(query);
      if (mounted) {
        setState(() {
          _searchResult = weather;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Không tìm thấy thông tin thời tiết cho "$query"';
          _isSearching = false;
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResult = null;
      _errorMessage = null;
      _showSuggestions = false;
    });
  }

  void _navigateToDetail(WeatherData weather) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(weather: weather),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '2224801030048 - Dự báo thời tiết',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
            setState(() {
              _showSuggestions = false;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh tìm kiếm + nút tìm kiếm (Hình 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Ô nhập tên thành phố
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF7C5CFC).withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.search,
                          onSubmitted: _performSearch,
                          decoration: InputDecoration(
                            hintText: 'Nhập tên thành phố (vd: Hà Nội)...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                                    onPressed: _clearSearch,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Nút tìm kiếm màu xanh
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2898EE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white, size: 24),
                        onPressed: () => _performSearch(_searchController.text),
                      ),
                    ),
                  ],
                ),
              ),

              // Gợi ý khi gõ (Hình 2)
              if (_showSuggestions)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredSuggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final item = _filteredSuggestions[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        onTap: () {
                          _searchController.text = item;
                          _performSearch(item);
                        },
                      );
                    },
                  ),
                ),

              // Thông báo lỗi nếu có
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              // Phần nội dung chính: Kết quả tìm kiếm (Hình 3) hoặc Danh sách thành phố nổi bật (Hình 1)
              Expanded(
                child: _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResult != null
                        ? _buildSearchResultView()
                        : _buildFeaturedCitiesView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Giao diện kết quả tìm kiếm trên màn hình chính (Hình 3)
  Widget _buildSearchResultView() {
    final weather = _searchResult!;
    return Center(
      child: InkWell(
        onTap: () => _navigateToDetail(weather),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather.cityName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 24),
              WeatherIconWidget(
                iconCode: weather.iconCode,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                '${weather.temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                weather.description.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Chạm để xem chi tiết',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Giao diện danh sách thành phố nổi bật (Hình 1)
  Widget _buildFeaturedCitiesView() {
    if (_isLoadingFeatured) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Thành phố nổi bật',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _featuredCities.length,
              itemBuilder: (context, index) {
                final item = _featuredCities[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    elevation: 0.5,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _navigateToDetail(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Biểu tượng thời tiết
                            WeatherIconWidget(
                              iconCode: item.iconCode,
                              size: 32,
                            ),
                            const SizedBox(width: 14),
                            // Tên thành phố và mô tả thời tiết
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.cityName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3142),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Nhiệt độ màu xanh
                            Text(
                              '${item.temperature.toStringAsFixed(1)}°C',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2995ED),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
