import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'png_pick.dart';

class Weather {
  final int? max;
  final int? min;
  final int? current;
  final String? name;
  final String? day;
  final int? wind;
  final int? humidity;
  final int? chanceRain;
  final String? image;
  final String? time;
  final String? location;

  Weather(
      {this.max,
      this.min,
      this.name,
      this.day,
      this.wind,
      this.humidity,
      this.chanceRain,
      this.image,
      this.current,
      this.time,
      this.location});
}

const String appId = "46508b5f8b9fa09f2fdae5acb2f259c1";

Future<List> fetchDataApi(String lat, String lon) async {
  try {
    var url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
    var response = await http.get(Uri.parse(url));
    DateTime date = DateTime.now();

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var apiCity = res["timezone"];

      if (city.contains('/')) {
        List<String> cityName = apiCity.split('/');
        city = cityName[1];
      } else {
        city = apiCity;
      }

      //current Temp
      var current = res["current"];
      Weather currentTemp = Weather(
          current: current["temp"]?.round() ?? 0,
          name: current["weather"][0]["main"].toString(),
          day: DateFormat("EEE dd MMM").format(date),
          wind: current["wind_speed"]?.round() ?? 0,
          humidity: current["humidity"]?.round() ?? 0,
          chanceRain: current["uvi"]?.round() ?? 0,
          location: apiCity,
          image: findIcon(current["weather"][0]["main"].toString(), true));

      //today weather
      List<Weather> todayWeather = [];
      int hour = int.parse(DateFormat("hh").format(date));
      for (int i = 0; i < 4; i++) {
        var temp = res["hourly"];
        var hourly = Weather(
            current: temp[i]["temp"]?.round() ?? 0,
            image: findIcon(temp[i]["weather"][0]["main"].toString(), false),
            time:
                Duration(hours: hour + i + 1).toString().split(":")[0] + ":00");
        todayWeather.add(hourly);
      }

      //Tomorrow Weather
      var daily = res["daily"][0];
      Weather tomorrowTemp = Weather(
          max: daily["temp"]["max"]?.round() ?? 0,
          min: daily["temp"]["min"]?.round() ?? 0,
          image: findIcon(daily["weather"][0]["main"].toString(), true),
          name: daily["weather"][0]["main"].toString(),
          wind: daily["wind_speed"]?.round() ?? 0,
          humidity: daily["rain"]?.round() ?? 0,
          chanceRain: daily["uvi"]?.round() ?? 0);

      //Seven Day Weather
      List<Weather> sevenDay = [];
      for (int i = 1; i < 8; i++) {
        String day = DateFormat("EEE")
            .format(DateTime(date.year, date.month, date.day + i + 1))
            .substring(0, 3);
        var temp = res["daily"][i];
        var hourly = Weather(
            max: temp["temp"]["max"]?.round() ?? 0,
            min: temp["temp"]["min"]?.round() ?? 0,
            image: findIcon(temp["weather"][0]["main"].toString(), false),
            name: temp["weather"][0]["main"].toString(),
            day: day);
        sevenDay.add(hourly);
      }
      return [currentTemp, todayWeather, tomorrowTemp, sevenDay];
    } else {
      print(response.statusCode);
    }
  } catch (e) {
    print(e);
    print("In the catch block of DataSet.dart");
  }
  return [null, null, null, null];
}

class CityModel {
  final String name;
  final String lat;
  final String lon;
  CityModel({required this.name, required this.lat, required this.lon});
}

var cityJSON;

Future<CityModel?> fetchCity(String cityName) async {
  try {
    // if (cityJSON == null) { //gives one seach only with the city name
    var link = Uri.parse(
        "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json");
    var response = await http.get(link);
    if (response.statusCode == 200) {
      cityJSON = json.decode(response.body);
    }
    for (int i = 0; i < cityJSON.length; i++) {
      if (cityJSON[i]["name"].toString().toLowerCase() ==
          cityName.toLowerCase()) {
        return CityModel(
            name: cityJSON[i]["name"].toString(),
            lat: cityJSON[i]["latitude"].toString(),
            lon: cityJSON[i]["longitude"].toString());
      }
      // }
    }
    return null;
  } catch (e) {
    print(e);
  }
  return null;
}




// //  dummy data for creating the UI.

// List<Weather> todayWeather = [
//   Weather(current: 23, image: "assets/rainy_2d.png", time: "10:00"),
//   Weather(current: 21, image: "assets/thunder_2d.png", time: "11:00"),
//   Weather(current: 22, image: "assets/rainy_2d.png", time: "12:00"),
//   Weather(current: 19, image: "assets/snow_2d.png", time: "01:00")
// ];

// Weather currentTemp = Weather(
//     current: 21,
//     image: "assets/thunder.png",
//     name: "Thunderstorm",
//     day: "Monday, 17 May",
//     wind: 13,
//     humidity: 24,
//     chanceRain: 87,
//     location: "Minsk");

// Weather tomorrowTemp = Weather(
//   max: 20,
//   min: 17,
//   image: "assets/sunny.png",
//   name: "Sunny",
//   wind: 9,
//   humidity: 31,
//   chanceRain: 20,
// );

// List<Weather> sevenDay = [
//   Weather(
//       max: 20,
//       min: 14,
//       image: "assets/rainy_2d.png",
//       day: "Mon",
//       name: "Rainy"),
//   Weather(
//       max: 22,
//       min: 16,
//       image: "assets/thunder_2d.png",
//       day: "Tue",
//       name: "Thunder"),
//   Weather(
//       max: 19,
//       min: 13,
//       image: "assets/rainy_2d.png",
//       day: "Wed",
//       name: "Rainy"),
//   Weather(
//       max: 18, min: 12, image: "assets/snow_2d.png", day: "Thu", name: "Snow"),
//   Weather(
//       max: 23,
//       min: 19,
//       image: "assets/sunny_2d.png",
//       day: "Fri",
//       name: "Sunny"),
//   Weather(
//       max: 25,
//       min: 17,
//       image: "assets/rainy_2d.png",
//       day: "Sat",
//       name: "Rainy"),
//   Weather(
//       max: 21,
//       min: 18,
//       image: "assets/thunder_2d.png",
//       day: "Sun",
//       name: "Thunder")
// ];