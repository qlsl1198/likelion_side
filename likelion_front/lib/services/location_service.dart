import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _locationKey = 'selected_location';
  static const String _defaultLocation = '서울시 강남구';

  // 선택한 지역 저장
  static Future<void> saveSelectedLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, location);
  }

  // 저장된 지역 불러오기
  static Future<String> getSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationKey) ?? _defaultLocation;
  }

  // 지역 목록 (LocationSelector에서 사용하는 동일한 목록)
  static List<String> getLocationList() {
    return [
      '서울시 강남구',
      '서울시 강북구',
      '서울시 마포구',
      '서울시 종로구',
      '서울시 중구',
      '경기도 수원시',
      '경기도 성남시',
      '경기도 안양시',
      '인천시 남동구',
      '인천시 연수구',
      '부산시 해운대구',
      '부산시 부산진구',
      '대구시 수성구',
      '대구시 중구',
      '광주시 서구',
      '대전시 유성구',
      '울산시 남구',
      '세종특별자치시',
    ];
  }
} 