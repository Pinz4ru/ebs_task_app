import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';


// Events
abstract class ProductEvent {}

class LoadProducts extends ProductEvent {
  final int page;

  LoadProducts({this.page = 1});
}

class LoadProductsByCategoryId extends ProductEvent {
  final int categoryId;

  LoadProductsByCategoryId({required this.categoryId});
}


// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;

  ProductLoaded(
    this.products, {
    this.hasReachedMax = false,
    this.currentPage = 1,
  });
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
  emit(ProductLoading());
  try {
    final products = await productRepository.fetchProducts(page: event.page);
    emit(ProductLoaded(products));
  } catch (e) {
    emit(ProductError('Failed to load products: ${e.toString()}'));
  }
});
    on<LoadProductsByCategoryId>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productRepository.fetchProductsByCategoryId(event.categoryId);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to load products by category ID: ${e.toString()}'));
      }
    });

  }
}
