import 'package:get_it/get_it.dart';
import 'package:sasha_botique/core/network/network_manager.dart';
import 'package:sasha_botique/features/auth/data/api_services/auth_api_service.dart';
import 'package:sasha_botique/features/cart/data/api_service/api_service.dart';
import 'package:sasha_botique/features/cart/domain/usecases/add_to_cart.dart';
import 'package:sasha_botique/features/cart/domain/usecases/clear_cart_item.dart';
import 'package:sasha_botique/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:sasha_botique/features/products/data/api_services/product_api_service.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_popular_products.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_products_by_gender.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_products_on_sale.dart';
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
import '../../features/cart/data/repository/cart_repository_impl.dart';
import '../../features/cart/data/source/local_data_source.dart';
import '../../features/cart/data/source/remote_data_source.dart';
import '../../features/cart/domain/repository/cart_repository.dart';
import '../../features/cart/domain/usecases/get_cart_items_usecase.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/products/data/source/product_local_data_source.dart';
import '../../features/products/data/source/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_new_arrival_products.dart';
import '../../features/products/domain/usecases/get_all_products.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/presentation/bloc/home/home_bloc.dart';
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

  getIt.registerLazySingleton<ThemeLocalDataSource>(() => ThemeLocalDataSourceImpl(getIt<SharedPreferencesService>()));

  // Repositories
  getIt.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(getIt<ThemeLocalDataSource>()));

  // BLoCs
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc(getIt<ThemeRepository>()));
  // Core
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<NetworkManager>(NetworkManager(preferencesService: getIt<SharedPreferencesService>(),authService: getIt<AuthService>()));

  //Auth Service

  getIt.registerLazySingleton<AuthService>(()=> AuthService(networkManager: getIt<NetworkManager>(), preferencesService: getIt<SharedPreferencesService>()));

  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<SharedPreferencesService>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceIml(getIt<AuthService>()),
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

  getIt.registerLazySingleton<ProductApiService>(()=> ProductApiService(getIt<NetworkManager>()));
  // locator.registerSingleton<VideoRepository>(RemoteVideosRepository());
  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<ProductApiService>()), // Implement this class for API calls
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
  );
  getIt.registerLazySingleton<GetProductsOnSaleUseCase>(
    () => GetProductsOnSaleUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetGenderProductsUseCase>(
    () => GetGenderProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetPopularProductsUseCase>(
    () => GetPopularProductsUseCase(getIt<ProductRepository>()),
  );

  // Products Feature BLoC
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

  //Cart Feature Dependencies
  getIt.registerLazySingleton<CartApiService>(() => CartApiService(getIt<NetworkManager>()));
  // Data sources
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt<CartApiService>()),
  );

  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSource(),
  );
  // Repository
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remoteDataSource: getIt<CartRemoteDataSource>(),
      localDataSource: getIt<CartLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetCartItemsUsecase>(() => GetCartItemsUsecase(getIt<CartRepository>()));
  getIt.registerLazySingleton<AddToCartItemUseCase>(() => AddToCartItemUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton<RemoveFromCartUseCase>(() => RemoveFromCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton<ClearCartUseCase>(() => ClearCartUseCase(getIt<CartRepository>()));

  getIt.registerFactory(
    () => CartBloc(
        getCartItemsUsecase: getIt<GetCartItemsUsecase>(),
        addToCartItemUseCase: getIt<AddToCartItemUseCase>(),
        removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
        clearCartUseCase: getIt<ClearCartUseCase>()),
  );
}
