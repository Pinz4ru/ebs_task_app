import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_detail_bloc.dart';
import '../repositories/product_repository.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailBloc(ProductRepository())
        ..add(FetchProductDetail(productId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
  builder: (context, state) {
    if (state is ProductDetailLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ProductDetailError) {
      return Center(child: Text('Error: ${state.message}'));
    } else if (state is ProductDetailLoaded) {
      final product = state.product;
      final imageUrl = product['main_image'] ?? '';

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image as square with rounded corners and placeholder
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),

                    // Product Info Section
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            product['name'] ?? 'Product Name',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 24),

                          // Size and Color Selectors
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Size Selector
                              _buildSelectionBox(
                                label: 'Size',
                                value: 'XL', // Default size
                                width: 160,
                              ),
                              
                              // Color Selector
                              _buildSelectionBox(
                                label: 'Color',
                                valueWidget: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2F3135),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                width: 160,
                              ),
                            ],
                          ),
                          SizedBox(height: 36),

                          // Product Description
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            product['description'] ?? 'No description available',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Read More',
                            style: TextStyle(
                              color: Color(0xFF00C569),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 40),

                          // Reviews Section
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Write your review',
                            style: TextStyle(
                              color: Color(0xFF00C569),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 24),

                          // Sample Reviews
                          _buildReview(
                            'Samuel Smith',
                            'Wonderful product, perfect gift!',
                            'https://placehold.co/46x46',
                            4,
                          ),
                          _buildReview(
                            'Beth Aida',
                            'Very comfortable and fits perfectly.',
                            'https://placehold.co/46x46',
                            5,
                          ),
                          SizedBox(height: 100), // Space for bottom bar
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildSelectionBox({
    required String label,
    String? value,
    Widget? valueWidget,
    required double width,
  }) {
    return Container(
      width: width,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Color(0xFFEBEBEB),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          valueWidget ?? Text(
            value ?? '',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(String name, String review, String imageUrl, int rating) {
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) => 
                        Icon(
                          Icons.star,
                          size: 18,
                          color: index < rating ? Colors.amber : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  review,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 84,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF4F4F4),
            blurRadius: 20,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoaded) {
            final product = state.product;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PRICE',
                      style: TextStyle(
                        color: Color(0xFF929292),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '\$${product['price']?.toString() ?? '0.00'}',
                      style: TextStyle(
                        color: Color(0xFF00C569),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00C569),
                    padding: EdgeInsets.symmetric(
                      horizontal: 58,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    // Add to cart functionality
                  },
                  child: Text(
                    'ADD TO CART',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}