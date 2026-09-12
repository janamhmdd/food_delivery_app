import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../networking/dio_factory.dart';
import '../../features/auth/data/auth_remote_service.dart';
import '../../features/auth/data/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/auth/data/restaurant_remote_service.dart';
import '../../features/auth/data/restaurant_repo_impl.dart';
import '../../features/auth/domain/repositories/restaurant_repository.dart';
import '../../features/auth/logic/home_cubit.dart';
import '../../features/auth/logic/favorites_cubit.dart';
import '../../features/auth/logic/orders_cubit.dart';
import '../../features/auth/logic/cart_cubit.dart';
final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());

  getIt.registerLazySingleton<AuthRemoteService>(
    () => AuthRemoteService(getIt()),
  );
  getIt.registerLazySingleton<CartCubit>(
  () => CartCubit(getIt<RestaurantRepository>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(getIt<AuthRemoteService>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RestaurantRemoteService>(
    () => RestaurantRemoteService(getIt()),
  );

  getIt.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepoImpl(getIt<RestaurantRemoteService>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<RestaurantRepository>()),
  );

  getIt.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(getIt<RestaurantRepository>()),
);
  getIt.registerLazySingleton<OrdersCubit>(
  () => OrdersCubit(getIt<RestaurantRepository>()),
);
}