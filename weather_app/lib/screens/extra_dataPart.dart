import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/services/fetch_data.dart';

class ExtraWeather extends StatelessWidget {
  final Weather temp;
  final TextStyle textStyle;
  ExtraWeather(this.temp, this.textStyle);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        extraData(
            CupertinoIcons.wind, temp.humidity.toString() + " %", "Humidity"),
        extraData(
            CupertinoIcons.wind, temp.chanceRain.toString() + " %", "Rain"),
        extraData(CupertinoIcons.wind, temp.wind.toString() + " km/h", "Wind"),
      ],
    );
  }

  Column extraData(IconData iconName, String condData, String conditionName) {
    return Column(
      children: [
        Icon(
          iconName,
          color: Colors.white,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          condData,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(
          conditionName,
          style: textStyle,
        ),
      ],
    );
  }
}
