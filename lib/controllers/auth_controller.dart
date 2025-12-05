import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final user = Rxn<User>();
  final isLoading = false.obs;
  String? _verificationId;
  ConfirmationResult? _confirmationResult; // for web

  @override
  void onInit() {
    super.onInit();
    _auth.userChanges().listen((u) {
      user.value = u;
    });
  }

  Future<void> sendSms(String phone) async {
    isLoading.value = true;
    try {
      if (kIsWeb) {
        // Web: use signInWithPhoneNumber that returns ConfirmationResult
        _confirmationResult = await _auth.signInWithPhoneNumber(phone);
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto sign-in on android
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            Get.snackbar('Verification failed', e.message ?? '');
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      Get.snackbar('Send SMS error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String code) async {
    isLoading.value = true;
    try {
      if (kIsWeb) {
        if (_confirmationResult == null) {
          Get.snackbar('Error', 'No confirmation result (recaptcha failed or not initialized).');
          return;
        }
        await _confirmationResult!.confirm(code);
      } else {
        if (_verificationId == null) {
          Get.snackbar('Error', 'No verification id. Request SMS first.');
          return;
        }
        final cred = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: code);
        await _auth.signInWithCredential(cred);
      }
    } catch (e) {
      Get.snackbar('OTP verification failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar('Sign out failed', e.toString());
    }
  }
}
