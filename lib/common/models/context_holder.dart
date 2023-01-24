import 'package:flutter/material.dart';

class ContextHolder {
  //root app NavigatorKey.
  //set this key to your root app's navigatorKey.
  // set up this navigatioin key in the material app navigator key for accessing the navigation service.
  static final key = GlobalKey<NavigatorState>();

  // get current context.
  static BuildContext get currentContext {
    return key.currentContext!;
  }

  //get current widget.
  static Widget get currentWidget {
    return key.currentWidget!;
  }

  //get current overlay
  static OverlayState get currentOverlay {
    return key.currentState!.overlay!;
  }
}
