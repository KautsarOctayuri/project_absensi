import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:project_absensi/app/data/API/controller/auth_controller.dart';
import 'package:project_absensi/app/data/API/presence_api.dart';
import 'package:project_absensi/app/data/API/profile_perusahaan_api.dart';
import 'package:project_absensi/app/data/api_client.dart';
import 'package:project_absensi/app/widget/dialog/custom_alert_dialog.dart';
import 'package:project_absensi/app/widget/toast/custom_toast.dart';
import '../../../routes/app_pages.dart';


class PresenceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;
  final authC = Get.find<AuthController>();


presence() async {
  isLoading.value = true;
  Map<String, dynamic> determinePosition = await _determinePosition();
  if (!determinePosition["error"]) {
    Position position = determinePosition["position"];
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String address =
        "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";
    double distance = Geolocator.distanceBetween(
        double.parse(authC.profilPerusahaanModel.data!.latitude!),
        double.parse(authC.profilPerusahaanModel.data!.longitude!),
        position.latitude,
        position.longitude);
    print(position);
    print(address);
    print(distance);
    //presence (store to database)
    if (distance < 300) {
      CustomAlertDialog.showPresenceAlert(
        title: "Are you want to check in?",
        message: "You need to confirm bellow you can do presence now",
        onCancel: () => Get.back(),
        onConfirm: () async {
          await processPresence(position, address, distance);
        },
      );
    } else {
      CustomToast.errorToast(
          'Tidak Bisa Absen', 'Lokasi kamu lebihdari 200 meter dari kantor');
    }
    isLoading.value = false; 
  } else {
    isLoading.value = false;
    Get.snackbar("Terjadi kesalahan",determinePosition["message"]);
    //print(determinePosition["error"]);
  }
}

Future<void> processPresence(
  Position position, String address,double distance) async {
    try {
      isLoading.value = true;
      var res = await PresenceApi().absenMasuk(
        accesstoken: authC.currentToken!, 
        usersId: authC.currentUsersId!, 
        lokasi: address, 
        waktuAbsenMasuk: DateTime.now().toString()
      );
      isLoading.value = false;
      if (res.data['success'] == true){
        Get.back();
        CustomToast.successToast("Success", res.data['message'].toString());
      }else {
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


  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location service are enable.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message": "Tidak dapat mengakses karena anda menolak permintaan lokasi",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message" : "Location permissions are permanently denied,we cannot request permissions.",
        "error":true,
      };
    }
    //When we reach here, permissions are granted and we can
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation
    );
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }
}