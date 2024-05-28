import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/absen_controller.dart';

import 'package:project_absensi/app/widget/custom_bottom_navigation_bar.dart';

class AbsenView extends GetView<AbsenController> {
  const AbsenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      extendBody: true,
      body: const Center(
        child: Text(
          'AbsenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
