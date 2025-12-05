import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/objects_controller.dart';
import '../controllers/auth_controller.dart';
import '../routes.dart';
import '../models/api_object.dart';
import '../utils/theme.dart';
import 'dart:core';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final ctrl = Get.find<ObjectsController>();
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      if (ctrl.hasMore.value && !ctrl.isLoading.value) {
        ctrl.fetchObjects();
      }
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ObjectsController _ctrl = Get.find();
    final AuthController _auth = Get.find();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: AppTheme.gradientBackground(),
          padding: const EdgeInsets.only(top: 36, left: 12, right: 12, bottom: 12),
          child: SafeArea(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Objects', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Row(children: [
                IconButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Get.offAllNamed(Routes.login);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white)),
              ])
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.create);
        },
        label: const Text('Create'),
        icon: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value && _ctrl.objects.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_ctrl.objects.isEmpty) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.inbox, size: 72, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('No objects yet', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _ctrl.refresh, child: const Text('Reload'))
            ]),
          );
        }

        return RefreshIndicator(
          onRefresh: _ctrl.refresh,
          child: LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            if (isWide) {
              return GridView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3),
                itemCount: _ctrl.objects.length + (_ctrl.hasMore.value ? 1 : 0),
                itemBuilder: (context, idx) {
                  if (idx >= _ctrl.objects.length) return const Center(child: CircularProgressIndicator());
                  final ApiObject obj = _ctrl.objects[idx];
                  final bool reserved = _isReservedId(obj.id);
                  return InkWell(
                    onTap: () => Get.toNamed(Routes.detail, arguments: obj),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(children: [
                          CircleAvatar(backgroundColor: Colors.indigo.shade50, child: Text(obj.name.isNotEmpty ? obj.name[0].toUpperCase() : '?', style: const TextStyle(color: AppTheme.primary))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(obj.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('id: ${obj.id}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ])),
                          if (reserved) ...[
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.lock, size: 20, color: Colors.grey),
                            ),
                            IconButton(
                              tooltip: 'Create editable copy',
                              onPressed: () async {
                                final ok = await Get.dialog<bool>(
                                  AlertDialog(
                                    title: const Text('Create Copy'),
                                    content: Text('This is a reserved object. Create an editable copy of "${obj.name}"?'),
                                    actions: [
                                      TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Get.back(result: true), child: const Text('Create')),
                                    ],
                                  ),
                                );
                                if (ok == true) {
                                  await _ctrl.createObject(obj.name, Map<String, dynamic>.from(obj.data ?? {}));
                                }
                              },
                              icon: const Icon(Icons.copy, color: Colors.blueAccent),
                            ),
                          ] else ...[
                            IconButton(onPressed: () => Get.toNamed(Routes.edit, arguments: obj), icon: const Icon(Icons.edit)),
                            IconButton(
                              onPressed: () async {
                                final confirm = await Get.dialog<bool>(
                                  AlertDialog(
                                    title: const Text('Delete'),
                                    content: Text('Delete "${obj.name}"? This cannot be undone.'),
                                    actions: [
                                      TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _ctrl.deleteObjectOptimistic(obj.id);
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                            ),
                          ],
                        ]),
                      ),
                    ),
                  );
                },
              );
            }

            return ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: _ctrl.objects.length + (_ctrl.hasMore.value ? 1 : 0),
              itemBuilder: (context, idx) {
                if (idx >= _ctrl.objects.length) return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
                final ApiObject obj = _ctrl.objects[idx];
                final bool reserved = _isReservedId(obj.id);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(obj.name.isNotEmpty ? obj.name[0].toUpperCase() : '?')),
                    title: Text(obj.name),
                    subtitle: Text('id: ${obj.id}\n${obj.data.toString()}', maxLines: 2, overflow: TextOverflow.ellipsis),
                    isThreeLine: true,
                    onTap: () {
                      Get.toNamed(Routes.detail, arguments: obj);
                    },
                    trailing: reserved
                        ? const Icon(Icons.lock, color: Colors.grey)
                        : Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(onPressed: () => Get.toNamed(Routes.edit, arguments: obj), icon: const Icon(Icons.edit)),
                            IconButton(
                              onPressed: () async {
                                final confirmed = await Get.dialog<bool>(
                                  AlertDialog(
                                    title: const Text('Delete'),
                                    content: Text('Delete "${obj.name}"? This cannot be undone.'),
                                    actions: [
                                      TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  await _ctrl.deleteObjectOptimistic(obj.id);
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                            ),
                          ]),
                  ),
                );
              },
            );
          }),
        );
      }),
    );
  }

  bool _isReservedId(String id) {
    try {
      final val = int.parse(id);
      // The API uses low numeric ids (1..13) as reserved in responses we saw.
      // Treat ids <= 13 as reserved to avoid PUT/DELETE attempts.
      return val <= 13;
    } catch (_) {
      return false;
    }
  }
}
