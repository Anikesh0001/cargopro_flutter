class ApiObject {
  String id;
  String name;
  Map<String, dynamic> data;

  ApiObject({required this.id, required this.name, required this.data});

  factory ApiObject.fromJson(Map<String, dynamic> json) {
    return ApiObject(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      data: json['data'] is Map<String, dynamic> ? Map<String, dynamic>.from(json['data']) : {}
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data': data,
    };
  }
}
