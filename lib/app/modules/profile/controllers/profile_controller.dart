import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_absensi/app/data/API/controller/auth_controller.dart';
import 'package:project_absensi/app/data/API/profile_api.dart';
import 'package:project_absensi/app/modules/profile/controllers/profile_model.dart';

class ProfileController extends GetxController {
  final authC = Get.find<AuthController>();
  ProfileModel profileModel = ProfileModel();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<ProfileModel> getUser() async {
    try {
      var res = await ProfileApi().getProfile(
        accesstoken: authC.currentToken!,
      );
      if (res.data['success'] == true) {
        profileModel = ProfileModel.fromJson(res.data);
        return profileModel;
      } else {
        Get.rawSnackbar(
          messageText: Text(res.data['message'].toString()),
          backgroundColor: Colors.red.shade300,
        );
        return profileModel;
      }
    } catch (e) {
      Get.rawSnackbar(
        messageText: Text(e.toString()),
        backgroundColor: Colors.red.shade300,
      );
      return profileModel;
    }
  }
}
