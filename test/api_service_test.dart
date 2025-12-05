import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:cargopro_frontend/services/api_service.dart';
import 'package:cargopro_frontend/models/api_object.dart';

void main() {
  group('ApiService', () {
    test('fetchObjects parses list', () async {
      final mockClient = MockClient((request) async {
        final body = json.encode([
          {'id': '1', 'name': 'A', 'data': {'x': 1}},
          {'id': '2', 'name': 'B', 'data': {'y': 2}}
        ]);
        return http.Response(body, 200);
      });
      final svc = ApiService(client: mockClient);
      final list = await svc.fetchObjects(page: 1, limit: 10);
      expect(list, isA<List<ApiObject>>());
      expect(list.length, 2);
      expect(list.first.name, 'A');
    });

    test('createObject returns created object', () async {
      final mockClient = MockClient((request) async {
        final req = json.decode(request.body);
        final resp = {'id': '123', 'name': req['name'], 'data': req['data']};
        return http.Response(json.encode(resp), 201);
      });
      final svc = ApiService(client: mockClient);
      final obj = await svc.createObject('Test', {'a': 1});
      expect(obj.id, '123');
      expect(obj.name, 'Test');
    });
  });
}
