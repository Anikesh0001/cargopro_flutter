import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/objects_controller.dart';
import '../models/api_object.dart';
import '../utils/json_utils.dart';
import '../utils/theme.dart';

class CreateEditView extends StatefulWidget {
  final bool editMode;
  CreateEditView({Key? key, this.editMode = false}) : super(key: key);

  @override
  State<CreateEditView> createState() => _CreateEditViewState();
}

class _CreateEditViewState extends State<CreateEditView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final ObjectsController _ctrl = Get.find();
  ApiObject? editing;

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      editing = Get.arguments as ApiObject?;
      if (editing != null) {
        _nameCtrl.text = editing!.name;
        _dataCtrl.text = JsonUtils.pretty(editing!.data);
      }
    }
  }

  void _formatJson() {
    try {
      final decoded = json.decode(_dataCtrl.text);
      _dataCtrl.text = JsonUtils.pretty(decoded);
    } catch (e) {
      Get.snackbar('Invalid JSON', 'Cannot format: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.editMode ? 'Edit Object' : 'Create Object')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.label)),
                      validator: (v) => (v == null || v.isEmpty) ? 'Name required' : null,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _dataCtrl,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                        decoration: const InputDecoration(labelText: 'Data (JSON)', alignLabelWithHint: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'JSON required';
                          if (!JsonUtils.isValidJson(v)) return 'Invalid JSON';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final name = _nameCtrl.text.trim();
                          final data = json.decode(_dataCtrl.text);
                          if (widget.editMode && editing != null) {
                            await _ctrl.updateObject(editing!.id, name, Map<String, dynamic>.from(data));
                            Get.back();
                          } else {
                            await _ctrl.createObject(name, Map<String, dynamic>.from(data));
                            Get.back();
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: Text(widget.editMode ? 'Save' : 'Create'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(onPressed: _formatJson, icon: const Icon(Icons.format_align_left), label: const Text('Format JSON')),
                      const SizedBox(width: 12),
                      TextButton(onPressed: () => Get.back(), child: const Text('Cancel'))
                    ])
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
