class Salat {
  final Map<String, String> prayerTime;
  final String date;
  final String cityName;

  Salat({required this.date, required this.cityName, required this.prayerTime});

  factory Salat.fromJson(Map<String, dynamic> json, String city) {
    final Map<String, dynamic> hijri = json['data']['date']['hijri'];
    final Map<String, dynamic> gregorian = json['data']['date']['gregorian'];

    final String hijriDate =
        "${hijri['day']} ${hijri['month']['ar']} ${hijri['year']}";
    final String gregorianDate =
        "${gregorian['month']['en']} ${gregorian['day']}, ${gregorian['year']}";

    // Combine Hijri and Gregorian date
    final String date = "$hijriDate / $gregorianDate";
    final Map<String, String> prayerTime =
        Map<String, String>.from(json['data']['timings']);
    return Salat(date: date, prayerTime: prayerTime, cityName: city);
  }
}
