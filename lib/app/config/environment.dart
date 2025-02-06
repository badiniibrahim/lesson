import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // ignore: unused_field
  //static const String _devEnvFile = ".env.development";

  static String get googleApiKey => dotenv.env['GOOGLE_PLACE_API_KEY']!;
  static String get googleGeminiApiKey => dotenv.env['GOOGLE_GEMINI_API_KEY']!;
  static String get googleGeminiApiUrl => dotenv.env['GOOGLE_GEMINI_URL']!;
  static String get unsplashApiKey => dotenv.env['UNSPLASH_KEY']!;
}
