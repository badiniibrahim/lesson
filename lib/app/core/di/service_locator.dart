import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lesson/app/config/environment.dart';
import 'package:lesson/data/repositories/generate_repositories_impl.dart';
import 'package:lesson/data/repositories/sign_in_repositories.impl.dart';
import 'package:lesson/data/repositories/sign_up_repositories_impl.dart';
import 'package:lesson/data/services/gemini_service.dart';
import 'package:lesson/domain/repository/generate_repositories.dart';
import 'package:lesson/domain/repository/sign_in_repositories.dart';
import 'package:lesson/domain/repository/sign_up_repositories.dart';
import 'package:lesson/domain/usecase/generate_usecase.dart';
import 'package:lesson/domain/usecase/sign_in_usecase.dart';
import 'package:lesson/domain/usecase/sign_up_usecase.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> setup() async {
    // Firebase services
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

    getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance);

    //Repository
    getIt.registerLazySingleton<SignUpRepository>(
      () => SignUpRepositoryImpl(
        firebaseFirestore: getIt<FirebaseFirestore>(),
        firebaseAuth: getIt<FirebaseAuth>(),
      ),
    );

    getIt.registerLazySingleton<SignInRepository>(
      () => SignInRepositoriesImpl(
        firebaseAuth: getIt<FirebaseAuth>(),
        googleSignIn: getIt<GoogleSignIn>(),
        firebaseFirestore: getIt<FirebaseFirestore>(),
      ),
    );

    getIt.registerLazySingleton<GenerateRepository>(
      () => GenerateRepositoriesImpl(
          gemini: getIt<Gemini>(),
          firebaseFirestore: getIt<FirebaseFirestore>(),
          firebaseAuth: getIt<FirebaseAuth>()),
    );

    //UseCase
    getIt.registerFactory<SignUpUseCase>(
      () => SignUpUseCase(signUpRepository: getIt<SignUpRepository>()),
    );

    getIt.registerFactory<SingInUseCase>(
      () => SingInUseCase(signInRepository: getIt<SignInRepository>()),
    );

    getIt.registerFactory<GenerateTopicUsecase>(
      () => GenerateTopicUsecase(
          generateTopicRepositories: getIt<GenerateRepository>()),
    );

    getIt.registerLazySingleton<Gemini>(
      () => Gemini(
        generativeModel: GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: Environment.googleGeminiApiKey,
          generationConfig: GenerationConfig(
            temperature: 1,
            topK: 64,
            topP: 0.95,
            maxOutputTokens: 8192,
            responseMimeType: 'application/json',
            //responseSchema: topicSchema,
          ),
        ),
      ),
    );
  }
}
