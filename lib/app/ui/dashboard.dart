import 'package:covid19_gm_app/app/repositories/data_repository.dart';
import 'package:covid19_gm_app/app/repositories/endpoints_data.dart';
import 'package:covid19_gm_app/app/services/api.dart';
import 'package:covid19_gm_app/app/ui/endpoint_card.dart';
import 'package:covid19_gm_app/app/ui/last_updated_status_text.dart';
import 'package:covid19_gm_app/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
// define a state variable to update the state
  EndpointsData _endpointsData;

//overide the initState method
  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    // get cached version of the data before calling a new data from the API
    _endpointsData = dataRepository.getAllEndpointsCachedData();   
    // calls data from API
    _updateData();
  }

// method to load case data from api
  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = endpointsData);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content:
            'Could not retrieve data. Please make sure you\'re connected to the internet and try again.',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Server Error',
        content: 'Please try again later.',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
      lastUpdated: _endpointsData != null
          ? _endpointsData.values[Endpoint.cases]?.date
          : null,
    );
    return Scaffold(
      appBar: AppBar(
        // center AppBar title
        centerTitle: true,
        title: Text('COVID-19 Gambia'),
      ),
      // listView is the right widget for scrollable cards
      // RefreshIndicator is great for calling REST APIs to refresh data
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: <Widget>[
            LastUpdatedStatusText(
              text: formatter.lastUpdatedSatusText(),
            ),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                // pass the number of cases to
                // endpoint card
                // prevent getting a red error screen with the null
                value: _endpointsData != null
                    ? _endpointsData.values[endpoint]?.value
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
