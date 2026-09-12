import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/themes/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/logic/favorites_cubit.dart';
import 'features/auth/logic/orders_cubit.dart';
import 'features/auth/logic/cart_cubit.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesCubit>.value(value: getIt<FavoritesCubit>()),
        BlocProvider<OrdersCubit>.value(value: getIt<OrdersCubit>()),
        BlocProvider<CartCubit>.value(value: getIt<CartCubit>()),
      ],
      child: MaterialApp(
        title: 'Food Delivery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: Routes.splash,
      ),
    );
  }
}