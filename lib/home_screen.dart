import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dharma_deshana_app/mulpituwa_audio2.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:dharma_deshana_app/side-navigation/aramuna_screen.dart';
import 'package:dharma_deshana_app/side-navigation/contact_us.dart';
import 'package:dharma_deshana_app/side-navigation/deshana.dart';
import 'package:dharma_deshana_app/side-navigation/niwiime_paniwidaya.dart';
import 'package:dharma_deshana_app/side-navigation/favorite_deshana.dart';
import 'package:dharma_deshana_app/side-navigation/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> quotes = [];
  List<Map<String, dynamic>> deshana = [];
  Map<String, String>? lastObject;
  String lastDeshanaName = '';
  String lastDeshanaURL = '';
  int lastDeshanaId = 0;
  bool isFavLastId = false;
  List<String>? favoriteIds;
  SharedPreferences? _storage;

  @override
  void initState() {
    super.initState();
    getData();
    getData2();
  }

  Future<void> getData() async {
    final String response =
        await rootBundle.loadString('assets/json/quotes.json');
    final data = await json.decode(response);

    setState(() {
      quotes = List<Map<String, dynamic>>.from(data['data']);
    });
  }

  Future<void> getData2() async {
    _storage = await SharedPreferences.getInstance();

    favoriteIds = await _storage!.getStringList('favoriteIds') ?? [];
    print("mulpituwa fav ids ${favoriteIds}");

    final String response2 =
        await rootBundle.loadString('assets/json/deshana.json');
    final data2 = await json.decode(response2);

    setState(() {
      deshana = List<Map<String, dynamic>>.from(data2['data']);
    });

    lastDeshanaName = deshana.isNotEmpty ? deshana.last['deshananame'] : '';
    lastDeshanaId = deshana.isNotEmpty ? deshana.last['id'] : '';
    lastDeshanaURL = deshana.isNotEmpty ? deshana.last['deshanaplay'] : '';

    isFavLastId =
        favoriteIds != null && favoriteIds!.contains(lastDeshanaId.toString());

    print("isfavId is ${isFavLastId}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Color.fromARGB(255, 6, 115, 204), size: 25),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(Responsive.isMobileSmall(context)
                ? 1
                : Responsive.isMobileMedium(context) ||
                        Responsive.isMobileLarge(context)
                    ? 1
                    : Responsive.isTabletLandscape(context)
                        ? 5
                        : 10.0),
            child: Container(
              color: Colors.grey[300],
              height: 1.0,
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "නිවන් දකිමු",
            style: GoogleFonts.notoSerif(
              color: Color.fromARGB(255, 239, 183, 16),
              fontSize: Responsive.isMobileSmall(context)
                  ? 16
                  : Responsive.isMobileMedium(context) ||
                          Responsive.isMobileLarge(context)
                      ? 18
                      : Responsive.isTabletLandscape(context)
                          ? 27
                          : 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        drawer: Drawer(
          elevation: 5,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: Responsive.isMobileSmall(context)
                      ? 440
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? 500
                          : Responsive.isTabletLandscape(context)
                              ? 550
                              : 550,
                  color: Colors.white.withOpacity(0.9),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: Responsive.isMobileSmall(context)
                            ? 70
                            : Responsive.isMobileMedium(context) ||
                                    Responsive.isMobileLarge(context)
                                ? 80
                                : Responsive.isTabletLandscape(context)
                                    ? 85
                                    : 90,
                        child: DrawerHeader(
                          padding: EdgeInsets.symmetric(
                              vertical: 19, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                          ),
                          child: Text(
                            'නිවන් දකිමු',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.isMobileSmall(context)
                                  ? 16
                                  : Responsive.isMobileMedium(context) ||
                                          Responsive.isMobileLarge(context)
                                      ? 18
                                      : Responsive.isTabletLandscape(context)
                                          ? 25
                                          : 25,
                            ),
                          ),
                        ),
                      ),
                      buildListTile(
                        index: 0,
                        icon: "assets/icons/dharma-wheel.svg",
                        title: "මුල් පිටුව",
                        destination: HomeScreen(),
                      ),
                      buildListTile(
                        index: 1,
                        icon: "assets/icons/headphones.svg",
                        title: "දේශනා",
                        destination: DeshanaScreen(),
                      ),
                      buildListTile(
                        index: 2,
                        icon: "assets/icons/target.svg",
                        title: "අරමුණ",
                        destination: AramunaScreen(),
                      ),
                      buildListTile(
                        index: 3,
                        icon: "assets/icons/favourite-heart.svg",
                        title: "ප්‍රියතම දේශනා",
                        destination: PriyathamaDeshana(),
                      ),
                      buildListTile(
                        index: 4,
                        icon: "assets/icons/reading.svg",
                        title: "නිවීමේ පණිවිඩය",
                        destination: NiwimePaniwidayaScreen(),
                      ),
                      buildListTile(
                        index: 5,
                        icon: "assets/icons/contact-us.svg",
                        title: "සම්බන්ධ වීමට",
                        destination: ContactUsScreen(),
                      ),
                      buildListTile(
                        index: 6,
                        icon: "assets/icons/magazine.svg",
                        title: "සැකසුම්",
                        destination: SakasumScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: size.width,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Image.asset(
                  "assets/images/icon.png",
                  width: Responsive.isMobileSmall(context)
                      ? size.width * 0.66
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? size.width * 0.87
                          : Responsive.isTabletLandscape(context)
                              ? size.width * 0.7
                              : size.width * 0.73,
                  height: Responsive.isMobileSmall(context)
                      ? size.width * 0.66
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? size.width * 0.87
                          : Responsive.isTabletLandscape(context)
                              ? size.width * 0.7
                              : size.width * 0.73,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    width: size.width * 0.9,
                    height: Responsive.isMobileSmall(context)
                        ? 90
                        : Responsive.isMobileMedium(context) ||
                                Responsive.isMobileLarge(context)
                            ? 100
                            : Responsive.isTabletLandscape(context)
                                ? 130
                                : 140,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "නවතම දේශනාව",
                          style: GoogleFonts.notoSerif(
                            color: Colors.white,
                            fontSize: Responsive.isMobileSmall(context)
                                ? 12
                                : Responsive.isMobileMedium(context) ||
                                        Responsive.isMobileLarge(context)
                                    ? 13
                                    : Responsive.isTabletLandscape(context)
                                        ? 18
                                        : 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return MulpituwaAudioPlayerPopup(
                                  isCurrentlyPlayingFavorite: isFavLastId,
                                  deshanaurl: lastDeshanaURL,
                                  deshanawa: lastDeshanaName,
                                );
                              },
                            );
                          },
                          child: Container(
                            height: Responsive.isMobileSmall(context)
                                ? 42
                                : Responsive.isMobileMedium(context) ||
                                        Responsive.isMobileLarge(context)
                                    ? 50
                                    : Responsive.isTabletLandscape(context)
                                        ? 60
                                        : 70,
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  lastDeshanaId.toString(),
                                  style: GoogleFonts.notoSerif(
                                    color: Colors.amber,
                                    fontSize: Responsive.isMobileSmall(context)
                                        ? 17
                                        : Responsive.isMobileMedium(context) ||
                                                Responsive.isMobileLarge(
                                                    context)
                                            ? 18
                                            : Responsive.isTabletLandscape(
                                                    context)
                                                ? 24
                                                : 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(isFavLastId
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                  onPressed: () {},
                                  iconSize: Responsive.isMobileSmall(context)
                                      ? 23
                                      : Responsive.isMobileMedium(context) ||
                                              Responsive.isMobileLarge(context)
                                          ? 25
                                          : Responsive.isTabletLandscape(
                                                  context)
                                              ? 30
                                              : 32,
                                  color: Colors.amber,
                                ),
                                Text(
                                  lastDeshanaName,
                                  style: GoogleFonts.notoSerif(
                                    color: Colors.amber,
                                    fontSize: Responsive.isMobileSmall(context)
                                        ? 11
                                        : Responsive.isMobileMedium(context) ||
                                                Responsive.isMobileLarge(
                                                    context)
                                            ? 12
                                            : Responsive.isTabletLandscape(
                                                    context)
                                                ? 17
                                                : 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.22,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        reverse: false,
                        height: 200.0,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                      ),
                      items: quotes.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: size.width,
                              child: Center(
                                child: Text(
                                  '"${item['text']}"',
                                  style: GoogleFonts.notoSerif(
                                    fontSize: Responsive.isMobileSmall(context)
                                        ? 10
                                        : Responsive.isMobileMedium(context) ||
                                                Responsive.isMobileLarge(
                                                    context)
                                            ? 11
                                            : Responsive.isTabletLandscape(
                                                    context)
                                                ? 14
                                                : 17,
                                    color: Colors.amber[300],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                      width: size.width * 0.9,
                      height: size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DeshanaScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/headphones.svg',
                                  width: Responsive.isMobileSmall(context)
                                      ? 20
                                      : Responsive.isMobileMedium(context) ||
                                              Responsive.isMobileLarge(context)
                                          ? 25
                                          : Responsive.isTabletLandscape(
                                                  context)
                                              ? 28
                                              : 30,
                                  height: Responsive.isMobileSmall(context)
                                      ? 20
                                      : Responsive.isMobileMedium(context) ||
                                              Responsive.isMobileLarge(context)
                                          ? 25
                                          : Responsive.isTabletLandscape(
                                                  context)
                                              ? 28
                                              : 30,
                                  color: Colors.amber[400],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "දේශනා",
                                  style: GoogleFonts.notoSerif(
                                    color: Colors.white,
                                    fontSize: Responsive.isMobileSmall(context)
                                        ? 10
                                        : Responsive.isMobileMedium(context) ||
                                                Responsive.isMobileLarge(
                                                    context)
                                            ? 11
                                            : Responsive.isTabletLandscape(
                                                    context)
                                                ? 16
                                                : 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AramunaScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/target.svg',
                                  width: Responsive.isMobileSmall(context)
                                      ? 20
                                      : Responsive.isMobileMedium(context) ||
                                              Responsive.isMobileLarge(context)
                                          ? 25
                                          : Responsive.isTabletLandscape(
                                                  context)
                                              ? 28
                                              : 30,
                                  height: Responsive.isMobileSmall(context)
                                      ? 20
                                      : Responsive.isMobileMedium(context) ||
                                              Responsive.isMobileLarge(context)
                                          ? 25
                                          : Responsive.isTabletLandscape(
                                                  context)
                                              ? 28
                                              : 30,
                                  color: Colors.amber[400],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "අරමුණ",
                                  style: GoogleFonts.notoSerif(
                                    color: Colors.white,
                                    fontSize: Responsive.isMobileSmall(context)
                                        ? 10
                                        : Responsive.isMobileMedium(context) ||
                                                Responsive.isMobileLarge(
                                                    context)
                                            ? 11
                                            : Responsive.isTabletLandscape(
                                                    context)
                                                ? 16
                                                : 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(
      {required int index,
      required String icon,
      required String title,
      required Widget destination}) {
    return ListTile(
      visualDensity: Responsive.isMobileSmall(context)
          ? VisualDensity.compact
          : Responsive.isMobileMedium(context) ||
                  Responsive.isMobileLarge(context)
              ? VisualDensity.compact
              : Responsive.isTabletLandscape(context)
                  ? VisualDensity.standard
                  : VisualDensity.standard,
      leading: SvgPicture.asset(
        icon,
        width: Responsive.isMobileSmall(context)
            ? 20
            : Responsive.isMobileMedium(context) ||
                    Responsive.isMobileLarge(context)
                ? 25
                : Responsive.isTabletLandscape(context)
                    ? 28
                    : 30,
        height: Responsive.isMobileSmall(context)
            ? 20
            : Responsive.isMobileMedium(context) ||
                    Responsive.isMobileLarge(context)
                ? 25
                : Responsive.isTabletLandscape(context)
                    ? 28
                    : 30,
        color: selectedIndex == index ? Colors.amber : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.isMobileSmall(context)
              ? 13
              : Responsive.isMobileMedium(context) ||
                      Responsive.isMobileLarge(context)
                  ? 15
                  : Responsive.isTabletLandscape(context)
                      ? 20
                      : 20,
          fontWeight:
              selectedIndex == index ? FontWeight.bold : FontWeight.w500,
          color: selectedIndex == index ? Colors.amber : Colors.black,
        ),
      ),
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
    );
  }
}
