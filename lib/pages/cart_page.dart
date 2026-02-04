import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import '../pages/checkout_page.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/checkout_summary_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Fetch cart items when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartController>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<CartController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.cartItems.isEmpty) {
              // Handle empty cart view or redirect
              // Note: The previous logic redirected to BottomNavigation which might contain this page,
              // causing a loop or weird UX if this IS the cart tab.
              // Better to show an empty state message here.
              return const Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = controller.cartItems[index];
                      return CartItemCard(
                        product: cartItem.product,
                        onDelete: () async {
                          await controller.removeFromCart(cartItem.id);

                          if (context.mounted && controller.cartItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Your cart is now empty!",
                                  style: TextStyle(fontSize: 18),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 1),
                              ),
                            );
                            // Optional: Redirect if needed, or just let the empty view show
                          }
                        },
                      );
                    },
                  ),
                ),
                CheckoutSummaryCard(
                  totalPrice: controller.total,
                  onCheckout: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => CheckoutPage(
                          items: controller.cartItems
                              .map((e) => e.product)
                              .toList(),
                          totalPrice: controller.total,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
