import 'package:get_it/get_it.dart';
import 'package:sasha_botique/core/network/network_manager.dart';
import 'package:sasha_botique/features/auth/data/api_services/auth_api_service.dart';
import 'package:sasha_botique/features/cart/data/api_service/api_service.dart';
import 'package:sasha_botique/features/cart/domain/usecases/add_to_cart.dart';
import 'package:sasha_botique/features/cart/domain/usecases/clear_cart_item.dart';
import 'package:sasha_botique/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:sasha_botique/features/orders/domain/usecases/create_order.dart';
import 'package:sasha_botique/features/orders/domain/usecases/get_all_orders.dart';
import 'package:sasha_botique/features/orders/domain/usecases/get_user_by_id.dart';
import 'package:sasha_botique/features/orders/presentation/bloc/order_bloc.dart';
import 'package:sasha_botique/features/products/data/api_services/product_api_service.dart';
import 'package:sasha_botique/features/products/domain/usecases/add_to_favourite.dart';
import 'package:sasha_botique/features/products/domain/usecases/fetch_product_detail.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_favorite_products.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_popular_products.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_products_by_gender.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_products_on_sale.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_clearance_products.dart';
import 'package:sasha_botique/features/products/domain/usecases/get_accessories_products.dart';
import 'package:sasha_botique/features/products/domain/usecases/remove_from_favourite.dart';
import 'package:sasha_botique/features/products/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:sasha_botique/features/products/presentation/bloc/search/search_bloc.dart';
import 'package:sasha_botique/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sasha_botique/features/profile/domain/usecases/add_user_address.dart';
import 'package:sasha_botique/features/profile/presentation/bloc/user_address/user_address_bloc.dart';
import 'package:sasha_botique/features/profile/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/source/auth_local_data_source.dart';
import '../../features/auth/data/source/auth_remote_data_source.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/forget_password.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cart/data/repository/cart_repository_impl.dart';
import '../../features/cart/data/source/local_data_source.dart';
import '../../features/cart/data/source/remote_data_source.dart';
import '../../features/cart/domain/repository/cart_repository.dart';
import '../../features/cart/domain/usecases/get_cart_items_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/data/source/order_remote_source.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/usecases/get_promo_codes.dart';
import '../../features/orders/domain/usecases/update_payment_url.dart';
import '../../features/payment/data/data_source/payment_local_data_source.dart';
import '../../features/payment/data/data_source/payment_remote_data_source.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/add_payment_method.dart';
import '../../features/payment/domain/usecases/delete_payment_method.dart';
import '../../features/payment/domain/usecases/get_payment_methods.dart';
import '../../features/payment/domain/usecases/set_default_payment_method.dart';
import '../../features/payment/domain/usecases/update_payment_method.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';
import '../../features/products/data/source/product_local_data_source.dart';
import '../../features/products/data/source/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_new_arrival_products.dart';
import '../../features/products/domain/usecases/get_all_products.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/presentation/bloc/home/home_bloc.dart';
import '../../features/products/presentation/bloc/product_detail/product_details_bloc.dart';
import '../../features/profile/data/api_services/profile_api_service.dart';
import '../../features/profile/data/source/profile_remote_data_source.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/change_password.dart';
import '../../features/profile/domain/usecases/delete_user.dart';
import '../../features/profile/domain/usecases/delete_user_address.dart';
import '../../features/profile/domain/usecases/get_user_address.dart';
import '../../features/profile/domain/usecases/get_user_profile.dart';
import '../../features/profile/domain/usecases/set_default_user_address.dart';
import '../../features/profile/domain/usecases/update_profile_picture.dart';
import '../../features/profile/domain/usecases/update_user_address.dart';
import '../../features/profile/domain/usecases/update_user_profile.dart';
import '../../features/theme/data/source/theme_data_source.dart';
import '../../features/theme/domain/repositories/theme_repository.dart';
import '../../features/theme/data/repositories/theme_repository_impl.dart';
import '../../features/theme/presentation/bloc/theme_bloc.dart';
import '../services/hive_service.dart';
import '../helper/shared_preferences_service.dart';
import '../router/app_router.dart';
import '../router/navigation_service.dart';
import '../router/route_guards.dart';
import '../services/cart_product_communication_service/cart_product_comm_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Register SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<HiveService>(HiveService());
  await getIt<HiveService>().init();

  // Register SharedPreferencesService
  getIt.registerSingleton<SharedPreferencesService>(
    SharedPreferencesService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(getIt<SharedPreferencesService>()));

  // Repositories
  getIt.registerLazySingleton<ThemeRepository>(
      () => ThemeRepositoryImpl(getIt<ThemeLocalDataSource>()));

  // BLoCs
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc(getIt<ThemeRepository>()));
  // Core
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<NetworkManager>(
      NetworkManager(preferencesService: getIt<SharedPreferencesService>()));

  //Auth Service

  getIt.registerSingleton<AuthService>(AuthService(
      networkManager: getIt<NetworkManager>(),
      preferencesService: getIt<SharedPreferencesService>()));

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

  getIt.registerLazySingleton(
      () => CheckAuthStatusUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignupUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => ForgotPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => ResetPasswordUseCase(getIt<AuthRepository>()));

  // BLoC
  getIt.registerFactory(
    () => AuthBloc(
      checkAuthStatus: getIt<CheckAuthStatusUseCase>(),
      login: getIt<LoginUseCase>(),
      signup: getIt<SignupUseCase>(),
      logout: getIt<LogoutUseCase>(),
      forgotPassword: getIt<ForgotPasswordUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
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
  getIt.registerLazySingleton<ICartCommunicationService>(
    () => CartCommunicationService(getIt<CartBloc>()),
  );
  //Profile Injections
  getIt.registerLazySingleton<ProfileApiService>(() => ProfileApiService(
      getIt<NetworkManager>(), getIt<SharedPreferencesService>()));

  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
        getIt<ProfileApiService>()), // Implement this class for API calls
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getIt<ProfileRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetUserProfile>(
      () => GetUserProfile(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<ChangePassword>(
      () => ChangePassword(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<UpdateProfilePicture>(
      () => UpdateProfilePicture(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<UpdateUserProfile>(
      () => UpdateUserProfile(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<DeleteUser>(
      () => DeleteUser(getIt<ProfileRepository>()));

  getIt.registerSingleton<ProfileBloc>(ProfileBloc(
      getUserProfile: getIt<GetUserProfile>(),
      changePassword: getIt<ChangePassword>(),
      updateProfilePicture: getIt<UpdateProfilePicture>(),
      updateUserProfile: getIt<UpdateUserProfile>(),
      deleteUser: getIt<DeleteUser>()));

//Update User Address
  getIt.registerLazySingleton<UpdateUserAddress>(
      () => UpdateUserAddress(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<GetUserAddress>(
      () => GetUserAddress(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<AddUserAddress>(
      () => AddUserAddress(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<DeleteUserAddress>(
      () => DeleteUserAddress(getIt<ProfileRepository>()));
  getIt.registerLazySingleton<SetDefaultAddress>(
      () => SetDefaultAddress(getIt<ProfileRepository>()));

  //User Address Bloc
  getIt.registerSingleton<AddressBloc>(AddressBloc(
      getAddresses: getIt<GetUserAddress>(),
      addAddress: getIt<AddUserAddress>(),
      updateAddress: getIt<UpdateUserAddress>(),
      setDefaultAddress: getIt<SetDefaultAddress>(),
      deleteAddress: getIt<DeleteUserAddress>()));

  // Data sources
  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(
      getIt<NetworkManager>(),
    ),
  );
  getIt.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSourceImpl(getIt<HiveService>()),
  );
  // Repository
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: getIt<PaymentRemoteDataSource>(),
      localDataSource: getIt<PaymentLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
      () => GetPaymentMethods(getIt<PaymentRepository>()));
  getIt.registerLazySingleton(
      () => AddPaymentMethod(getIt<PaymentRepository>()));
  getIt.registerLazySingleton(
      () => UpdatePaymentMethod(getIt<PaymentRepository>()));
  getIt.registerLazySingleton(
      () => DeletePaymentMethod(getIt<PaymentRepository>()));
  getIt.registerLazySingleton(
      () => SetDefaultPaymentMethod(getIt<PaymentRepository>()));

  getIt.registerSingleton(
    PaymentBloc(
      getPaymentMethods: getIt<GetPaymentMethods>(),
      addPaymentMethod: getIt<AddPaymentMethod>(),
      updatePaymentMethod: getIt<UpdatePaymentMethod>(),
      deletePaymentMethod: getIt<DeletePaymentMethod>(),
      setDefaultPaymentMethod: getIt<SetDefaultPaymentMethod>(),
    ),
  );

  getIt.registerLazySingleton<ProductApiService>(
      () => ProductApiService(getIt<NetworkManager>()));
  // locator.registerSingleton<VideoRepository>(RemoteVideosRepository());
  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
        getIt<ProductApiService>()), // Implement this class for API calls
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
  getIt.registerLazySingleton<GetClearanceProductsUseCase>(
    () => GetClearanceProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetAccessoriesProductsUseCase>(
    () => GetAccessoriesProductsUseCase(getIt<ProductRepository>()),
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
      getClearanceProductsUseCase: getIt<GetClearanceProductsUseCase>(),
      getAccessoriesProductsUseCase: getIt<GetAccessoriesProductsUseCase>(),
      cartService: getIt<ICartCommunicationService>(),
    ),
  );

  getIt.registerLazySingleton<FetchProductDetailUseCase>(
      () => FetchProductDetailUseCase(getIt<ProductRepository>()));

  getIt.registerFactory<ProductDetailBloc>(() => ProductDetailBloc(
        fetchProductDetailUseCase: getIt<FetchProductDetailUseCase>(),
      ));

  //Cart Feature Dependencies
  getIt.registerLazySingleton<CartApiService>(
      () => CartApiService(getIt<NetworkManager>()));
  // Data sources
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt<CartApiService>()),
  );

  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(hiveService: getIt<HiveService>()),
  );

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remoteDataSource: getIt<CartRemoteDataSource>(),
      localDataSource: getIt<CartLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetCartItemsUsecase>(
      () => GetCartItemsUsecase(getIt<CartRepository>()));
  getIt.registerLazySingleton<AddToCartItemUseCase>(
      () => AddToCartItemUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton<RemoveFromCartUseCase>(
      () => RemoveFromCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton<ClearCartUseCase>(
      () => ClearCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton<UpdateCartItemQuantityUseCase>(
      () => UpdateCartItemQuantityUseCase(getIt<CartRepository>()));

  getIt.registerSingleton<CartBloc>(
    CartBloc(
      getCartItemsUsecase: getIt<GetCartItemsUsecase>(),
      addToCartItemUseCase: getIt<AddToCartItemUseCase>(),
      removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
      updateCartItemQuantityUseCase: getIt<UpdateCartItemQuantityUseCase>(),
    ),
  );

  ///Order Injections
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(
      networkManager: getIt<NetworkManager>(),
    ),
  );
  // Repository
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: getIt<OrderRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetAllOrdersUseCase>(
      () => GetAllOrdersUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton<GetOrderByIdUseCase>(
      () => GetOrderByIdUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton<CreateOrderUseCase>(
      () => CreateOrderUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton<GetPromoCodesUseCase>(
      () => GetPromoCodesUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton<UpdatePaymentUrlUseCase>(
      () => UpdatePaymentUrlUseCase(getIt<OrderRepository>()));

  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(
        createOrderUseCase: getIt<CreateOrderUseCase>(),
        getOrderByIdUseCase: getIt<GetOrderByIdUseCase>(),
        getAllOrdersUseCase: getIt<GetAllOrdersUseCase>(),
        getPromoCodes: getIt<GetPromoCodesUseCase>(),
        updatePaymentUrlUseCase: getIt<UpdatePaymentUrlUseCase>()),
  );
  //Favorite Usecase
  getIt.registerLazySingleton<AddToFavouriteUseCase>(
      () => AddToFavouriteUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton<GetFavoriteProductsUseCase>(
      () => GetFavoriteProductsUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton<RemoveFromFavoriteUseCase>(
      () => RemoveFromFavoriteUseCase(getIt<ProductRepository>()));
  //Fav and Search  Blocs
  // getIt.registerSingleton<FavoriteBloc>(() => FavoriteBloc(removeFromFavoriteUseCase: getIt<RemoveFromFavoriteUseCase>(), addToFavouriteUseCase: getIt<AddToFavouriteUseCase>(), getFavoriteProductsUseCase: getIt<GetFavoriteProductsUseCase>()));
  getIt.registerSingleton<FavoriteBloc>(FavoriteBloc(
      removeFromFavoriteUseCase: getIt<RemoveFromFavoriteUseCase>(),
      addToFavouriteUseCase: getIt<AddToFavouriteUseCase>(),
      getFavoriteProductsUseCase: getIt<GetFavoriteProductsUseCase>()));
  getIt.registerFactory<SearchBloc>(
      () => SearchBloc(searchProductsUseCase: getIt<SearchProductsUseCase>()));
}
