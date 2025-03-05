import 'package:get/get.dart';
import 'package:on_time/ui/screens/history_detail/history_detail_controller.dart';

class HistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryDetailController>(() => HistoryDetailController());
  }
}
