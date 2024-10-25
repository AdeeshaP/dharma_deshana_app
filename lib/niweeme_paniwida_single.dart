import 'package:dharma_deshana_app/responsive/responsive.dart';
import 'package:dharma_deshana_app/side-navigation/niwiime_paniwidaya.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class NiweemePaniwidyaSingle extends StatefulWidget {
  const NiweemePaniwidyaSingle({
    super.key,
    required this.data,
    required this.currentIndex,
  });
  final List<Map<String, dynamic>> data;
  final int currentIndex;

  @override
  State<NiweemePaniwidyaSingle> createState() => _NiweemePaniwidyaSingleState();
}

class _NiweemePaniwidyaSingleState extends State<NiweemePaniwidyaSingle> {
  String htmlcontent = "";
  late int currentIndex;
  late List<Map<String, dynamic>> data;
  // bool isLoading = false;
  bool isLoading2 = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    data = widget.data;
    fetchContent();
  }

  Future<void> fetchContent() async {
    try {
      var response = await http.get(Uri.parse(data[currentIndex]['txt']));

      if (response.statusCode == 200) {
        print(response.body);

        setState(() {
          htmlcontent = response.body;
          isLoading2 = false;
        });
      } else {
        throw Exception('Failed to load content');
      }
    } catch (error) {
      print('Error fetching content: $error');
      setState(() {
        isLoading2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NiwimePaniwidayaScreen(),
          ),
          ((Route<dynamic> route) => false),
        );
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Color.fromARGB(255, 6, 115, 204), size: 25),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey[300],
                height: 1.0,
              ),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: goToNext2,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.amber,
                  )),
              IconButton(
                  onPressed: goToPrevious2,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.amber,
                  )),
              IconButton(
                  onPressed: () => {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => NiwimePaniwidayaScreen(),
                          ),
                          ((Route<dynamic> route) => false),
                        ),
                      },
                  icon: Icon(
                    Icons.close,
                    color: Colors.amber,
                  )),
            ],
            title: Text(
              "නිවීමේ පණිවිඩය",
              style: TextStyle(
                color: Color.fromARGB(255, 239, 183, 16),
                fontSize: Responsive.isMobileSmall(context)
                    ? 12.5
                    : Responsive.isMobileMedium(context) ||
                            Responsive.isMobileLarge(context)
                        ? 14
                        : Responsive.isTabletLandscape(context)
                            ? 16
                            : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: isLoading2
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        'රැඳී සිටින්න..',
                        style: GoogleFonts.notoSerif(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Html(
                        data: '''
                <html>
                    <head>
            <meta charset="UTF-8">
                    </head>
                    <body>
                    <div style="text-align:center">
                      ${htmlcontent}
                    </div>
            
                </body>
                      </html>
                    ''',
                      ),
                    ),
                  ),
                )),
    );
  }

  void goToPrevious2() {
    if (widget.currentIndex >= 0) {
      showDialog(
        context: context,
        barrierDismissible: false, // prevent user from closing the dialog
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.all(
                  Responsive.isMobileSmall(context) ? 13 : 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'රැඳී සිටින්න..',
                    style: GoogleFonts.notoSerif(
                      fontSize: Responsive.isMobileSmall(context)
                          ? 14.5
                          : Responsive.isMobileMedium(context)
                              ? 15.5
                              : Responsive.isMobileLarge(context)
                                  ? 16
                                  : Responsive.isTabletPortrait(context)
                                      ? 18
                                      : 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      setState(() {
        // currentIndex--;
        currentIndex = (currentIndex - 1) % data.length;
      });

      fetchContent().whenComplete(() {
        Navigator.pop(context); // Close the loading dialog
      });
    }
  }

  void goToNext2() {
    if (widget.currentIndex <= widget.data.length - 1) {
      showDialog(
        context: context,
        barrierDismissible: false, // prevent user from closing the dialog
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.all(
                  Responsive.isMobileSmall(context) ? 13 : 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'රැඳී සිටින්න..',
                    style: GoogleFonts.notoSerif(
                      fontSize: Responsive.isMobileSmall(context)
                          ? 14.5
                          : Responsive.isMobileMedium(context)
                              ? 15.5
                              : Responsive.isMobileLarge(context)
                                  ? 16
                                  : Responsive.isTabletPortrait(context)
                                      ? 18
                                      : 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      setState(() {
        // currentIndex++;
        currentIndex = (currentIndex + 1) % data.length;
      });

      fetchContent().whenComplete(() {
        Navigator.pop(context); // Close the loading dialog
      });
    }
  }
}
