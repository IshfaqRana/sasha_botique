import 'package:get_it/get_it.dart';
import 'package:sasha_botique/features/home/domain/usecases/get_popular_products.dart';
import 'package:sasha_botique/features/home/domain/usecases/get_products_by_gender.dart';
import 'package:sasha_botique/features/home/domain/usecases/get_products_on_sale.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/source/auth_local_data_source.dart';
import '../../features/auth/data/source/auth_remote_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/forget_password.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/source/product_local_data_source.dart';
import '../../features/home/data/source/product_remote_data_source.dart';
import '../../features/home/data/repositories/product_repository_impl.dart';
import '../../features/home/domain/repositories/product_repository.dart';
import '../../features/home/domain/usecases/get_new_arrival_products.dart';
import '../../features/home/domain/usecases/get_all_products.dart';
import '../../features/home/domain/usecases/search_products.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/theme/data/source/theme_data_source.dart';
import '../../features/theme/domain/repositories/theme_repository.dart';
import '../../features/theme/data/repositories/theme_repository_impl.dart';
import '../../features/theme/presentation/bloc/theme_bloc.dart';
import '../helper/shared_preferences_service.dart';
import '../router/app_router.dart';
import '../router/navigation_service.dart';
import '../router/route_guards.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Register SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register SharedPreferencesService
  getIt.registerSingleton<SharedPreferencesService>(
    SharedPreferencesService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<ThemeLocalDataSource>(
          () => ThemeLocalDataSourceImpl(getIt<SharedPreferencesService>())
  );

  // Repositories
  getIt.registerLazySingleton<ThemeRepository>(
          () => ThemeRepositoryImpl(getIt<ThemeLocalDataSource>())
  );

  // BLoCs
  getIt.registerFactory<ThemeBloc>(
          () => ThemeBloc(getIt<ThemeRepository>())
  );
  // Core
  getIt.registerSingleton<NavigationService>(NavigationService());


  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSource(getIt<SharedPreferencesService>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      getIt<AuthLocalDataSource>(),
      getIt<AuthRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignupUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt<AuthRepository>()));

  // BLoC
  getIt.registerFactory(
        () => AuthBloc(
      checkAuthStatus: getIt<CheckAuthStatusUseCase>(),
      login: getIt<LoginUseCase>(),
      signup: getIt<SignupUseCase>(),
      logout: getIt<LogoutUseCase>(),
      forgotPassword: getIt<ForgotPasswordUseCase>(),
    ),
  );
  // Route Guards
  getIt.registerLazySingleton<RouteGuards>(
        () => RouteGuards(getIt<AuthBloc>()),
  );

  // Router
  getIt.registerLazySingleton<AppRouter>(
        () => AppRouter(getIt<RouteGuards>()),
  );
  // locator.registerSingleton<VideoRepository>(RemoteVideosRepository());
  getIt.registerLazySingleton<ProductLocalDataSource>(
        () => ProductLocalDataSource(),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSource(),  // Implement this class for API calls
  );

  // Home Feature Repositories
  getIt.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      localDataSource: getIt<ProductLocalDataSource>(),
      remoteDataSource: getIt<ProductRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetAllProductsUseCase>(
        () => GetAllProductsUseCase(getIt<ProductRepository>()),
  );

  getIt.registerLazySingleton<SearchProductsUseCase>(
        () => SearchProductsUseCase(getIt<ProductRepository>()),
  );

  getIt.registerLazySingleton<GetNewArrivalProductsUseCase>(
        () => GetNewArrivalProductsUseCase(getIt<ProductRepository>()),
  );  getIt.registerLazySingleton<GetProductsOnSaleUseCase>(
        () => GetProductsOnSaleUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetGenderProductsUseCase>(
        () => GetGenderProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetPopularProductsUseCase>(
        () => GetPopularProductsUseCase(getIt<ProductRepository>()),
  );

  // Home Feature BLoC
  getIt.registerFactory<HomeBloc>(
        () => HomeBloc(
      getAllProducts: getIt<GetAllProductsUseCase>(),
      searchProductsUseCase: getIt<SearchProductsUseCase>(),
      getProductsOnSaleUseCase: getIt<GetProductsOnSaleUseCase>(),
      getGenderProductsUseCase: getIt<GetGenderProductsUseCase>(),
      getNewArrivalProductsUseCase: getIt<GetNewArrivalProductsUseCase>(),
      getPopularProducts: getIt<GetPopularProductsUseCase>(),

    ),
  );
}