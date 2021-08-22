import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:weather_app/components/textStyle&divider.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/fetch_data.dart';
import 'package:weather_app/screens/extra_dataPart.dart';

class DetailPage extends StatelessWidget {
  final Weather tomorrowTemp;
  final List<Weather> sevenDay;
  DetailPage(this.tomorrowTemp, this.sevenDay);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff030317),
        body: Column(
          children: [TomorrowWeather(tomorrowTemp), SevenDays(sevenDay)],
        ),
      ),
    );
  }
}

class TomorrowWeather extends StatelessWidget {
  final Weather tomorrowTemp;
  TomorrowWeather(this.tomorrowTemp);

  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      color: Color(0xff0A1FF),
      glowColor: Color(0xff0A1FF),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 25,
                    ),
                    Text(
                      " " + city,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    )
                  ],
                ),
                Icon(Icons.more_vert, color: Colors.white, size: 25)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(tomorrowTemp.image!))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tomorrow",
                      style: TextStyle(fontSize: 30, height: 0.1),
                    ),
                    Container(
                      height: 105,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GlowText(
                            tomorrowTemp.max.toString(),
                            style: TextStyle(
                                fontSize: 100, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "/" + tomorrowTemp.min.toString() + "\u00B0",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      " " + tomorrowTemp.name!,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: divider(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, left: 50, right: 50),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                ExtraWeather(
                    tomorrowTemp,
                    TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SevenDays extends StatelessWidget {
  final List<Weather> sevenDay;
  SevenDays(this.sevenDay);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: sevenDay.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sevenDay[index].day! + "",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      width: 135,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            image: AssetImage(sevenDay[index].image!),
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            sevenDay[index].name!,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "+" + sevenDay[index].max.toString() + "\u00B0",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "+" + sevenDay[index].max.toString() + "\u00B0",
                          style: TextStyle(fontSize: 20, color: Colors.white54),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
