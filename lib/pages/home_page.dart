import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mad_assignment/services/battery_service.dart';
import 'package:provider/provider.dart';
import 'package:mad_assignment/controllers/auth_controller.dart';
import 'package:mad_assignment/widgets/brand_card.dart'; // Retained for BrandCard usage
import 'package:mad_assignment/widgets/contact_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();

  //DATE AND TIME FORMATTERS
  final DateFormat formatter = DateFormat('EEEE, MMMM');
  final DateFormat dayformat = DateFormat("dd");

  //SHOW BATTERY STATUS
  final BatteryService _batteryService = BatteryService();
  int _batteryLevel = 0;

  Future<void> loadBatteryInfo() async {
    final batteryInfo = await _batteryService.getBatteryInfo();

    if (!mounted) return;

    setState(() {
      _batteryLevel = batteryInfo['level'];
    });
  }

  @override
  void initState() {
    super.initState();
    checkToken();
    loadBatteryInfo();
  }

  Future<void> checkToken() async {
    String? token = await storage.read(key: 'token');
    debugPrint("READ TOKEN OFFLINE: $token");
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.user;

    DateTime now = DateTime.now();
    String formattedDate = formatter.format(now);
    String date = dayformat.format(now);

    // Get orientation and screen width
    Orientation orientation = MediaQuery.of(context).orientation;
    double screenWidth = MediaQuery.of(context).size.width;

    bool isLandscape = orientation == Orientation.landscape;
    bool isWideScreen = screenWidth > 600;

    Widget brandsLayout;
    if (isLandscape || isWideScreen) {
      brandsLayout = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BrandCard(imageUrl: "assets/images/omegalogo.png"),
          BrandCard(imageUrl: "assets/images/rolexlogo.png"),
          BrandCard(imageUrl: "assets/images/seikologo.png"),
        ],
      );
    } else {
      brandsLayout = Column(
        children: [
          BrandCard(imageUrl: "assets/images/omegalogo.png"),
          SizedBox(height: 20),
          BrandCard(imageUrl: "assets/images/rolexlogo.png"),
          SizedBox(height: 20),
          BrandCard(imageUrl: "assets/images/seikologo.png"),
        ],
      );
    }

    return Scaffold(
      // backgroundColor handled by theme
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  "$formattedDate $date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,

                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "Welcome, ${user?.name ?? "Guest"}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,

                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.green.shade50
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.green
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.battery_full,
                        color: _batteryLevel < 20 ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$_batteryLevel%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset("assets/images/Hero.jpg"),
                ),
                SizedBox(height: 10),
                Text(
                  "Find Your Perfect TimePiece Online",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "From classic designs to modern masterpieces, each watch in our collection is meticulously crafted to combine precision, beauty, and legacy. Elevate your style with a timepiece that tells more than time—it tells your story.",
                  style: TextStyle(
                    fontSize: 18,

                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Text(
                    "Our Brands",
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(child: brandsLayout),
                SizedBox(height: 30),
                Center(child: ContactCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
