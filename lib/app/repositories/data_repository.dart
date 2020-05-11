import 'package:covid19_gm_app/app/repositories/endpoints_data.dart';
import 'package:covid19_gm_app/app/services/api.dart';
import 'package:covid19_gm_app/app/services/api_service.dart';
import 'package:covid19_gm_app/app/services/data_cache_service.dart';
import 'package:covid19_gm_app/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({@required this.apiService, @required this.dataCacheService});
  final APIService apiService;
  final DataCacheService dataCacheService;

  String _accessToken;

  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
        onGetData: () => apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint),
      );

// retrieve persistet data when app is restarted in offline mode
      EndpointsData getAllEndpointsCachedData() => dataCacheService.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: _getAllEndpointsData,
    );

    // save returned data to cache
    await dataCacheService.setData(endpointsData);
    return endpointsData;
  }

//
  Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      // if unauthorized/401 error, get access token again
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

// re-using and modifying this method to refresh
// access token and get API and allEndpoint data
  // get all enpoint data with a single Future method concurrently
  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.cases),
      //  apiService.getEndpointData(
      //    accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);
    return EndpointsData(values: {
      Endpoint.cases: values[0],
      //Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[1],
      Endpoint.deaths: values[2],
      Endpoint.recovered: values[3],
    });
  }
}
