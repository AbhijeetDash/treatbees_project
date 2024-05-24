import 'package:flutter/material.dart';
import 'package:treatbees/layout/web.dart';
import 'package:treatbees/pages/privacy.dart';

class AboutUS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        padding: EdgeInsets.all(100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeadingText(heading: 'About Us'),
                  SizedBox(
                    height: 10,
                  ),
                  BodyText(
                    bodyText:
                        "-- In the era of online food ordering, we at Treatbees want to bring the fun and social interaction of the dining back to you. We think food ordering should not be limited to hunger when it could be a complete experience in itself and that's where TreatBees provides you one place for everything; order food, gain loyalties, share gifts, and those moments with your friends and family.",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: RawMaterialButton(
                    fillColor: Colors.orange,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
