import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen.dart';
import 'blocs/category_bloc.dart';
import 'blocs/product_bloc.dart';
import 'repositories/category_repository.dart';
import 'repositories/product_repository.dart';

void main() {
  runApp(const MobileShopApp());
}

class MobileShopApp extends StatelessWidget {
  const MobileShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider<CategoryBloc>(
      create: (context) => CategoryBloc(categoryRepository: CategoryRepository())..add(LoadCategories()),
    ),
    BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(productRepository: ProductRepository())..add(LoadProducts()),
        ),
  ],
      child: MaterialApp(
        title: 'Mobile Shop',
        theme: ThemeData(primarySwatch: Colors.red),
        home: const HomeScreen(),
      ),
    );
  }
}
