import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../networking/dio_factory.dart';
import '../../features/auth/data/auth_remote_service.dart';
import '../../features/auth/logic/auth_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());

  getIt.registerLazySingleton<AuthRemoteService>(
        () => AuthRemoteService(getIt()),
  );

  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(getIt()),
  );
}