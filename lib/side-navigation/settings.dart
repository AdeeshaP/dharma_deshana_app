import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dharma_deshana_app/home_screen.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:dharma_deshana_app/side-navigation/aramuna_screen.dart';
import 'package:dharma_deshana_app/side-navigation/contact_us.dart';
import 'package:dharma_deshana_app/side-navigation/deshana.dart';
import 'package:dharma_deshana_app/side-navigation/niwiime_paniwidaya.dart';
import 'package:dharma_deshana_app/side-navigation/favorite_deshana.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SakasumScreen extends StatefulWidget {
  const SakasumScreen({super.key});

  @override
  State<SakasumScreen> createState() => _SakasumScreenState();
}

class _SakasumScreenState extends State<SakasumScreen> {
  int selectedIndex = 6;
  late SharedPreferences _storage;
  bool _lowQuality = false;
  bool _onChangedLowQuality = false;

  @override
  initState() {
    super.initState();
    getSharedpref();
  }

  // final MaterialStateProperty<Icon?> thumbIcon =
  //     MaterialStateProperty.resolveWith<Icon?>(
  //   (Set<MaterialState> states) {
  //     if (states.contains(MaterialState.selected)) {
  //       return const Icon(Icons.check);
  //     }
  //     return const Icon(Icons.close);
  //   },
  // );

  getSharedpref() async {
    _storage = await SharedPreferences.getInstance();
    print(_storage.getBool("law_quality"));

    bool? deshanaLowQuality = _storage.getBool('law_quality');
    setState(() {
      _lowQuality = deshanaLowQuality ?? false;
    });
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
            "සැකසුම්",
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
          padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
          width: size.width,
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                width: size.width * 0.9,
                child: Text(
                  "සියලු දේශනාවන්ගේ ශ්‍රවණ තත්වය උසස් අයුරින් තබා ගැනීම සඳහා මෙහි ඇති සියළු දේශනා වල දත්ත ප්‍රමාණය (size of the mp3 file) වැඩි කොට ඇත. මේ හේතුව නිසා දේශනා සවන් දීමට මද වෙලාවක් ගත වෙන බව කරුණාවෙන් මතක් කර සිටිමු."
                  " කෙසේ වුවත් ඔබගේ පහසුව උදෙසා දේශනා වල දත්ත ප්‍රමාණය අඩු කිරීම සඳහා, අඩු ශ්‍රවණ තත්ව යටතේ දේශනා සියල්ල ශ්‍රවණය කිරීමට ඉහත බොත්තම LOW ලෙස සකස් කර ගන්න. මේ මගින් දේශනා ඉක්මනින් භාගත වන අතර, දේශනා වල දත්ත ප්‍රමාණය ඉතා අඩු ( less size of the mp3 file) මට්ටමක පවතී.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Responsive.isMobileSmall(context)
                        ? 12.5
                        : Responsive.isMobileMedium(context) ||
                                Responsive.isMobileLarge(context)
                            ? 13
                            : Responsive.isTabletLandscape(context)
                                ? 19
                                : 22,
                    height: 1.8,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                width: size.width * 0.9,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        "MP3 Quality",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Responsive.isMobileSmall(context)
                              ? 16
                              : Responsive.isMobileMedium(context) ||
                                      Responsive.isMobileLarge(context)
                                  ? 18
                                  : Responsive.isTabletLandscape(context)
                                      ? 23
                                      : 25,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Low",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Responsive.isMobileSmall(context)
                                  ? 16
                                  : Responsive.isMobileMedium(context) ||
                                          Responsive.isMobileLarge(context)
                                      ? 18
                                      : Responsive.isTabletLandscape(context)
                                          ? 23
                                          : 25,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(width: 10),
                          Switch(
                            value: _lowQuality,
                            activeColor: Colors.white38,
                            inactiveThumbColor: Colors.grey,
                            activeTrackColor: Colors.amber,
                            inactiveTrackColor: Colors.white,
                            onChanged: (bool newValue) {
                              setState(() {
                                _lowQuality = newValue;
                                _onChangedLowQuality = true;
                              });

                              print("law_quality Status is " +
                                  _lowQuality.toString());
                              _storage.setBool('law_quality', _lowQuality);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        'Settings',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          newValue.toString() == "true"
                                              ? 'Low quality mp3 deshana selected successfully.'
                                              : 'Better quality mp3 deshana selected successfully.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: Responsive
                                                        .isMobileSmall(context)
                                                    ? 17
                                                    : Responsive
                                                                .isMobileMedium(
                                                                    context) ||
                                                            Responsive
                                                                .isMobileLarge(
                                                                    context)
                                                        ? 18
                                                        : Responsive
                                                                .isTabletLandscape(
                                                                    context)
                                                            ? 20
                                                            : 21.0,
                                                color: Colors.black,
                                              ),
                                            )),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: Responsive
                                                        .isMobileSmall(context)
                                                    ? 17
                                                    : Responsive
                                                                .isMobileMedium(
                                                                    context) ||
                                                            Responsive
                                                                .isMobileLarge(
                                                                    context)
                                                        ? 18
                                                        : Responsive
                                                                .isTabletLandscape(
                                                                    context)
                                                            ? 20
                                                            : 21.0,
                                                color: Colors.amber),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
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
