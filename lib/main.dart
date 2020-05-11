import 'package:covid19_gm_app/app/repositories/data_repository.dart';
import 'package:covid19_gm_app/app/services/api.dart';
import 'package:covid19_gm_app/app/services/api_service.dart';
import 'package:covid19_gm_app/app/services/data_cache_service.dart';
import 'package:covid19_gm_app/app/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// maint method body
void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  // change locale from default en_US to GB
Intl.defaultLocale = 'en_GB';
await initializeDateFormatting();
final sharedPreferences =  await SharedPreferences.getInstance();
 runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
const MyApp({Key key, @required this.sharedPreferences}) : super(key: key);  
final SharedPreferences sharedPreferences;

  


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
        apiService: APIService(API.sandbox()),
        dataCacheService: DataCacheService(sharedPreferences: sharedPreferences,),
      ), 
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: 'COVID-19 Gambia',
        theme: ThemeData.dark().copyWith(
           scaffoldBackgroundColor: Color(0xFF101010),
           cardColor: Color(0xFF222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}

