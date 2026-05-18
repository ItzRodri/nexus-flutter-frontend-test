import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexustestapp/src/modules/common/managers/api_constants.dart';
import 'package:nexustestapp/src/modules/core/modular/navigation.dart';
import 'package:nexustestapp/src/modules/core/src/data/repositories/product.repository.dart';
import 'package:nexustestapp/src/modules/core/src/data/services/recent_products_service.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/bloc/product_cubit.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/pages/product.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/pages/product_detail.dart';

class ProductModule extends Module {
  final SharedPreferences prefs;

  ProductModule(this.prefs);

  @override
  void binds(Injector i) {
    i.addInstance<SharedPreferences>(prefs);
    i.addSingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: baseUrlApi,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => status != null && status < 500,
        ),
      ),
    );
    i.addSingleton<RecentProductsService>(
      () => RecentProductsService(i<SharedPreferences>()),
    );
    i.addSingleton<ProductRepository>(
      () => ProductRepository(dio: i<Dio>()),
    );
    i.addSingleton<ProductCubit>(
      () => ProductCubit(i<ProductRepository>(), i<RecentProductsService>()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.redirect('/', to: ProductPath.productHome);
    r.child(
      ProductPath.productHome,
      child: (_) => BlocProvider.value(
        value: Modular.get<ProductCubit>(),
        child: const ProductHome(),
      ),
    );
    r.child(
      ProductPath.productDetail,
      child: (_) => const ProductDetailPage(),
    );
  }
}
