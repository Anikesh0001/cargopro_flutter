import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_bindings.dart';
import 'routes.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Provide FirebaseOptions for web; values should match your Firebase project config
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBpNXnf2rmnGdPz4MIMIB0VBC1p8WI5Nvc',
        authDomain: 'cargopro-flutter-ee499.firebaseapp.com',
        projectId: 'cargopro-flutter-ee499',
        storageBucket: 'cargopro-flutter-ee499.firebasestorage.app',
        messagingSenderId: '54459796722',
        appId: '1:54459796722:web:f366206559677c2c16146b',
        measurementId: 'G-ZJ3TX10QHT',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const CargoProApp());
}

class CargoProApp extends StatelessWidget {
  const CargoProApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CargoPro',
      initialBinding: AppBindings(),
      initialRoute: Routes.login,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
