import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dharma_deshana_app/home_screen.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:dharma_deshana_app/side-navigation/aramuna_screen.dart';
import 'package:dharma_deshana_app/side-navigation/bottom_sheet.dart';
import 'package:dharma_deshana_app/side-navigation/contact_us.dart';
import 'package:dharma_deshana_app/side-navigation/deshana.dart';
import 'package:dharma_deshana_app/side-navigation/niwiime_paniwidaya.dart';
import 'package:dharma_deshana_app/side-navigation/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriyathamaDeshana extends StatefulWidget {
  const PriyathamaDeshana({super.key});

  @override
  State<PriyathamaDeshana> createState() => _PriyathamaDeshanaState();
}

class _PriyathamaDeshanaState extends State<PriyathamaDeshana> {
  int selectedIndex = 3;
  TextEditingController searchController = new TextEditingController();
  List<Map<String, dynamic>> favoriteDeshana = [];
  List<Map<String, dynamic>> filteredDeshana = [];
  int _currentPlayingIndex = -1;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getFavoriteDeshana();
  }

  void updateCurrentlyPlayingIndex(int index) {
    if (mounted)
      setState(() {
        _currentPlayingIndex = index;
      });
  }

  Future<void> getFavoriteDeshana() async {
    prefs = await SharedPreferences.getInstance();
    String? favoritesJson = prefs.getString('favorites');

    if (favoritesJson == null) {
    } else {
      final data = await jsonDecode(favoritesJson);

      if (mounted)
        setState(() {
          favoriteDeshana = List<Map<String, dynamic>>.from(data['favorites']);
          favoriteDeshana.sort((a, b) {
            return b['id'].compareTo(a['id']);
          });
          filteredDeshana = List.from(favoriteDeshana);

          // Add 'isFavorite' attribute to each item
          // Assuming all items loaded from favorites are initially favorites

          favoriteDeshana.forEach((item) {
            item['isFavorite'] = true;
          });
        });
    }
  }

  void _filterDeshana(String query) {
    if (mounted)
      setState(() {
        if (query.isEmpty) {
          filteredDeshana = List.from(favoriteDeshana);
        } else {
          filteredDeshana = favoriteDeshana.where((item) {
            String deshananame = item['deshananame'].toString();
            return deshananame.contains(query);
          }).toList();
        }
      });
  }

  void _updateFavoriteStatusFromPlayer(int index, bool isFavorite) {
    if (mounted)
      setState(() {
        favoriteDeshana.map((deshana) => true).toList()[index] = isFavorite;
      });
  }

  void _updateFavoriteStatus(int index, bool isFavorite) async {
    if (mounted) {
      print(1);
      setState(() {
        favoriteDeshana[index]['isFavorite'] = !isFavorite;
        print(2);

        // if (!isFavorite) {
        print(3);

        // Remove the unfavorited Deshana's ID from favoriteIds list
        List<String>? favoriteIds = prefs.getStringList('favoriteIds');
        print("removed item id" + favoriteDeshana[index]['id'].toString());
        favoriteIds!.remove(favoriteDeshana[index]['id'].toString());
        prefs.setStringList('favoriteIds', favoriteIds);

        favoriteDeshana.removeAt(index);
        filteredDeshana.removeAt(index);
        // }

        _updateFavoritesInSharedPreferences();

        _reloadFilteredDeshanaFromSharedPreferences();
      });
    }
  }

  Future<void> _updateFavoritesInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove unfavorite items from favoriteDeshana list
    List<Map<String, dynamic>> updatedFavorites =
        favoriteDeshana.where((item) => item['isFavorite']).toList();

    // Convert the updatedFavorites list to a JSON string
    String favoritesJson = jsonEncode({"favorites": updatedFavorites});

    // Save the JSON string to SharedPreferences
    await prefs.setString('favorites', favoritesJson);
  }

  Future<void> _reloadFilteredDeshanaFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesJson = prefs.getString('favorites');

    if (favoritesJson != null) {
      final data = jsonDecode(favoritesJson);
      setState(() {
        favoriteDeshana = List<Map<String, dynamic>>.from(data['favorites']);
        favoriteDeshana.sort((a, b) {
          return b['id'].compareTo(a['id']);
        });
        filteredDeshana = List.from(favoriteDeshana);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
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
            "ප්‍රියතම දේශනා",
            style: TextStyle(
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
                      ? 450
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? 500
                          : Responsive.isTabletLandscape(context)
                              ? 550
                              : 550,
                  color: Colors.white.withOpacity(0.8),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: Responsive.isMobileSmall(context)
                            ? 75
                            : Responsive.isMobileMedium(context) ||
                                    Responsive.isMobileLarge(context)
                                ? 80
                                : Responsive.isTabletLandscape(context)
                                    ? 85
                                    : 90,
                        child: DrawerHeader(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
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
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                //this
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            height: Responsive.isMobileSmall(context)
                                ? size.width * 0.3
                                : Responsive.isMobileMedium(context) ||
                                        Responsive.isMobileLarge(context)
                                    ? size.width * 0.25
                                    : Responsive.isTabletLandscape(context)
                                        ? size.width * 0.1
                                        : Responsive.isTabletPortrait(context)
                                            ? size.width * 0.15
                                            : size.width * 0.1,
                            child: TextFormField(
                              onChanged: _filterDeshana,
                              controller: searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 14.0),
                                hintText: "Search...",
                                hintStyle: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xFFB3B1B1),
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.black38,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onSaved: (newValue) {
                                searchController.text == newValue;
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                reverse: false,
                                itemCount: filteredDeshana.length,
                                itemBuilder: (context, index) {
                                  bool isCurrentlyPlaying =
                                      index == _currentPlayingIndex;

                                  bool isFavorite = favoriteDeshana.any(
                                      (deshana) =>
                                          deshana['id'] ==
                                          filteredDeshana[index]['id']);
                                  bool isFavorite2 =
                                      favoriteDeshana[index]['isFavorite'];
                                  return Container(
                                    padding: EdgeInsets.only(left: 15),
                                    height: Responsive.isTabletLandscape(
                                            context)
                                        ? 60
                                        : Responsive.isTabletPortrait(context)
                                            ? 70
                                            : 50,
                                    color: Colors.black,
                                    child: Row(children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          filteredDeshana[index]['id']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: Responsive.isMobileSmall(
                                                    context)
                                                ? 15
                                                : Responsive.isMobileMedium(
                                                            context) ||
                                                        Responsive
                                                            .isMobileLarge(
                                                                context)
                                                    ? 16
                                                    : Responsive
                                                            .isTabletLandscape(
                                                                context)
                                                        ? 20
                                                        : 24,
                                            color: Colors.amber,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: IconButton(
                                            icon: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: Responsive.isMobileSmall(
                                                        context)
                                                    ? 18
                                                    : Responsive.isMobileMedium(
                                                                context) ||
                                                            Responsive
                                                                .isMobileLarge(
                                                                    context)
                                                        ? 19
                                                        : Responsive
                                                                .isTabletLandscape(
                                                                    context)
                                                            ? 23
                                                            : 25,
                                                color: Colors.amber),
                                            onPressed: () {
                                              _updateFavoriteStatus(
                                                  index, isFavorite);
                                            }),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AudioPlayerPopup(
                                                  deshanaList: filteredDeshana,
                                                  currentIndex: index,
                                                  realNumber:
                                                      filteredDeshana[index]
                                                          ['id'],
                                                  onCurrentIndexChanged:
                                                      (int newIndex) {
                                                    if (mounted)
                                                      setState(() {
                                                        _currentPlayingIndex =
                                                            newIndex;
                                                      });
                                                  },
                                                  isCurrentlyPlayingFavorite:
                                                      isFavorite2,
                                                  isFavoriteList:
                                                      favoriteDeshana
                                                          .map(
                                                              (deshana) => true)
                                                          .toList(),
                                                  updateFavoriteStatus:
                                                      _updateFavoriteStatusFromPlayer,
                                                  toggleFavoriteStatus:
                                                      (int, bool) {},
                                                  firstTappedDeshsnaUrl:
                                                      filteredDeshana[index]
                                                          ['deshanaplay'],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            filteredDeshana[index]
                                                ['deshananame'],
                                            style: GoogleFonts.notoSerif(
                                              fontSize: Responsive
                                                      .isMobileSmall(context)
                                                  ? 12
                                                  : Responsive.isMobileMedium(
                                                              context) ||
                                                          Responsive
                                                              .isMobileLarge(
                                                                  context)
                                                      ? 12.5
                                                      : Responsive
                                                              .isTabletLandscape(
                                                                  context)
                                                          ? 17
                                                          : 19,
                                              color: Colors.amber,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: Responsive.isMobileSmall(
                                                    context)
                                                ? 16
                                                : Responsive.isMobileMedium(
                                                            context) ||
                                                        Responsive
                                                            .isMobileLarge(
                                                                context)
                                                    ? 17
                                                    : Responsive
                                                            .isTabletLandscape(
                                                                context)
                                                        ? 20
                                                        : 20,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () async {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AudioPlayerPopup(
                                                  deshanaList: filteredDeshana,
                                                  currentIndex: index,
                                                  realNumber:
                                                      filteredDeshana[index]
                                                          ['id'],
                                                  onCurrentIndexChanged:
                                                      (int newIndex) {
                                                    if (mounted)
                                                      setState(() {
                                                        _currentPlayingIndex =
                                                            newIndex;
                                                      });
                                                  },
                                                  isCurrentlyPlayingFavorite:
                                                      isFavorite2,
                                                  isFavoriteList:
                                                      favoriteDeshana
                                                          .map(
                                                              (deshana) => true)
                                                          .toList(),
                                                  updateFavoriteStatus:
                                                      _updateFavoriteStatusFromPlayer,
                                                  toggleFavoriteStatus:
                                                      (int, bool) {},
                                                  firstTappedDeshsnaUrl:
                                                      filteredDeshana[index]
                                                          ['deshanaplay'],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ]),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
