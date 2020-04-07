class Stats {
  String date;
  int newConfirmed;
  int totalConfirmed;
  int totalRecovered;
  int totalDeaths;

  Stats(
    this.date,
    this.newConfirmed,
    this.totalConfirmed,
    this.totalRecovered,
    this.totalDeaths,
  );

  DateTime getDateTime() => DateTime.parse(this.date);

  static Stats fromJson(Map<String, dynamic> json) => Stats(
        json['date'],
        json['NewConfirmed'],
        json['TotalConfirmed'],
        json['TotalRecovered'],
        json['TotalDeaths'],
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'NewConfirmed': newConfirmed,
        'TotalConfirmed': totalConfirmed,
        'TotalRecovered': totalRecovered,
        'TotalDeaths': totalDeaths,
      };
}
