import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/tasky_logo.png',
              width: 120,
              height: 120,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              'Tasky',
              style: Theme.of(context).textTheme.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.fugazOne().fontFamily),
            )),
            Spacer(),
            Text(
              'Login or Create a new account',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.grey),
            ),
            SizedBox(
              height: 15,
            ),
            FlatButton(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/ic_google.svg',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Continue with Google',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/organizationView'),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey, width: .5),
                  borderRadius: BorderRadius.circular(45)),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/ic_apple.svg',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Signin with Apple',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/organizationView'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45)),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
