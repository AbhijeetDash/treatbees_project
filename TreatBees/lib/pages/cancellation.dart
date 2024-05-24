import 'package:TreatBees/pages/privacy.dart';
import 'package:flutter/material.dart';


class CancellationPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        padding: EdgeInsets.all(30.0),
        child: Container(
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(heading: 'Cancellation Policies'),
                BodyText(
                  bodyText:
                  '1. You must notify Treatbees.com before the order goes into preparing stage after placing the order if you decide to cancel your order by Treatbees App only.'
                ),

                BodyText(
                  bodyText:
                  '2. Treatbees or the restaurant may not accept an order if the product is not available for any reason.'
                ),

                BodyText(
                  bodyText:
                  '3. We will notify you in above case and return any payment that you have made.'
                ),

                BodyText(
                  bodyText:
                  '4. If the cancellation was made in time and once the restaurant has accepted your cancellation, we will refund or re-credit your debit or credit card with the full amount.'
                ),

                BodyText(
                  bodyText:
                  '5. Refunds may take up to 2 weeks, depending upon the mode of payment collection.'
                ),
                Container(
                  child: RawMaterialButton(
                    fillColor: Colors.orange,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
