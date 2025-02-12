part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const GREETING = _Paths.GREETING;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const HOME = _Paths.HOME;
  static const BOTTOM_NAV_BAR = _Paths.BOTTOM_NAV_BAR;
  static const ATTENDANCE = _Paths.ATTENDANCE;
  static const PROFILE = _Paths.PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const GREETING = '/greeting';
  static const SIGN_UP = '/sign-up';
  static const SIGN_IN = '/sign-in';
  static const HOME = '/home';
  static const BOTTOM_NAV_BAR = '/bottom-nav-bar';
  static const ATTENDANCE = '/attendance';
  static const PROFILE = '/profile';
}
