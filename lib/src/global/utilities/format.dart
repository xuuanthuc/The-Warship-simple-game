import 'package:intl/intl.dart';

abstract class Formatter {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    try {
      DateTime notificationDate = DateFormat("yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
          .parse(dateString, true)
          .toUtc()
          .toLocal();
      final date2 = DateTime.now();
      final difference = date2.difference(notificationDate);
      if (difference.inDays > 8) {
        return '${notificationDate.year}/${notificationDate.month}/${notificationDate.day}';
      } else if ((difference.inDays / 7).floor() >= 1) {
        return (numericDates) ? '1w' : 'Last week';
      } else if (difference.inDays >= 2) {
        return '${difference.inDays}d';
      } else if (difference.inDays >= 1) {
        return (numericDates) ? '1d' : 'Yesterday';
      } else if (difference.inHours >= 2) {
        return '${difference.inHours}h';
      } else if (difference.inHours >= 1) {
        return (numericDates) ? '1h' : 'An hour ago';
      } else if (difference.inMinutes >= 2) {
        return '${difference.inMinutes}m';
      } else if (difference.inMinutes >= 1) {
        return (numericDates) ? '1m' : 'A minute ago';
      } else if (difference.inSeconds >= 3) {
        return '${difference.inSeconds} s';
      } else {
        return 'Now';
      }
    } catch (e) {
      return dateString;
    }
  }

  static String numberFormatter(String currentBalance) {
    try {
      // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};
      double value = double.parse(currentBalance);
      if (value < 10000) {
        return value.toStringAsFixed(0);
      } else if (10000 <= value && value < 100000) {
        // less than a 100K
        double result = value / 1000;
        if (result.toStringAsFixed(1)[3] == '0') {
          return "${result.toStringAsFixed(0)}K";
        } else {
          return "${result.toStringAsFixed(1)}K";
        }
      } else if (100000 <= value && value < 1000000) {
        // less than a million
        double result = value / 1000;
        if (result.toStringAsFixed(1)[4] == '0') {
          return "${result.toStringAsFixed(0)}K";
        } else {
          return "${result.toStringAsFixed(1)}K";
        }
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // less than 100 million
        double result = value / 1000000;
        return "${result.toStringAsFixed(1)}M";
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // less than 100 billion
        double result = value / (1000000 * 10 * 100);
        return "${result.toStringAsFixed(2)}B";
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // less than 100 trillion
        double result = value / (1000000 * 10 * 100 * 100);
        return "${result.toStringAsFixed(3)}T";
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  static String decimalPrice(int? price) {
    if (price == null) {
      return '';
    }
    String output = NumberFormat.decimalPattern().format(price);
    return output;
  }
}
