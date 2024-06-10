import 'package:get/get.dart';
import 'package:project_absensi/app/data/API/controller/presence_controller.dart';

import '../../../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  final present = Get.find<PresenceController>();

  void changePage(int index) async {
    pageIndex.value = index;
    switch (index) {
      case 1:
        Get.offAllNamed(Routes.ABSEN);
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
        break;
    }
  }
}