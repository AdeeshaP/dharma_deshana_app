import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dharma_deshana_app/home_screen.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:dharma_deshana_app/side-navigation/contact_us.dart';
import 'package:dharma_deshana_app/side-navigation/deshana.dart';
import 'package:dharma_deshana_app/side-navigation/niwiime_paniwidaya.dart';
import 'package:dharma_deshana_app/side-navigation/favorite_deshana.dart';
import 'package:dharma_deshana_app/side-navigation/settings.dart';

class AramunaScreen extends StatefulWidget {
  const AramunaScreen({super.key});

  @override
  State<AramunaScreen> createState() => _AramunaScreenState();
}

class _AramunaScreenState extends State<AramunaScreen> {
  int selectedIndex = 2;

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
            "අරමුණ",
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                child: Container(
                  padding:
                      EdgeInsets.only(right: 20, left: 20, top: 60, bottom: 20),
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "        නිසල තපෝ වන සෙනසුනක \"සපිරුණු මෙත් සිතින්\" යුතුව විමුක්ති සුවය අත්විඳිමින් වැඩ වසන ඒ උතුම් බුද්ධ පුත්‍රයානන් වහන්සේ "
                    "ඔබෙත් මගෙත් මහත් වූ කුසලයට ම පහළ වූ බව හැඟේ. තථාගත අමා මෑණියන් වහන්සේ වදාළ සදා නිවී සැනසෙන ලොව්තුරු දහම තමා තුළින්ම "
                    "ප්‍රායෝගිකව අත්දැක, අත්විඳ ඒ \"දහම් සාරය\" අපට බෙදා දෙන්නට මෙම නිවුනු උතුමො, තම මුළු දිවියම කැපකරමින් සුවසේ වැඩ වසන "
                    "සේක.\n\nඋන් වහන්සෙ වෙතින් නිරායාසයෙන්ම ගලා එන \"නිවන් දකිමු\" දහම් පණිවිඩය තුලින්, නිමක් නොපෙනෙන සසර ගමන නිමා කොටගෙන පූර්ණ "
                    "නිවීමෙන් සදාකාලික සුවය අත්විඳ ගන්නට \"අප සැමට\"උන්වහන්සේ මෙත් සිතින් ඇරැයුම් කරන සේක. කුසල් බර පින්වතුනි.අවදි වන්න! "
                    "මේ එයට කාලයයි..",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.isMobileSmall(context)
                          ? 12
                          : Responsive.isMobileMedium(context) ||
                                  Responsive.isMobileLarge(context)
                              ? 13
                              : Responsive.isTabletLandscape(context)
                                  ? 18
                                  : 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(12),
          height: Responsive.isMobileSmall(context)
              ? 40
              : Responsive.isMobileMedium(context) ||
                      Responsive.isMobileLarge(context)
                  ? 50
                  : Responsive.isTabletLandscape(context)
                      ? 60
                      : 60.0,
          color: Colors.black,
          child: Text(
            'Powered by Auradot (Pvt) Ltd.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: Responsive.isMobileSmall(context)
                  ? 14.5
                  : Responsive.isMobileMedium(context) ||
                          Responsive.isMobileLarge(context)
                      ? 15
                      : Responsive.isTabletLandscape(context)
                          ? 19
                          : 23,
              color: Colors.amber,
            ),
            textAlign: TextAlign.center,
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
