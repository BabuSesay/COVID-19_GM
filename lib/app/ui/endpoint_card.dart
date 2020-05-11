import 'package:covid19_gm_app/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// this class represents the title, color, and asset names
// used to represent appearance of each card
class EndpointCardData {
  EndpointCardData(this.title, this.assetName, this.color);
  final String title;
  final String assetName;
  final Color color;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);
  final Endpoint endpoint;
  final int value;

// map with values of objects - EnpointCardDataObject
// of type EnndpointCardData
// and variable _cardsData
// to display the contents of the EndpointCardData/assets class
  static Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases:
        EndpointCardData('Cases', 'assets/count.png', Color(0xFFFFF492)),
    // Endpoint.casesSuspected: EndpointCardData(
    //  'Suspected cases', 'assets/suspect.png', Color(0xFFEEDA28)),
    Endpoint.casesConfirmed: EndpointCardData(
        'Confirmed cases', 'assets/fever.png', Color(0xFFE99600)),
    Endpoint.deaths:
        EndpointCardData('Deaths', 'assets/death.png', Color(0xFFE40000)),
    Endpoint.recovered:
        EndpointCardData('Recovered', 'assets/patient.png', Color(0xFF70A901)),
  };
// leverage=ing Intl to format our digits with commas
  String get formattedValue {
    if (value == null) {
      return '';
    }
    // insert a comma after every 3 digits
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
    // rounded corner rectangular card widget
    // padding inside and outside the card
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          // aligns the text to the left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              cardData.title,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: cardData.color),
            ),
            SizedBox(height: 4),
            SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // adds the images/icons/assets
                  Image.asset(cardData.assetName, color: cardData.color),
                  Text(
                    formattedValue,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: cardData.color,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
