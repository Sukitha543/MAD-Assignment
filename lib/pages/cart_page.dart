import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import '../controllers/network_controller.dart';
import '../pages/checkout_page.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/checkout_summary_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor handled by theme
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your Cart is Empty",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
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
                          final networkController =
                              Provider.of<NetworkController>(
                                context,
                                listen: false,
                              );

                          if (!networkController.isConnected) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Failed to remove: No internet connection",
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

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
                    final networkController = Provider.of<NetworkController>(
                      context,
                      listen: false,
                    );

                    if (!networkController.isConnected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Failed to proceed: No internet connection",
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

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
