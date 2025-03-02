import 'package:get/get.dart';
import 'package:on_time/ui/screens/attendance/attendance_binding.dart';
import 'package:on_time/ui/screens/attendance/attendance_screen.dart';
import 'package:on_time/ui/screens/bottom_nav_bar/bottom_nav_bar_binding.dart';
import 'package:on_time/ui/screens/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:on_time/ui/screens/edit_profile/edit_profile_binding.dart';
import 'package:on_time/ui/screens/edit_profile/edit_profile_screen.dart';
import 'package:on_time/ui/screens/greeting/greeting_binding.dart';
import 'package:on_time/ui/screens/greeting/greeting_screen.dart';
import 'package:on_time/ui/screens/history_detail/history_detail_binding.dart';
import 'package:on_time/ui/screens/history_detail/history_detail_screen.dart';
import 'package:on_time/ui/screens/home/home_binding.dart';
import 'package:on_time/ui/screens/home/home_screen.dart';
import 'package:on_time/ui/screens/profile/profile_binding.dart';
import 'package:on_time/ui/screens/profile/profile_screen.dart';
import 'package:on_time/ui/screens/root/root_binding.dart';
import 'package:on_time/ui/screens/root/root_screen.dart';
import 'package:on_time/ui/screens/sign_in/sign_in_binding.dart';
import 'package:on_time/ui/screens/sign_in/sign_in_screen.dart';
import 'package:on_time/ui/screens/sign_up/sign_up_binding.dart';
import 'package:on_time/ui/screens/sign_up/sign_up_screen.dart';
import 'package:on_time/ui/screens/splash/splash_binding.dart';
import 'package:on_time/ui/screens/splash/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.BOTTOM_NAV_BAR;

  static final routes = [
    GetPage(
      name: "/",
      page: () => const RootScreen(),
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
        GetPage(
          name: _Paths.HOME,
          page: () => const HomeScreen(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: _Paths.BOTTOM_NAV_BAR,
          page: () => const BottomNavBarScreen(),
          binding: BottomNavBarBinding(),
        ),
        GetPage(
          name: _Paths.ATTENDANCE,
          page: () => const AttendanceScreen(),
          binding: AttendanceBinding(),
        ),
        GetPage(
          name: _Paths.HISTORY_DETAIL,
          page: () => const HistoryDetailScreen(),
          binding: HistoryDetailBinding(),
        ),
        GetPage(
          name: _Paths.PROFILE,
          page: () => const ProfileScreen(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: _Paths.EDIT_PROFILE,
          page: () => const EditProfileScreen(),
          binding: EditProfileBinding(),
        ),
      ],
    )
  ];
}
