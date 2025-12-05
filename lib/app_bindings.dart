import 'package:get/get.dart';
import 'services/api_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/objects_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiService and ObjectsController are available immediately
    Get.put<ApiService>(ApiService());
    Get.put<AuthController>(AuthController());
    Get.put<ObjectsController>(ObjectsController(apiService: Get.find()));
  }
}
