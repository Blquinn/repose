import 'dart:math' as math;

const int microsec = 1;
const int msec = microsec * 1000;
const int sec = msec * 1000;
const int minute = sec * 60;
const int hour = minute * 60;

String _formatDouble(double d, int decimalPoints) {
  return d.toStringAsFixed(d.truncateToDouble() == d ? 0 : decimalPoints);
}

String humanizeDuration(Duration duration) {
  var microSeconds = duration.inMicroseconds;
  int divisor;
  String suffix;
  if (microSeconds > minute) {
    divisor = minute;
    suffix = "m";
  } else if (microSeconds > sec) {
    divisor = sec;
    suffix = "s";
  } else if (microSeconds > msec) {
    divisor = msec;
    suffix = "ms";
  } else {
    divisor = microsec;
    suffix = "µs";
  }

  return "${_formatDouble(microSeconds / divisor, 2)} $suffix";
}

double logn(double n, double b) {
  return math.log(n) / math.log(b);
}

const List<String> sizes = ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"];

String humanizeBytes(int s) {
  double b = 1000;

  if (s < 10) {
    return "$s B";
  }

  var e = logn(s.toDouble(), b).floor();
  var suffix = sizes[e];
  var pp = math.pow(b, e);
  var val = (s / pp * 10 + 0.5).floorToDouble() / 10;

  int decimalPoints = 0;
  if (val < 10) {
    decimalPoints = 1;
  }

  return "${_formatDouble(val, decimalPoints)} $suffix";
}
