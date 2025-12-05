import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:cargopro_frontend/controllers/objects_controller.dart';
import 'package:cargopro_frontend/models/api_object.dart';
import 'package:cargopro_frontend/services/api_service.dart';

class FakeApiService extends ApiService {
  FakeApiService() : super();

  @override
  Future<ApiObject> createObject(String name, Map<String, dynamic> data) async {
    return ApiObject(id: '1', name: name, data: data);
  }

  @override
  Future<void> deleteObject(String id) async {}

  @override
  Future<ApiObject> getObject(String id) async => ApiObject(id: id, name: 'n', data: {});

  @override
  Future<List<ApiObject>> fetchObjects({int page = 1, int limit = 20}) async {
    return List.generate(3, (i) => ApiObject(id: '${i + 1}', name: 'Obj${i + 1}', data: {'i': i}));
  }

  @override
  Future<ApiObject> updateObject(String id, String name, Map<String, dynamic> data) async => ApiObject(id: id, name: name, data: data);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ObjectsController', () {
    late ObjectsController ctrl;
    setUp(() {
      final fake = FakeApiService();
      ctrl = ObjectsController(apiService: fake);
      Get.put<ObjectsController>(ctrl);
    });

    test('fetchObjects populates list', () async {
      await ctrl.fetchObjects(reset: true);
      expect(ctrl.objects.length, 3);
      expect(ctrl.objects.first.name, 'Obj1');
    });
  });
}
