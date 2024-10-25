import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dharma_deshana_app/home_screen.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:dharma_deshana_app/side-navigation/aramuna_screen.dart';
import 'package:dharma_deshana_app/side-navigation/contact_us.dart';
import 'package:dharma_deshana_app/side-navigation/bottom_sheet.dart';
import 'package:dharma_deshana_app/side-navigation/niwiime_paniwidaya.dart';
import 'package:dharma_deshana_app/side-navigation/favorite_deshana.dart';
import 'package:dharma_deshana_app/side-navigation/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeshanaScreen extends StatefulWidget {
  const DeshanaScreen({super.key});

  @override
  State<DeshanaScreen> createState() => _DeshanaScreenState();
}

class _DeshanaScreenState extends State<DeshanaScreen> {
  int selectedIndex = 1;
  TextEditingController searchController = new TextEditingController();
  bool isPlaying = false;
  Duration duration = Duration();
  Duration position = Duration();
  List<Map<String, dynamic>> deshana = [];
  SharedPreferences? _storage;
  bool deshanalowQuality = false;
  late List<bool> isFavoriteList = [];
  late List<bool> isplayedList = [];
  List<Map<String, dynamic>> filteredDeshana = [];
  List<int> favoriteIndexes = [];
  int _currentPlayingIndex = -1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    _storage = await SharedPreferences.getInstance();

    bool? isLowQuality = _storage!.getBool('law_quality');

    setState(() {
      deshanalowQuality = isLowQuality ?? false;
    });

    print("Are deshana quality low $deshanalowQuality ");

    final String response = deshanalowQuality == true
        ? await rootBundle.loadString('assets/json/deshana_mini.json')
        : await rootBundle.loadString('assets/json/deshana.json');

    final data = await json.decode(response);

    setState(() {
      deshana = List<Map<String, dynamic>>.from(data['data']);
      deshana.sort((a, b) {
        return b['id'].compareTo(a['id']);
      });

      isFavoriteList = List<bool>.filled(deshana.length, false);
      isplayedList = List<bool>.filled(deshana.length, false);
      filteredDeshana = List.from(deshana);
    });

    List<String>? favoriteIds = _storage!.getStringList('favoriteIds');
    print("Fav Ids in deshana screen $favoriteIds");

    if (favoriteIds != null) {
      for (int i = 0; i < deshana.length; i++) {
        if (favoriteIds.contains(deshana[i]['id'].toString())) {
          isFavoriteList[i] = true;
        }
      }
    }

    print("Deshana length  ${deshana.length}");
  }

  Future<void> _toggleFavoriteStatus(
      int index, bool currentFavoriteStatus) async {
    setState(() {
      isFavoriteList[index] = !currentFavoriteStatus;
    });

    List<Map<String, dynamic>> favorites = [];

    for (int i = 0; i < deshana.length; i++) {
      if (isFavoriteList[i]) {
        favorites.add(deshana[i]);
      }
    }

    String favoritesJson = jsonEncode({"favorites": favorites});
    await _storage!.setString('favorites', favoritesJson);

    List<String> favoriteIds = [];
    for (int i = 0; i < deshana.length; i++) {
      if (isFavoriteList[i]) {
        favoriteIds.add(deshana[i]['id'].toString());
      }
    }
    await _storage!.setStringList('favoriteIds', favoriteIds);
  }

  Future<void> _togglePreviouslyPlayedStatus(int index) async {
    setState(() {
      isplayedList[index] = !isplayedList[index];
    });

    List<Map<String, dynamic>> playedMp3s = [];
    for (int i = 0; i < deshana.length; i++) {
      if (isplayedList[i]) {
        playedMp3s.add(deshana[i]);
      }
    }

    String playedJson = jsonEncode({"played": playedMp3s});
    await _storage!.setString('played', playedJson);
  }

  void _updateFavoriteStatus(int index, bool isFavorite) {
    setState(() {
      isFavoriteList[index] = isFavorite;
    });
  }

  void updateCurrentlyPlayingIndex(int index) {
    setState(() {
      _currentPlayingIndex = index;
    });
  }

  void _filterDeshana(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDeshana = List.from(deshana);
      } else {
        filteredDeshana = deshana.where((item) {
          // Customize this condition based on your search criteria
          String deshananame = item['deshananame'].toString();
          return deshananame.contains(query);
        }).toList();
      }
    });
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
            "දේශනා",
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
                                  bool isFavorite = isFavoriteList[index];

                                  bool isPlayedBefore = isplayedList[index];

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
                                                : Icons.favorite_outline,
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
                                            color: isFavorite
                                                ? Colors.amber
                                                // : isPlayedBefore ||
                                                //         isCurrentlyPlaying
                                                //     ? Colors.amber
                                                : !isFavorite || !isPlayedBefore
                                                    ? Colors.grey
                                                    : null,
                                          ),
                                          onPressed: () =>
                                              _toggleFavoriteStatus(
                                                  index, isFavorite),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: GestureDetector(
                                          onTap: () {
                                            _togglePreviouslyPlayedStatus(
                                                index);
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
                                                      isFavoriteList[index],
                                                  isFavoriteList:
                                                      isFavoriteList,
                                                  updateFavoriteStatus:
                                                      _updateFavoriteStatus,
                                                  toggleFavoriteStatus:
                                                      (int index,
                                                          bool isFavorite2) {
                                                    _toggleFavoriteStatus(
                                                        index, isFavorite2);
                                                  },
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
                                              // color: isFavorite ||
                                              //         isPlayedBefore ||
                                              //         isCurrentlyPlaying
                                              //     ? Colors.amber
                                              //     : Colors.white,
                                              color: isFavorite
                                                  ? Colors.amber
                                                  : Colors.white,
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
                                            color: isFavorite
                                                ? Colors.amber
                                                : Colors.grey,
                                          ),
                                          onPressed: () async {
                                            _togglePreviouslyPlayedStatus(
                                                index);
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
                                                      isFavoriteList[index],
                                                  isFavoriteList:
                                                      isFavoriteList,
                                                  updateFavoriteStatus:
                                                      _updateFavoriteStatus,
                                                  toggleFavoriteStatus:
                                                      (int index,
                                                          bool isFavorite2) {
                                                    _toggleFavoriteStatus(
                                                        index, isFavorite2);
                                                  },
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
