import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

import 'package:project_absensi/app/data/controller/auth_controller.dart';

import 'package:project_absensi/app/data/controller/page_index_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PageIndexController(), permanent: true);
    final authC = Get.put(AuthController(), permanent: true);
    return FutureBuilder(
      future: authC.firstinitialized(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return GetMaterialApp(
          title: "Absensi",
          debugShowCheckedModeBanner: false,
          initialRoute: authC.currentToken == null ? Routes.LOGIN : Routes.HOME,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

