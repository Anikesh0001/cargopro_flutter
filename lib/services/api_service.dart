import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/api_object.dart';

class ApiService {
  final String baseUrl = 'https://api.restful-api.dev/objects';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  void _log(String msg) {
    // Simple wrapper for logs; in production replace with proper logger
    // ignore: avoid_print
    print('[ApiService] $msg');
  }

  Future<List<ApiObject>> fetchObjects({int page = 1, int limit = 20}) async {
    final uri = Uri.parse('$baseUrl?page=$page&limit=$limit');
    _log('GET $uri');
    final resp = await client.get(uri, headers: {'Accept': 'application/json'});
    _log('Response ${resp.statusCode}: ${resp.body}');
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      if (body is List) {
        return body.map((e) => ApiObject.fromJson(e)).toList();
      } else if (body is Map && body['data'] is List) {
        return (body['data'] as List).map((e) => ApiObject.fromJson(e)).toList();
      }
      return [];
    } else {
      _log('Fetch objects failed: ${resp.statusCode} - ${resp.body}');
      throw Exception('Failed fetching objects: ${resp.statusCode} - ${resp.body}');
    }
  }

  Future<ApiObject> getObject(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    _log('GET $uri');
    final resp = await client.get(uri, headers: {'Accept': 'application/json'});
    _log('Response ${resp.statusCode}: ${resp.body}');
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      return ApiObject.fromJson(body);
    } else {
      _log('Get object failed: ${resp.statusCode} - ${resp.body}');
      throw Exception('Failed to get object: ${resp.statusCode} - ${resp.body}');
    }
  }

  Future<ApiObject> createObject(String name, Map<String, dynamic> data) async {
    final uri = Uri.parse(baseUrl);
    final bodyReq = json.encode({'name': name, 'data': data});
    _log('POST $uri body: $bodyReq');
    final resp = await client.post(uri, headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}, body: bodyReq);
    _log('Response ${resp.statusCode}: ${resp.body}');
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final body = json.decode(resp.body);
      return ApiObject.fromJson(body);
    } else {
      _log('Create object failed: ${resp.statusCode} - ${resp.body}');
      throw Exception('Failed to create object: ${resp.statusCode} - ${resp.body}');
    }
  }

  Future<ApiObject> updateObject(String id, String name, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/$id');
    final bodyReq = json.encode({'name': name, 'data': data});
    _log('PUT $uri body: $bodyReq');
    final resp = await client.put(uri, headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}, body: bodyReq);
    _log('Response ${resp.statusCode}: ${resp.body}');
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      return ApiObject.fromJson(body);
    } else {
      _log('Update object failed: ${resp.statusCode} - ${resp.body}');
      throw Exception('Failed to update object: ${resp.statusCode} - ${resp.body}');
    }
  }

  Future<void> deleteObject(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    _log('DELETE $uri');
    final resp = await client.delete(uri, headers: {'Accept': 'application/json'});
    _log('Response ${resp.statusCode}: ${resp.body}');
    if (resp.statusCode == 200 || resp.statusCode == 204) {
      return;
    } else {
      _log('Delete object failed: ${resp.statusCode} - ${resp.body}');
      throw Exception('Failed to delete object: ${resp.statusCode} - ${resp.body}');
    }
  }
}
