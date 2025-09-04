import 'package:get_it/get_it.dart';
import 'storage_service.dart';
// import 'connectivity_service.dart';  // Temporarily disabled
// import 'analytics_service.dart';  // Temporarily disabled
import '../network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/curriculum/data/repositories/curriculum_repository_impl.dart';
import '../../features/curriculum/data/datasources/curriculum_remote_datasource.dart';
import '../../features/curriculum/domain/repositories/curriculum_repository.dart';
import '../../features/curriculum/domain/usecases/get_boards_usecase.dart';
import '../../features/curriculum/domain/usecases/get_classes_usecase.dart';
import '../../features/curriculum/domain/usecases/get_subjects_usecase.dart';
import '../../features/curriculum/domain/usecases/get_chapters_usecase.dart';
import '../../features/content/data/repositories/content_repository_impl.dart';
import '../../features/content/data/datasources/content_remote_datasource.dart';
import '../../features/content/domain/repositories/content_repository.dart';
import '../../features/content/domain/usecases/get_video_usecase.dart';
import '../../features/content/domain/usecases/get_quiz_usecase.dart';
import '../../features/content/domain/usecases/submit_quiz_usecase.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_progress_usecase.dart';
import '../../features/profile/domain/usecases/update_user_progress_usecase.dart';

final GetIt sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Core Services
    sl.registerLazySingleton<StorageService>(() => StorageService());
    // sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());  // Temporarily disabled
    // sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());  // Temporarily disabled
    
    // Initialize storage service
    await sl<StorageService>().init();
    // await sl<ConnectivityService>().init();  // Temporarily disabled

    // Network
    sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<StorageService>()));

    // Data Sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
    );
    sl.registerLazySingleton<CurriculumRemoteDataSource>(
      () => CurriculumRemoteDataSourceImpl(sl<ApiClient>()),
    );
    sl.registerLazySingleton<ContentRemoteDataSource>(
      () => ContentRemoteDataSourceImpl(sl<ApiClient>()),
    );
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl<ApiClient>()),
    );

    // Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        storageService: sl<StorageService>(),
      ),
    );
    sl.registerLazySingleton<CurriculumRepository>(
      () => CurriculumRepositoryImpl(
        remoteDataSource: sl<CurriculumRemoteDataSource>(),
      ),
    );
    sl.registerLazySingleton<ContentRepository>(
      () => ContentRepositoryImpl(
        remoteDataSource: sl<ContentRemoteDataSource>(),
      ),
    );
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: sl<ProfileRemoteDataSource>(),
        storageService: sl<StorageService>(),
      ),
    );

    // Use Cases
    _registerAuthUseCases();
    _registerCurriculumUseCases();
    _registerContentUseCases();
    _registerProfileUseCases();
  }

  static void _registerAuthUseCases() {
    sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  }

  static void _registerCurriculumUseCases() {
    sl.registerLazySingleton(() => GetBoardsUseCase(sl<CurriculumRepository>()));
    sl.registerLazySingleton(() => GetClassesUseCase(sl<CurriculumRepository>()));
    sl.registerLazySingleton(() => GetSubjectsUseCase(sl<CurriculumRepository>()));
    sl.registerLazySingleton(() => GetChaptersUseCase(sl<CurriculumRepository>()));
  }

  static void _registerContentUseCases() {
    sl.registerLazySingleton(() => GetVideoUseCase(sl<ContentRepository>()));
    sl.registerLazySingleton(() => GetQuizUseCase(sl<ContentRepository>()));
    sl.registerLazySingleton(() => SubmitQuizUseCase(sl<ContentRepository>()));
    // Note: Additional use cases like GenerateVideoUseCase and MarkVideoCompletedUseCase
    // would be registered here when their files are created
  }

  static void _registerProfileUseCases() {
    sl.registerLazySingleton(() => GetUserProgressUseCase(sl<ProfileRepository>()));
    sl.registerLazySingleton(() => UpdateUserProgressUseCase(sl<ProfileRepository>()));
  }

  // Convenience getters
  static StorageService get storageService => sl<StorageService>();
  // static ConnectivityService get connectivityService => sl<ConnectivityService>();  // Temporarily disabled
  static ApiClient get apiClient => sl<ApiClient>();
  
  static AuthRepository get authService => sl<AuthRepository>();
  static CurriculumRepository get curriculumService => sl<CurriculumRepository>();
  static ContentRepository get contentService => sl<ContentRepository>();
  static ProfileRepository get profileService => sl<ProfileRepository>();
}
