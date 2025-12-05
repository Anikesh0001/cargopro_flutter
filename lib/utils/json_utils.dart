import 'dart:convert';

class JsonUtils {
  static bool isValidJson(String input) {
    try {
      final decoded = json.decode(input);
      return decoded is Map || decoded is List;
    } catch (e) {
      return false;
    }
  }

  static String pretty(dynamic data) {
    try {
      if (data is String) return data;
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }
}
