import 'package:flutter/material.dart';
import 'package:dharma_deshana_app/responsive/responsive.dart';

showProgressDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(
          width: Responsive.isMobileSmall(context) ||
                  Responsive.isMobileMedium(context) ||
                  Responsive.isMobileLarge(context)
              ? 1
              : 10,
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Text(
            "රැදී සිටින්න",
            style: TextStyle(
              fontSize: Responsive.isMobileSmall(context) ||
                      Responsive.isMobileMedium(context) ||
                      Responsive.isMobileLarge(context)
                  ? 15
                  : Responsive.isTabletPortrait(context)
                      ? 24
                      : 20,
            ),
          ),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

closeDialog(context) {
  Navigator.of(context, rootNavigator: true).pop('dialog');
}
