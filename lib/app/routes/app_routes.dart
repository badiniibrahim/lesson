part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static Future<String> get INITIAL async {
    final bool hasValidSession = await getIt<SingInUseCase>().hasSessionValid();

    if (hasValidSession) {
      return Routes.DASHBOARD;
    } else {
      return Routes.SIGN_IN;
    }
  }

  static const HOME = _Paths.HOME;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const PROFILE = _Paths.PROFILE;
  static const EXPLORE = _Paths.EXPLORE;
  static const PROGRESS = _Paths.PROGRESS;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const GENERATE_TOPIC = _Paths.GENERATE_TOPIC;

  static const CREATE_COURSE_GENERATE_TOPIC =
      _Paths.HOME + _Paths.GENERATE_TOPIC;

  static const CREATE_COURSE_SELECT_TOPIC = _Paths.HOME + _Paths.SELECT_TOPIC;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const SIGN_IN = '/sign-in';
  static const SIGN_UP = '/sign-up';
  static const ONBOARDING = '/onboarding';
  static const PROFILE = '/profile';

  static const EXPLORE = '/explore';
  static const PROGRESS = '/progress';
  static const DASHBOARD = '/dashboard';
  static const GENERATE_TOPIC = '/generate-topic';
  static const SELECT_TOPIC = '/select-topic';
}
