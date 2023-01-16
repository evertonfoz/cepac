import 'package:flutter/services.dart';
import 'package:status_bar_control/status_bar_control.dart';

mainInitializationApp() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  await StatusBarControl.setHidden(
    true,
    animation: StatusBarAnimation.SLIDE,
  );

// Comentar para DevicePreview
  // await hideStatusBarAndSetColorToNavigationBar(
  //     navigationBarColor: Colors.white, fullScreen: false);
}
