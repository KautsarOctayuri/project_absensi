import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:project_absensi/app/data/API/controller/models/profil_perusahaan_model.dart';
import 'package:project_absensi/app/data/API/profile_perusahaan_api.dart';
import 'package:project_absensi/app/data/api_client.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();
  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;
  String? currentToken;
  String? currentUsersId;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  AbsenHariIniModel absenHariIniModel = AbsenHariIniModel();

  @override
  void onInit() async {
    super.onInit();
  }

  Future firstinitialized() async {
    currentToken = await storage.read(key: 'access_token');
    currentUsersId = await storage.read(key: 'users_id');
    if (currentToken != null){
      await getProfilPerusahaan(token: currentToken!);
    }
  }

  Future login() async {
    try {
      isLoading.value = true;
      var res = await ApiClient().login(
        emailC.text,
        passwordC.text,
      );
      isLoading.value = false;
      if (res.data['success'] == true) {
        await storage.write(
            key: 'access_token', value: res.data['access_token']);
        await storage.write(key: 'users_id', value: res.data['users_id']);
        currentToken = await storage.read(key: 'access_token');
        currentUsersId = await storage.read(key: 'users_id');
        //setelah login berhasil,ambil data perusahaan
        await getProfilPerusahaan(token: currentToken!);

        Get.offAllNamed(
          Routes.HOME,
        );
        Get.rawSnackbar(
          messageText: Text(res.data['message']),
          backgroundColor: Colors.green.shade300,
        );
      } else {
        Get.rawSnackbar(
          messageText: Text(res.data['message'].toString()),
          backgroundColor: Colors.red.shade300,
        );
      }
    } catch (error) {
      isLoading.value = false;
      Get.rawSnackbar(message: error.toString());
    }
  }

  Future logout() async {
    try {
      isLoading.value = true;
      var res = await ApiClient().logout(accesstoken: currentToken!);
      isLoading.value = false;
      if (res.data['success'] == true) {
        await storage.delete(key: 'access_token');
        await storage.delete(key: 'users_id');
        currentToken = null;
        currentUsersId = null;
        Get.offAllNamed(Routes.LOGIN);
        Get.rawSnackbar(
          messageText: Text(res.data['message']),
          backgroundColor: Colors.green.shade300,
        );
      } else {
        Get.rawSnackbar(
          messageText: Text(res.data['message'].toString()),
          backgroundColor: Colors.red.shade300,
        );
      }
    } catch (error) {
      isLoading.value = false;
      Get.rawSnackbar(message: error.toString());
    }
  }

  ProfilPerusahaanModel profilPerusahaanModel = ProfilPerusahaanModel();
  Future <ProfilPerusahaanModel> getProfilPerusahaan({required String token}) async {
    try {
      var res = await ProfilePerusahaanApi().getProfilPerusahaan(
        accesstoken: token,
        );
      if (res.data['success'] == true) {
        print(res.data);
        profilPerusahaanModel = ProfilPerusahaanModel.fromJson(res.data);
        return profilPerusahaanModel;
       
      } else {
        Get.rawSnackbar(
          messageText: Text(res.data['message'].toString()),
          backgroundColor: Colors.red.shade300,
        );
        return profilPerusahaanModel;
      }
    } catch (e) {
      // Get.rawSnackbar(
      //   message: Text(e.toString()),
      //   backgroundColor: Colors.red.shade300,
      // );
      return profilPerusahaanModel;
    }
  }

}

