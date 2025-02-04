import 'package:get/get.dart';
import 'package:on_time/ui/screens/greeting/greeting_binding.dart';
import 'package:on_time/ui/screens/greeting/greeting_screen.dart';
import 'package:on_time/ui/screens/root/root_binding.dart';
import 'package:on_time/ui/screens/root/root_screen.dart';
import 'package:on_time/ui/screens/sign_in/sign_in_binding.dart';
import 'package:on_time/ui/screens/sign_in/sign_in_screen.dart';
import 'package:on_time/ui/screens/sign_up/sign_up_binding.dart';
import 'package:on_time/ui/screens/sign_up/sign_up_screen.dart';
import 'package:on_time/ui/screens/splash/splash_binding.dart';
import 'package:on_time/ui/screens/splash/splash_screen.dart'; //

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: "/",
      page: () => RootScreen(),
      binding: RootBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      children: [
        GetPage(
          name: _Paths.SPLASH,
          page: () => const SplashScreen(),
          binding: SplashBinding(),
        ),
        GetPage(
          name: _Paths.GREETING,
          page: () => const GreetingScreen(),
          binding: GreetingBinding(),
        ),
        GetPage(
          name: _Paths.SIGN_UP,
          page: () => const SignUpScreen(),
          binding: SignUpBinding(),
        ),
        GetPage(
          name: _Paths.SIGN_IN,
          page: () => const SignInScreen(),
          binding: SignInBinding(),
        ),
      ],
    )
  ];
}
