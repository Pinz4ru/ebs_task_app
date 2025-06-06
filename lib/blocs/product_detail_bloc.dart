import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/product_repository.dart';

// EVENTS
abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchProductDetail extends ProductDetailEvent {
  final int productId;

  const FetchProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}

// STATES
abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Map<String, dynamic> product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}

// BLOC
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;

  ProductDetailBloc(this.repository) : super(ProductDetailInitial()) {
    on<FetchProductDetail>((event, emit) async {
      emit(ProductDetailLoading());
      try {
        final product = await repository.fetchProductDetail(event.productId);
        emit(ProductDetailLoaded(product));
      } catch (e) {
        emit(ProductDetailError(e.toString()));
      }
    });
  }
}