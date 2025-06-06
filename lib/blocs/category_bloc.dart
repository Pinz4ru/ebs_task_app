import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

// Events
abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

// States
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}

// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await categoryRepository.fetchCategoriesFromProducts();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError('Failed to load categories: ${e.toString()}'));
      }
    });
  }
}
