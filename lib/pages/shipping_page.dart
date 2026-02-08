import 'package:flutter/material.dart';
import 'package:mad_assignment/services/location_service.dart';
import 'package:mad_assignment/widgets/payment_button.dart';
import 'package:mad_assignment/services/api_service.dart';
import 'package:mad_assignment/controllers/auth_controller.dart';
import 'package:mad_assignment/controllers/cart_controller.dart';
import 'package:mad_assignment/pages/payment_webview.dart';
import 'package:provider/provider.dart';

class ShippingPage extends StatefulWidget {
  final double totalPrice;

  const ShippingPage({super.key, required this.totalPrice});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  final TextEditingController shippingNameController = TextEditingController();
  final TextEditingController shippingEmailController = TextEditingController();
  final TextEditingController shippingContactController =
      TextEditingController();
  final TextEditingController shippingAddressController =
      TextEditingController();
  final TextEditingController shippingCityController = TextEditingController();

  //GET CURRENT LOCATION
  final LocationService _locationService = LocationService();

  Future<void> autoFillAddressFromLocation() async {
    try {
      final locationData = await _locationService.getCurrentAddress();

      if (!mounted) return;

      setState(() {
        shippingAddressController.text = locationData['address']!;
        shippingCityController.text = locationData['city']!;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to Detect Location")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Shipping Details"),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Total: \$${widget.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Account Holder
                    TextField(
                      controller: shippingNameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Card Number
                    TextField(
                      controller: shippingEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Expiry Date Picker
                    TextField(
                      controller: shippingContactController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Contact Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: shippingAddressController,
                      onTap: autoFillAddressFromLocation,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: shippingCityController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "City",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Confirm Payment Button
                    PaymentButton(
                      onPressed: () {
                        if (shippingNameController.text.isEmpty ||
                            shippingEmailController.text.isEmpty ||
                            shippingContactController.text.isEmpty ||
                            shippingAddressController.text.isEmpty ||
                            shippingCityController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill all the Shipping Details",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else if (shippingContactController.text.length < 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Contact number must be at least 10 digits.",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          _processPayment();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    // 1. Show Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      final token = await authController.getToken();

      if (token == null) {
        throw Exception("User not authenticated");
      }

      // 2. Create Checkout Session
      final sessionData = await ApiService.createCheckoutSession(
        name: shippingNameController.text,
        email: shippingEmailController.text,
        phone: shippingContactController.text,
        address: shippingAddressController.text,
        city: shippingCityController.text,
        token: token,
      );

      // Close Loading
      if (mounted) Navigator.pop(context);

      final checkoutUrl = sessionData['checkout_url'];

      // 3. Navigate to WebView
      if (mounted && checkoutUrl != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(checkoutUrl: checkoutUrl),
          ),
        );

        // 4. Handle Result
        if (result != null && result['success'] == true) {
          final sessionId = result['session_id'];
          if (sessionId != null) {
            _confirmOrder(sessionId, token);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Payment Cancelled"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading if open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().replaceAll('Exception: ', '')}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmOrder(String sessionId, String token) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ApiService.confirmPayment(sessionId: sessionId, token: token);

      if (mounted) {
        // Clear Cart Locally
        Provider.of<CartController>(context, listen: false).clearCartLocally();

        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Order Placed Successfully!",
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to Home or Orders
        // Assuming there is a route '/' or similar, or pop to first
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Payment Successful but Order Confirmation Failed: $e",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
