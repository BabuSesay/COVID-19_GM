import 'package:covid19_gm_app/app/services/api.dart';
import 'package:covid19_gm_app/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';

class EndpointsData {
  EndpointsData({@required this.values});
  final Map<Endpoint, EndpointData> values;
  // getter values that makes EndpointsData easier to query
  EndpointData get cases => values[Endpoint.cases];
  //int  get casesSuspected => values[Endpoint.casesSuspected];
  EndpointData get casesConfirmed => values[Endpoint.casesConfirmed];
  EndpointData get deaths => values[Endpoint.deaths];
  EndpointData get recovered => values[Endpoint.recovered];

  //also, optionally add toString() method, used to print debugging info
  @override
  String toString() =>
      'cases: $cases, confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
}

// suspected: $casesSuspected,