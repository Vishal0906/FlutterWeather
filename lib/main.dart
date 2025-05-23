import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/weatherProvider.dart';
import 'screens/homeScreen.dart';
import 'screens/sevenDayForecastDetailScreen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: 'Flutter Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.blue),
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        ),
        home: HomeScreen(),
        
        onGenerateRoute: (settings) {
          final args = settings.arguments;
          if (settings.name == SevenDayForecastDetail.routeName) {
            final initialIndex = (args is int) ? args : 0;
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => SevenDayForecastDetail(
                initialIndex: initialIndex,
              ),
              transitionsBuilder: (ctx, animation, secondaryAnimation, child) =>
                  CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                linearTransition: false,
                child: child,
              ),
            );
          }
          return MaterialPageRoute(builder: (_) => HomeScreen());
        },
      ),
    );
  }
}
