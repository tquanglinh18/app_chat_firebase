
import 'package:flutter_base/utils/logger.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toStringWith(String format) {
    String formattedDate = DateFormat(format).format(this);
    return formattedDate;
  }

  String onlyDate({String format = 'dd/MM/yyyy'}) {
    return toStringWith(format);
  }

  DateTime checkDateTime() {
    if (this != null) {
      return this;
    } else {
      return DateTime.now();
    }
  }

  static String dateTimeToDateFormatString(DateTime? dateTime,
      {String format = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(format).format(dateTime!);
    } catch (e) {
      return '';
    }
  }

  static String changeDateTimeToDateTimeString(DateTime? dateTime,
      {String format = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(format).format(dateTime!.toLocal());
    } catch (e) {
      return "";
    }
  }

  String fullDateTime({String format = 'dd-MM-yyyy HH:mm:ss'}) {
    return toStringWith(format);
  }

  String reverseDateTime({int? numberDay}) {
    DateTime expiredDate;
    String date;
    DateTime dateTimeNow = DateTime.now();

    numberDay != null
        ? expiredDate = add(Duration(days: numberDay))
        : expiredDate = this;

    final differenceInDays = expiredDate.difference(dateTimeNow).inDays + 1;

    differenceInDays >= 0
        ? date = "Còn $differenceInDays ngày hiển thị nổi bật"
        : date = "Đã hết ngày hiển thị nổi bật";
    return date;
  }

  String countDayStart() {
    DateTime dateTimeNow = DateTime.now();
    DateTime dateShow = this;
    final differenceInDays = dateShow.difference(dateTimeNow).inDays;
    String date = "Còn $differenceInDays ngày đến hạn bán";
    return date;
  }

  bool compareDateTime() {
    DateTime dateTimeNow = DateTime.now();
    DateTime createdDay = this;
    final differenceInDays = dateTimeNow.difference(createdDay).inDays;
    bool compareDate = differenceInDays >= 0 ? true : false;
    return compareDate;
  }

  bool compareDate() {
    DateTime dateTimeNow = DateTime.now();
    DateTime createdDay = this;
    final differenceInDays = createdDay.difference(dateTimeNow).inDays;
    bool compareDate = differenceInDays >= -1 ? false : true;
    return compareDate;
  }

  String? customOnlyDate({String format = 'dd/MM/yyyy'}) {
    try {
      return toStringWith(format);
    } catch (_) {
      return null;
    }
  }
}

extension StringExtension on String {
  DateTime? toDate(String format) {
    try {
      final date = DateFormat(format).parse(this);
      return date;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  DateTime? toDateLocal() {
    try {
      final date = DateTime.parse(this).toLocal();
      return date;
    } catch (e) {
      return null;
    }
  }

  String formatToDisplay({
    String formatDisplay = 'dd/MM/yyyy',
  }) {
    try {
      if (this == null || isEmpty) {
        return "";
      }
      final date = DateTime.parse(this).toLocal();
      return DateFormat(formatDisplay).format(date);
    } catch (e) {
      return "";
    }
  }

  static List<bool> operatingTimeKpi(DateTime date, bool isAdd) {
    //before, after
    try {
      DateTime dateCurrent = DateTime.now();
      var dateNow = isAdd
          ? DateTime(dateCurrent.year, dateCurrent.month + 1, dateCurrent.day)
          : dateCurrent;
      var dayDifference = dateNow.difference(date).inDays;
      int month = dayDifference ~/ 30;
      var list = <bool>[];
      if (month < 0) {
        list = [true, false];
      }
      if (month >= 12) {
        list = [false, true];
      }
      if (month >= 0 && month < 12) {
        list = [true, true];
      }
      return list;
    } catch (e) {
      return [false, false];
    }
  }
}

extension LocalTimeFormatter on String {
  String? dateTimeLocal(String format) {
    try {
      final date = DateTime.parse(this).toLocal();
      final dateFormat = DateFormat(format).format(date);
      return dateFormat;
    } catch (e) {
      return null;
    }
  }

  Duration cartRemainingTime(String format) {
    try {
      final date = DateTime.parse(this).toLocal();
      final currentTime = DateTime.now();
      if (currentTime.isAfter(date)) {
        return const Duration();
      } else {
        return date.difference(currentTime);
      }
    } catch (e) {
      return const Duration();
    }
  }
}

class DateTimeFormater {
  /// Dùng để hiển thị
  static String dateFormatVi = "dd/MM/yyyy";
  static String dateTimeFormatVi = "dd/MM/yyyy HH:mm:ss";
  static String dateTimeFormatView = "dd/MM/yyyy HH:mm";
  static String cartDateTimeFormat = "HH:mm:ss, dd/MM/yyyy";
  static String cartFormat = "HH:mm-dd/MM/yyyy";
  static String eventFormat = "HH:mm dd/MM/yyyy";
  static String rewardPointsFormat = "HH:mm dd-MM-yyyy";
  static String eventHour = "HH:mm";
  static String eventDate = "dd/MM";
  static String eventLiveStreamFormat = "HH:mm dd/MM";
  static String eventLiveStreamDate = "HH:mm-dd/MM/yyyy";
  static String eventLiveStreamTime = "HH:mm";
  static String financeTimeFormat = "dd/MM/yyyy";

  /// Format date from server và to server;
  static String dateTimeFormat = "yyyy-MM-dd";
  static String dateTimeFormatNormal = "yyyy-MM-dd HH:mm:ss";
  static String fullDateTimeFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ";
  static String fullDateTimeKPI = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static String dateTimeFormatMission = "yyyyMMdd";
}
