/// Global application utility class for nicely formatting and properly representing date and time within the app
/// 

class DateUtil {

  static final Map<int, String> monthIntToString = {
    1 : "Jan",
    2 : "Feb",
    3 : "Mar",
    4 : "Apr",
    5 : "May",
    6 : "Jun",
    7 : "Jul",
    8 : "Aug",
    9 : "Sep",
    10 : "Oct",
    11 : "Nov",
    12 : "Dec",
  };

  /// Converts a DateTime to ie. "Sep 19 2024"
  static String representDateAsMonthDateYear(DateTime date) => "${date.day} ${monthIntToString[date.month]} ${date.year}";

  /// Neatly formats how old an item is ie. 13d, 2mo or 2y
  static String representHowOld(DateTime date) {
    int daysSince = DateTime.now().difference(date).inDays;

    if (daysSince > 365) { 
      return "${(daysSince / 365).floor()}y"; 
    }
    else if (daysSince > 30) { 
      return "${(daysSince / 30).floor().toString()}mo"; 
    }

    return "$daysSince d";
  }
  
}