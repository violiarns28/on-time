part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ROOT = _Paths.ROOT;
  static const SPLASH = _Paths.SPLASH;
  static const GREETING = _Paths.GREETING;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const HOME = _Paths.HOME;
  static const BOTTOM_NAV_BAR = _Paths.BOTTOM_NAV_BAR;
  static const ATTENDANCE = _Paths.ATTENDANCE;
  static const HISTORY_DETAIL = _Paths.HISTORY_DETAIL;
  static const PROFILE = _Paths.PROFILE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const ROOT = '/';
  static const SPLASH = '/splash';
  static const GREETING = '/greeting';
  static const SIGN_UP = '/sign-up';
  static const SIGN_IN = '/sign-in';
  static const HOME = '/home';
  static const BOTTOM_NAV_BAR = '/bottom-nav-bar';
  static const ATTENDANCE = '/attendance';
  static const HISTORY_DETAIL = '/history-detail';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
}
