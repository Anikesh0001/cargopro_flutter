import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/api_object.dart';
import '../controllers/objects_controller.dart';
import '../routes.dart';
import '../utils/json_utils.dart';
import '../utils/theme.dart';

class DetailView extends StatelessWidget {
  DetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ObjectsController _ctrl = Get.find();
    final ApiObject obj = Get.arguments as ApiObject;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: AppTheme.gradientBackground(),
            padding: const EdgeInsets.only(top: 36, left: 12, right: 12, bottom: 12),
            child: SafeArea(child: Text(obj.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('ID: ${obj.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Data:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SelectableText(JsonUtils.pretty(obj.data), style: const TextStyle(fontFamily: 'monospace')),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(Routes.edit, arguments: obj);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final confirm = await Get.dialog<bool>(AlertDialog(
                    title: const Text('Delete'),
                    content: const Text('Delete this object?'),
                    actions: [
                      TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
                    ],
                  ));
                  if (confirm == true) {
                    await _ctrl.deleteObjectOptimistic(obj.id);
                    Get.back();
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              )
            ])
          ]),
        ),
      );
  }
}
