import 'package:get/get.dart';
import 'package:on_time/ui/screens/edit_profile/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}
