import 'package:flutter/material.dart';
import 'package:flutter_weather/theme/textStyle.dart';
import 'package:flutter_weather/widgets/customShimmer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter_weather/provider/weatherProvider.dart';
import 'package:flutter_weather/theme/colors.dart';
import 'package:flutter_weather/helper/extensions.dart'; 


class MainWeatherDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
      if (weatherProv.isLoading) {
        return CustomShimmer(
          height: 132.0,
          borderRadius: BorderRadius.circular(16.0),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: backgroundWhite,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    DetailInfoTile(
                      icon: PhosphorIcon(
                        PhosphorIconsRegular.thermometerSimple,
                        color: Colors.white,
                      ),
                      title: 'Feels Like',
                      data: weatherProv.isCelsius
                          ? '${weatherProv.weather.feelsLike.toStringAsFixed(1)}°'
                          : '${weatherProv.weather.feelsLike.toFahrenheit().toStringAsFixed(1)}°',
                    ),
                    VerticalDivider(
                      thickness: 1.0,
                      indent: 4.0,
                      endIndent: 4.0,
                      color: backgroundBlue,
                    ),
                    VerticalDivider(
                      thickness: 1.0,
                      indent: 4.0,
                      endIndent: 4.0,
                      color: backgroundBlue,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: backgroundBlue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    DetailInfoTile(
                      icon: PhosphorIcon(
                        PhosphorIconsRegular.wind,
                        color: Colors.white,
                      ),
                      title: 'Wind',
                      data: '${weatherProv.weather.windSpeed} m/s',
                    ),
                    VerticalDivider(
                      thickness: 1.0,
                      indent: 4.0,
                      endIndent: 4.0,
                      color: backgroundBlue,
                    ),
                    DetailInfoTile(
                      icon: PhosphorIcon(
                        PhosphorIconsRegular.dropHalfBottom,
                        color: Colors.white,
                      ),
                      title: 'Humidity',
                      data: '${weatherProv.weather.humidity}%',
                    ),
                    VerticalDivider(
                      thickness: 1.0,
                      indent: 4.0,
                      endIndent: 4.0,
                      color: backgroundBlue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class DetailInfoTile extends StatelessWidget {
  final String title;
  final String data;
  final Widget icon;
  const DetailInfoTile({
    Key? key,
    required this.title,
    required this.data,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundColor: primaryBlue, child: icon),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(child: Text(title, style: lightText)),
                FittedBox(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 1.0),
                    child: Text(
                      data,
                      style: mediumText,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
