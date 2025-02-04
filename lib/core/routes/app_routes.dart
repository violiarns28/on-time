part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const GREETING = _Paths.GREETING;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const SIGN_IN = _Paths.SIGN_IN;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const GREETING = '/greeting';
  static const SIGN_UP = '/sign-up';
  static const SIGN_IN = '/sign-in';
}
