import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lesson/app/config/environment.dart';
import 'package:lesson/app/core/di/service_locator.dart';
import 'package:lesson/app/extensions/constant.dart';
import 'package:lesson/firebase_options.dart';
import 'package:lesson/store_config.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

class Initializer {
  static Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      await _initEnvironment();
      await _initFirebase();
      await _initGemini();
      await ServiceLocator.setup();
      // await _revenueInit();
      // await _configureSDK();
    } catch (err) {
      if (kDebugMode) {
        print('Initialization error: $err');
      }
      rethrow;
    }
  }

  static Future<void> _initEnvironment() async {
    try {
      await dotenv.load(fileName: '.env');
      if (Environment.googleApiKey.isEmpty) {
        throw Exception('Missing Google API Key in environment variables');
      }
    } catch (err) {
      throw Exception('Environment initialization failed: $err');
    }
  }

  static Future<void> _initGemini() async {
    try {
      Gemini.init(apiKey: Environment.googleApiKey);
    } catch (err) {
      throw Exception('Gemini initialization failed: $err');
    }
  }

  static Future<void> _initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseFirestore.instance.settings =
          const Settings(persistenceEnabled: true);
    } catch (err) {
      throw Exception('Firebase initialization failed: $err');
    }
  }

  static Future<void> _revenueInit() async {
    if (Platform.isIOS || Platform.isMacOS) {
      StoreConfig(
        store: Store.appStore,
        apiKey: appleApiKey,
      );
    } else if (Platform.isAndroid) {
      // Run the app passing --dart-define=AMAZON=true
      const useAmazon = bool.fromEnvironment("amazon");
      StoreConfig(
        store: useAmazon ? Store.amazon : Store.playStore,
        apiKey: useAmazon ? amazonApiKey : googleApiKey,
      );
    }
  }

  static Future<void> _configureSDK() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - PurchasesAreCompletedyBy is PurchasesAreCompletedByRevenueCat, so Purchases will automatically handle finishing transactions. Read more about completing purchases here: https://www.revenuecat.com/docs/migrating-to-revenuecat/sdk-or-not/finishing-transactions
    */
    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
    }
    await Purchases.configure(configuration);
  }
}
