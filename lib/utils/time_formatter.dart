class TimeFormatterUtil {
  static String fomathhmmss(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
  }

  static String fomathhmm(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;

    final parts = [
      if (h > 0) '${h}h',
      if (m > 0 || h > 0) '${m}m',
    ];

    return parts.join(' ');
  }
}
