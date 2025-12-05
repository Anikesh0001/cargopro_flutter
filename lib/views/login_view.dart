import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes.dart';
import '../utils/theme.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final _phoneCtrl = TextEditingController(text: '');
  // don't resolve controller at file init time; resolve inside build

  @override
  Widget build(BuildContext context) {
    final AuthController _auth = Get.find();

    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.local_shipping, color: Color(0xFF6C63FF), size: 28),
                    ),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('CargoPro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Deliver smarter. Manage easier.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ])
                  ]),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone number',
                      hintText: '+1 555 555 5555',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: _auth.isLoading.value
                            ? ElevatedButton.icon(onPressed: null, icon: const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)), label: const Text('Sending...'))
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  final phone = _phoneCtrl.text.trim();
                                  if (phone.isEmpty) {
                                    Get.snackbar('Error', 'Phone is required');
                                    return;
                                  }
                                  await _auth.sendSms(phone);
                                  Get.toNamed(Routes.otp);
                                },
                                icon: const Icon(Icons.send),
                                label: const Text('Send OTP'),
                              ),
                      )),
                  const SizedBox(height: 12),
                  Row(children: const [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('or')) , Expanded(child: Divider())]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed(Routes.list),
                      icon: const Icon(Icons.visibility),
                      label: const Text('Continue as guest'),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
