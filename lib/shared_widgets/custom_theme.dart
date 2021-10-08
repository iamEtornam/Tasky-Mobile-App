import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';

/// light theme
ThemeData customLightTheme(
  BuildContext context,
) {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: customGreyColor),
      errorColor: const Color.fromRGBO(229, 62, 62, 1),
      platform: defaultTargetPlatform,
      highlightColor: customRedColor.withOpacity(.5),
      primaryColor: Colors.white,
      indicatorColor: customRedColor,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: customRedColor),
      unselectedWidgetColor: Colors.grey,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: const Color.fromRGBO(250, 250, 250, 1),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        alignLabelWithHint: true,
        hintStyle: Theme.of(context).textTheme.bodyText1,
        contentPadding: const EdgeInsets.all(15.0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: .5),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: .5),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE5E5E5)),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        errorBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: const Color(0xffB00020).withOpacity(.5)),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffB00020)),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        labelStyle: Theme.of(context).textTheme.bodyText2,
        errorStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: const Color.fromRGBO(229, 62, 62, 1)),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black.withOpacity(.5),
      ),
      textTheme: Typography.material2018(platform: defaultTargetPlatform)
          .white
          .copyWith(
            bodyText1: const TextStyle(color: Colors.black, fontSize: 16),
            bodyText2: const TextStyle(color: Colors.black, fontSize: 14),
            caption: const TextStyle(color: Colors.black, fontSize: 12),
            headline1: const TextStyle(color: Colors.black, fontSize: 96),
            headline2: const TextStyle(color: Colors.black, fontSize: 60),
            headline3: const TextStyle(color: Colors.black, fontSize: 48),
            headline4: const TextStyle(color: Colors.black, fontSize: 34),
            headline5: const TextStyle(color: Colors.black, fontSize: 24),
            headline6: const TextStyle(color: Colors.black, fontSize: 20),
            subtitle1: const TextStyle(color: Colors.black, fontSize: 16),
            subtitle2: const TextStyle(color: Colors.black, fontSize: 14),
            overline: const TextStyle(color: Colors.black, fontSize: 10),
            button: const TextStyle(color: Colors.black, fontSize: 16),
          ),
      dividerTheme:
          const DividerThemeData(color: Color(0xffEDF2F7), thickness: 1),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      colorScheme: const ColorScheme.light(secondary: customRedColor));
}

///dark theme
ThemeData customDarkTheme(
  BuildContext context,
) {
  return ThemeData(
      scaffoldBackgroundColor: const Color(0xff121212),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: customGreyColor),
      errorColor: const Color(0xffCF6679),
      primaryColor: Colors.black,
      indicatorColor: customRedColor,
      highlightColor: customRedColor.withOpacity(.5),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: customRedColor),
      platform: defaultTargetPlatform,
      unselectedWidgetColor: Colors.grey,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: const Color.fromRGBO(31, 31, 31, 1),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.white.withOpacity(.7),
      ),
      textTheme: Typography.material2018(platform: defaultTargetPlatform)
          .white
          .copyWith(
            bodyText1: const TextStyle(color: Colors.white, fontSize: 16),
            bodyText2: const TextStyle(color: Colors.white, fontSize: 14),
            caption: const TextStyle(color: Colors.white, fontSize: 12),
            headline1: const TextStyle(color: Colors.white, fontSize: 96),
            headline2: const TextStyle(color: Colors.white, fontSize: 60),
            headline3: const TextStyle(color: Colors.white, fontSize: 48),
            headline4: const TextStyle(color: Colors.white, fontSize: 34),
            headline5: const TextStyle(color: Colors.white, fontSize: 24),
            headline6: const TextStyle(color: Colors.white, fontSize: 20),
            subtitle1: const TextStyle(color: Colors.white, fontSize: 16),
            subtitle2: const TextStyle(color: Colors.white, fontSize: 14),
            overline: const TextStyle(color: Colors.white, fontSize: 10),
            button: const TextStyle(color: Colors.white, fontSize: 16),
          ),
      iconTheme: const IconThemeData(color: Colors.white),
      dividerTheme: const DividerThemeData(
          color: Color.fromRGBO(113, 128, 150, 1), thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color.fromRGBO(31, 31, 31, 1),
        filled: true,
        alignLabelWithHint: true,
        hintStyle: Theme.of(context).textTheme.bodyText1,
        contentPadding: const EdgeInsets.all(15.0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: .5),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: .5),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffE5E5E5)),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        errorBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: const Color(0xffCF6679).withOpacity(.5)),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffCF6679)),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        labelStyle:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
        errorStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: const Color(0xffCF6679)),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        color: Color(0xff121212),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      colorScheme: const ColorScheme.dark(secondary: customRedColor));
}
