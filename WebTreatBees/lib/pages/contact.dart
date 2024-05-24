import 'package:flutter/material.dart';
import 'package:treatbees/pages/privacy.dart';

class ContactUS extends StatelessWidget {
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
                  HeadingText(heading: 'Contact Us'),
                  SizedBox(
                    height: 10,
                  ),
                  BodyText(
                      bodyText:
                          " We at TreatBees are dedicated to resolve your queries. For any question, complaints or feature request \n Drop a mail at : supportTeam@treatbees.com"),
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
