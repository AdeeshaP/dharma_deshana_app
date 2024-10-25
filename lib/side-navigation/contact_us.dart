import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dharma_deshana_app/home_screen.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:dharma_deshana_app/side-navigation/aramuna_screen.dart';
import 'package:dharma_deshana_app/side-navigation/deshana.dart';
import 'package:dharma_deshana_app/side-navigation/niwiime_paniwidaya.dart';
import 'package:dharma_deshana_app/side-navigation/favorite_deshana.dart';
import 'package:dharma_deshana_app/side-navigation/settings.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  int selectedIndex = 5;
  String url =
      "https://docs.google.com/forms/d/e/1FAIpQLSeQpAiS2OvgwcQ5Dg3PmakcIjF53wKvc9O3prWsp9ttUunsAA/viewform";
  double progress = 0.0;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    verticalScrollBarEnabled: true,
    disableVerticalScroll: false,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
    isPagingEnabled: true,
    alwaysBounceVertical: true,
    defaultFontSize: 14,
    defaultFixedFontSize: 14,
    minimumFontSize: 12,
  );

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
            "සම්බන්ධ වන්න",
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: Responsive.isMobileSmall(context)
                        ? size.width * 0.9
                        : Responsive.isMobileMedium(context) ||
                                Responsive.isMobileLarge(context)
                            ? size.width * 0.9
                            : Responsive.isTabletLandscape(context)
                                ? size.width * 0.95
                                : size.width * 0.95,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "අප හා සම්බන්ධ වීමට",
                          style: TextStyle(
                              color: Colors.amber[500],
                              fontSize: Responsive.isMobileSmall(context)
                                  ? 16
                                  : Responsive.isMobileMedium(context) ||
                                          Responsive.isMobileLarge(context)
                                      ? 17
                                      : Responsive.isTabletLandscape(context)
                                          ? 20
                                          : 21,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "උන්වහන්සේ වැඩ වෙසෙනා තැන නොසොයන්න. "
                          "මුලින් තමන් ඉන්නා තැන සොයා ගන්න."
                          "නිවනට මග වඩන්න. උන්වහන්සේ ඔබට මුණ ගැසේවි!!! "
                          "අප හැමෝටම නිවන් යා හැක. එය විශ්වාස කරන්න!!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.isMobileSmall(context)
                                ? 12
                                : Responsive.isMobileMedium(context) ||
                                        Responsive.isMobileLarge(context)
                                    ? 13
                                    : Responsive.isTabletLandscape(context)
                                        ? 16
                                        : 18,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Container(
                    // height: size.height * 0,
                    padding: EdgeInsets.all(20),
                    width: Responsive.isMobileSmall(context)
                        ? size.width * 0.9
                        : Responsive.isMobileMedium(context) ||
                                Responsive.isMobileLarge(context)
                            ? size.width * 0.9
                            : Responsive.isTabletLandscape(context)
                                ? size.width * 0.95
                                : size.width * 0.95,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "අන්තර්ජාල පහසුකම් නැති ඔබ වෙනුවෙන් නිවන් දකිමු දේශනා අඩංගු DVD තැටි හෝ pendrives ඔබේ නිවසටම තැපැල් මගින් ගෙන්වා"
                          "ගැනීමට පහත ෆෝරමය පුරවා එවන්න.",
                          style: TextStyle(
                              color: Colors.amber[500],
                              height: 1.5,
                              fontSize: Responsive.isMobileSmall(context)
                                  ? 12
                                  : Responsive.isMobileMedium(context) ||
                                          Responsive.isMobileLarge(context)
                                      ? 13
                                      : Responsive.isTabletLandscape(context)
                                          ? 16
                                          : 18,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: Responsive.isMobileSmall(context)
                              ? size.height * 3.5
                              : Responsive.isMobileMedium(context) ||
                                      Responsive.isMobileLarge(context)
                                  ? size.height * 3
                                  : Responsive.isTabletLandscape(context)
                                      ? size.height * 2
                                      : size.height * 1.5,
                          child: InAppWebView(
                            key: webViewKey,
                            initialUrlRequest: URLRequest(url: WebUri(url)),
                            initialSettings: settings,
                            onWebViewCreated: (controller) {
                              webViewController = controller;
                            },
                          ),
                        )
                        // Container(
                        //   height: size.height * 0.9,
                        //   child: InAppWebView(
                        //     webViewZoomEnabled: false,
                        //     url,
                        //     appBarBGColor: Colors.black.withOpacity(0.9),
                        //     bottomNavColor: Colors.black,
                        //     defaultTitle: false,
                        //     backIcon: const Icon(Icons.arrow_back_ios,
                        //         color: Colors.transparent),
                        //     nextIcon: const Icon(Icons.arrow_forward_ios,
                        //         color: Colors.transparent),
                        //     closeIcon: const Icon(Icons.close,
                        //         color: Colors.transparent),
                        //     shareIcon: const Icon(Icons.share,
                        //         color: Colors.transparent),
                        //     refreshIcon: const Icon(Icons.refresh,
                        //         color: Colors.transparent),
                        //     actionWidget: const [],
                        //     actionsIconTheme: const IconThemeData(),
                        //     centerTitle: false,
                        //     titleTextStyle:
                        //         const TextStyle(color: Colors.transparent),
                        //     toolbarTextStyle: const TextStyle(),
                        //     toolbarHeight: 2,
                        //     btmSheetSize: 5,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
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
