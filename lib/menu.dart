import 'dart:async';
import 'dart:io';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable, camel_case_types
class favoritButton extends StatefulWidget {
  favoritButton({Key key, this.controllerCompleter}) : super(key: key);
  Completer<WebViewController> controllerCompleter;

  @override
  _favoritButton createState() => _favoritButton();
}

// ignore: camel_case_types
class _favoritButton extends State<favoritButton> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  navigate(BuildContext context, WebViewController controller,
      String url) async {
    controller.loadUrl(url);
  }

  navigateBackword(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
    goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    }
  }


  _customLaunch(data) async {
    if (await canLaunch(data)) {
      await launch(data);
    } else {
      throw ("Sorry, could not launch $data");
    }
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}";
      }
    }

    _customLaunch(url());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
        future: widget.controllerCompleter.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> snapshot) {

          final WebViewController controller = snapshot.data;
          if (snapshot.hasData) {
            return Builder(
              builder: (context) =>
                  FabCircularMenu(
                    key: fabKey,
                    alignment: Alignment.bottomRight,
                    ringColor: Color(0x99FFA28E),
                    ringDiameter: 500.0,
                    ringWidth: 150.0,
                    fabSize: 64.0,
                    fabElevation: 8.0,
                    fabIconBorder: CircleBorder(),
                    fabColor: Color(0xffFFA28E),
                    fabOpenIcon: Icon(Icons.menu, color: Colors.white),
                    fabCloseIcon: Icon(Icons.close, color: Colors.white),
                    fabMargin: const EdgeInsets.all(16.0),
                    animationDuration: const Duration(milliseconds: 800),
                    animationCurve: Curves.easeInOutCirc,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () =>
                            navigate(
                                context, controller, 'https://km-stores.com/'),
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.home, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () =>
                            navigateBackword(context, controller, goBack: true),
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.backward, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () =>
                            navigate(context, controller,
                                'https://km-stores.com/category?search='),
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(Icons.category, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          launchWhatsApp(
                              phone: '+96176000952', message: "Hello Km Stores");
                        },

                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(
                            FontAwesomeIcons.whatsapp, color: Colors.white),
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          const url = 'https://m.me/KM-Stores-545876745589631';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(24.0),
                        child: FaIcon(FontAwesomeIcons.facebookMessenger,
                            color: Colors.white),
                      )
                    ],
                  ),
            );
          }
          return Container();
        });
  }
}