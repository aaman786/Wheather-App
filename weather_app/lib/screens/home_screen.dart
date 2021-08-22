import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/components/textStyle&divider.dart';
import 'package:weather_app/services/fetch_data.dart';
import 'package:weather_app/screens/sevendays_screen.dart';
import 'package:weather_app/screens/extra_dataPart.dart';

Weather? currentTemp; // TODO: To see the use of late keyword and working.
Weather? tomorrowTemp; // To see the use of late keyword and working.
late List<Weather> todayWeather;
late List<Weather> sevenDay;

CityModel? cityNameData;

String lat = "53.9006";
String lon = "27.5590";
String city = "Europe/Minsk";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getLocation() async {
    print("in getlocation method");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position.latitude);
    lat = position.latitude.toString();
    lon = position.longitude.toString();
    getData();
  }

  getData() async {
    print("in getData");
    await fetchDataApi(lat, lon).then((value) {
      currentTemp = value[0];
      todayWeather = value[1];
      tomorrowTemp = value[2];
      sevenDay = value[3];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    // final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0; //when keybord is open them shitf the ui at top
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false, //Keyboard overflow.
      backgroundColor: Color(0xff030317),
      body: currentTemp == null
          ? Center(child: CircularProgressIndicator())
          : // SingleChildScrollView( child: )  //for keyboard overflow
          Column(
              children: [CurrentWeather(getData), TodayWeather()],
            ),
    ));
  }
}

class CurrentWeather extends StatefulWidget {
  final Function() updateData;
  CurrentWeather(this.updateData);
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // searchBar ? searchBar = false: searchBar = true;
        if (searchBar) {
          setState(() {
            searchBar = false;
          });
        }
      },
      child: GlowContainer(
        height: MediaQuery.of(context).size.height - 235,
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.only(top: 17, right: 15, left: 15),
        color: Color(0xff0A1FF),
        glowColor: Color(0xff0A1FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        spreadRadius: 8,
        child: Column(
          children: [
            Container(
              //TODO: Understand the new code
              child: searchBar
                  ? TextField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Color(0xff030317),
                        filled: true,
                        hintText: "Enter City Name",
                        hintStyle: currentWeatherTextStyle(
                            fcolour: Colors.white, fsize: 18),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) async {
                        updating = true;
                        searchBar = false;
                        CityModel? temp = await fetchCity(value);

                        if (temp == null) {
                          showDialog(
                              context: context,
                              builder: (buildContext) {
                                return AlertDialog(
                                  backgroundColor: Colors.blueGrey[800],
                                  title: Text("City not found"),
                                  content: Text("Please check the city name"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Ok",
                                          style: currentWeatherTextStyle(
                                              fcolour: Colors.amber[100],
                                              fsize: 20),
                                        ))
                                  ],
                                );
                              });
                          updating = false;
                          return;
                        }
                        city = temp.name;
                        lat = temp.lat; //TODO: i am here
                        lon = temp.lon;

                        setState(() {});
                        searchBar = false;
                        updating = false;
                        setState(() {});
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        searchBar = true;
                        setState(() {});
                        focusNode.requestFocus();
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.search_circle,
                            color: Colors.white,
                            size: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.map_fill,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Text(
                                  " " + city,
                                  style: currentWeatherTextStyle(
                                      fsize: 30, fweight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.white),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(updating ? "Updating..." : "Updated",
                  style: currentWeatherTextStyle(
                      fsize: 17,
                      fcolour: Colors.greenAccent,
                      fweight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 2),
              height: 345,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 62, right: 23),
                    child: Image(
                      width: 500,
                      image: AssetImage(currentTemp!.image!),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Column(
                        children: [
                          GlowText(
                            currentTemp!.current.toString(),
                            style: currentWeatherTextStyle(
                                fsize: 120,
                                fcolour: Colors.white60,
                                fweight: FontWeight.w700,
                                fheight: 0.1),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(currentTemp!.name!,
                              style: currentWeatherTextStyle(fsize: 20)),
                          Text(
                            currentTemp!.day!,
                            style: currentWeatherTextStyle(fsize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            divider(),
            SizedBox(
              height: 10,
            ),
            ExtraWeather(
                currentTemp!,
                currentWeatherTextStyle(
                    fsize: 16,
                    fcolour: Colors.white70,
                    fweight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class TodayWeather extends StatefulWidget {
  @override
  _TodayWeatherState createState() => _TodayWeatherState();
}

class _TodayWeatherState extends State<TodayWeather> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 13),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today',
                style:
                    todayWeatherTextStyle(fsize: 25, fweight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return DetailPage(tomorrowTemp!, sevenDay);
                  }));
                },
                child: Row(
                  children: [
                    Text(
                      '7 Days',
                      style: todayWeatherTextStyle(
                          fsize: 18, fcolour: Colors.grey),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HourlyData(todayWeather[0]),
                HourlyData(todayWeather[1]),
                HourlyData(todayWeather[2]),
                HourlyData(todayWeather[3]),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HourlyData extends StatelessWidget {
  final Weather weather;
  HourlyData(this.weather);

  @override
  Widget build(BuildContext context) {
    double h = 5;
    return Container(
      padding: EdgeInsets.only(top: 8.5, right: 13.5, left: 13.5, bottom: 8.5),
      decoration: BoxDecoration(
          border: Border.all(width: 0.7, color: Colors.lightGreenAccent),
          borderRadius: BorderRadius.circular(26.0)),
      child: Column(
        children: [
          Text(
            weather.current.toString() + "\u00B0", //for degree
            style: hourlyDataTextStyle(21),
          ),
          SizedBox(
            height: h,
          ),
          Image(
            image: AssetImage(weather.image!),
            width: 43.0,
            height: 43.0,
          ),
          SizedBox(
            height: h,
          ),
          Text(
            weather.time!,
            style: hourlyDataTextStyle(18),
          )
        ],
      ),
    );
  }
}
