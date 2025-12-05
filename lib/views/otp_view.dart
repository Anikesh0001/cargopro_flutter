import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes.dart';
import '../utils/theme.dart';

class OtpView extends StatelessWidget {
  OtpView({Key? key}) : super(key: key);

  final _codeCtrl = TextEditingController();
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
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Enter OTP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('We sent you an SMS with a verification code.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_clock),
                      labelText: 'OTP Code',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: _auth.isLoading.value
                            ? ElevatedButton.icon(onPressed: null, icon: const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)), label: const Text('Verifying...'))
                            : ElevatedButton(
                                onPressed: () async {
                                  final code = _codeCtrl.text.trim();
                                  if (code.isEmpty) {
                                    Get.snackbar('Error', 'OTP required');
                                    return;
                                  }
                                  await _auth.verifyOtp(code);
                                  if (_auth.user.value != null) {
                                    Get.offAllNamed(Routes.list);
                                  }
                                },
                                child: const Text('Verify'),
                              ),
                      )),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => Get.back(), child: const Text('Change number')),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
