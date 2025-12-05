import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/api_object.dart';
import '../services/api_service.dart';

class ObjectsController extends GetxController {
  final ApiService apiService;

  ObjectsController({required this.apiService});

  final objects = <ApiObject>[].obs;
  final isLoading = false.obs;
  final page = 1.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchObjects(reset: true);
  }

  Future<void> fetchObjects({bool reset = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final nextPage = reset ? 1 : page.value;
      final list = await apiService.fetchObjects(page: nextPage, limit: 20);
      if (reset) {
        objects.assignAll(list);
        page.value = 2;
      } else {
        if (list.isEmpty) {
          hasMore.value = false;
        } else {
          objects.addAll(list);
          page.value++;
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    hasMore.value = true;
    await fetchObjects(reset: true);
  }

  Future<ApiObject?> getObjectDetail(String id) async {
    try {
      final obj = await apiService.getObject(id);
      return obj;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

  Future<void> createObject(String name, Map<String, dynamic> data) async {
    try {
      final obj = await apiService.createObject(name, data);
      objects.insert(0, obj);
      Get.snackbar('Success', 'Created');
    } catch (e, st) {
      // Log and show detailed message
      // ignore: avoid_print
      print('[ObjectsController] createObject error: $e\n$st');
      final msg = e is Exception ? e.toString() : 'Unknown error';
      Get.snackbar('Create failed', msg, backgroundColor: const Color(0xFFfeece6));
    }
  }

  Future<void> updateObject(String id, String name, Map<String, dynamic> data) async {
    try {
      final updated = await apiService.updateObject(id, name, data);
      final idx = objects.indexWhere((o) => o.id == id);
      if (idx != -1) objects[idx] = updated;
      Get.snackbar('Success', 'Updated');
    } catch (e, st) {
      // ignore: avoid_print
      print('[ObjectsController] updateObject error: $e\n$st');
      final msg = e.toString();
      // If the server indicates this is a reserved id, offer to create a copy instead
      if (msg.toLowerCase().contains('reserved')) {
        Get.defaultDialog(
          title: 'Reserved Object',
          middleText: 'This object uses a reserved id and cannot be updated. Create a new copy instead?',
          textConfirm: 'Create Copy',
          textCancel: 'Cancel',
          onConfirm: () async {
            try {
              await createObject(name, data);
              Get.back();
              Get.back();
            } catch (err) {
              Get.back();
              Get.snackbar('Create failed', err.toString(), backgroundColor: const Color(0xFFfeece6));
            }
          },
        );
      } else {
        Get.snackbar('Update failed', msg, backgroundColor: const Color(0xFFfeece6));
      }
    }
  }

  Future<void> deleteObjectOptimistic(String id) async {
    final idx = objects.indexWhere((o) => o.id == id);
    ApiObject? removed;
    if (idx != -1) {
      removed = objects.removeAt(idx);
    }
    try {
      await apiService.deleteObject(id);
      Get.snackbar('Success', 'Deleted');
    } catch (e) {
      // revert
      if (removed != null) objects.insert(idx, removed);
      // ignore: avoid_print
      print('[ObjectsController] deleteObject error: $e');
      Get.snackbar('Delete failed', e.toString(), backgroundColor: const Color(0xFFfeece6));
    }
  }
}
