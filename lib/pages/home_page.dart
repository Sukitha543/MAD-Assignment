import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mad_assignment/data/user_data.dart';
import 'package:mad_assignment/widgets/brand_card.dart';
import 'package:mad_assignment/widgets/contact_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Date and Time Formatters
  final DateFormat formatter = DateFormat('EEEE, MMMM');
  final DateFormat dayformat = DateFormat("dd");

  //User Data
  final userData = user;

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.white,
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
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Hello, ${userData.username}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                    color: const Color.fromARGB(255, 67, 65, 65),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Text(
                    "Our Brands",
                    style: GoogleFonts.poppins(fontSize: 35, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 15),
                Center(child: brandsLayout),
                SizedBox(height: 30),
                Center(
                  child: ContactCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
