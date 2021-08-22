// Find Icons
String findIcon(String name, bool type) {
  if (type) {
    switch (name) {
      case "Clouds":
        return "assets/sunny.png";

      case "Rain":
        return "assets/rainy.png";

      case "Drizzle":
        return "assets/rainy.png";

      case "Thunderstrom":
        return "assets/thunder.png";

      case "Snow":
        return "assets/snow.png";

      case "Thunderstrom":
        return "assets/thunder.png";

      default:
        return "assets/sunny.png";
    }
  } else {
    switch (name) {
      case "Clouds":
        return "assets/sunny_2d.png";

      case "Rain":
        return "assets/rainy_2d.png";

      case "Drizzle":
        return "assets/rainy_2d.png";

      case "Thunderstrom":
        return "assets/thunder_2d.png";

      case "Snow":
        return "assets/snow_2d.png";

      case "Thunderstrom":
        return "assets/thunder_2d.png";

      default:
        return "assets/sunny_2d.png";
    }
  }
}
