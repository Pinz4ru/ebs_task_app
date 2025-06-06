import 'package:ebs_task_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/category_bloc.dart';
import '../blocs/product_bloc.dart';
import '../widgets/top.dart';  // Import your Top widget

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          const Top(), // Your custom header instead of AppBar

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8), 
                  const Text(
                    "Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoryLoaded) {
                        final categories = state.categories;
                        return SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              return GestureDetector(
                                onTap: () {
                                  context.read<ProductBloc>().add(LoadProductsByCategoryId(categoryId: cat.id));
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(radius: 30, backgroundImage: NetworkImage(cat.icon)),
                                      const SizedBox(height: 6),
                                      Text(cat.name, style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(child: Text("Failed to load categories"));
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Best Selling",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("See all", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProductLoaded) {
                        final products = state.products;
                        return GridView.builder(
                          itemCount: products.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(productId: product.id), // pass product.id here
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: product.imageUrl.isNotEmpty
                                        ? Image.network(product.imageUrl, fit: BoxFit.cover)
                                        : Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.image_not_supported),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 6),
                              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(
                              "\$${product.price}",
                              style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00C569),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                        );
                      } else if (state is ProductError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(child: Text("Failed to load products"));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
