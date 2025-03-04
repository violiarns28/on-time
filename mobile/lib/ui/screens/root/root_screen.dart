import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/ui/screens/root/root_controller.dart';

class RootScreen extends GetView<RootController> {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet(
      initialRoute: Routes.SPLASH,
      anchorRoute: Routes.ROOT,
    );
  }
}
