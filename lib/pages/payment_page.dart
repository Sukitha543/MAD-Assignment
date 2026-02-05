import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mad_assignment/widgets/payment_button.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;

  const PaymentPage({super.key, required this.totalPrice});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController shippingNameController = TextEditingController();
  final TextEditingController shippingEmailController = TextEditingController();
  final TextEditingController shippingContactController =
      TextEditingController();
  final TextEditingController shippingAddressController =
      TextEditingController();
  final TextEditingController shippingCityController = TextEditingController();

  //GET CURRENT LOCATION
  Future<void> autoFillAddressFromLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enable location services")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
        return;
      }

      // Use the new LocationSettings API
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      Placemark place = placemarks.first;

      String address =
          "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}";
      String city = place.locality ?? '';

      setState(() {
        shippingAddressController.text = address;
        shippingCityController.text = city;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to detect location")),
      );
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
                      readOnly: true,
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
                          shippingNameController.clear();
                          shippingEmailController.clear();
                          shippingContactController.clear();
                          shippingAddressController.clear();
                          shippingCityController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Order Placed Sucessfully",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ),
                            // NAVIGATE TO STRIPE PAYMENT GATEWAY
                          );
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
}
