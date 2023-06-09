import 'package:flutter/material.dart';

class AppCustomAppBar extends AppBar {
  AppCustomAppBar({Key? key, double elevation = 2})
      : super(
          key: key,
          backgroundColor: Colors.white,
          elevation: elevation,
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        );
}
