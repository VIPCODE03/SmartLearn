import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smart_learn/data/models/calendar/a_calendar.dart';
import 'package:smart_learn/data/models/calendar/b_calendar_event.dart';
import 'package:smart_learn/data/models/calendar/zz_time.dart';
import 'package:smart_learn/global.dart';

class WdgDailyCalendar extends StatefulWidget {
  WdgDailyCalendar({super.key});

  static const double hourHeight = 60.0;
  static const double timeLabelWidth = 60.0;
  static const int totalHours = 24;

  final List<Calendar> events = [
    CalendarEvent(
        id: 'id',
        title: 'title',
        startTime: const Time(hour: 10, minute: 11),
        endTime: const Time(hour: 12, minute: 11),
        startDate: DateTime(2025, 6, 12),
        valueColor: Colors.green.toARGB32()
    ),
    CalendarEvent(
        id: 'ad',
        title: 'title',
        startTime: const Time(hour: 5, minute: 11),
        endTime: const Time(hour: 10, minute: 11),
        startDate: DateTime(2025, 6, 12),
        valueColor: Colors.green.toARGB32()
    ),
    CalendarEvent(
        id: 'fa',
        title: 'title',
        startTime: const Time(hour: 7, minute: 11),
        endTime: const Time(hour: 16, minute: 11),
        startDate: DateTime(2025, 6, 12),
        valueColor: Colors.red.toARGB32()
    ),
    CalendarEvent(
        id: 'afa',
        title: 'âfc',
        startTime: const Time(hour: 10, minute: 24),
        endTime: const Time(hour: 11, minute: 11),
        startDate: DateTime(2025, 6, 12),
        valueColor: Colors.deepPurple.toARGB32()
    ),
    CalendarEvent(
        id: 'caa',
        title: 'âfc',
        startTime: const Time(hour: 13, minute: 24),
        endTime: const Time(hour: 15, minute: 11),
        startDate: DateTime(2025, 6, 12),
        valueColor: Colors.brown.toARGB32()
    ),
  ];

  @override
  State<WdgDailyCalendar> createState() => _WdgDailyCalendarState();
}

class _WdgDailyCalendarState extends State<WdgDailyCalendar> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final int secondsToNextMinute = 60 - _currentTime.second;
    _timer = Timer.periodic(
      Duration(seconds: secondsToNextMinute == 0 ? 60 : secondsToNextMinute),
          (Timer timer) {
        setState(() {
          _currentTime = DateTime.now();
        });
        if (secondsToNextMinute != 60) {
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(minutes: 1), (t) {
            setState(() {
              _currentTime = DateTime.now();
            });
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: WdgDailyCalendar.totalHours * WdgDailyCalendar.hourHeight,
          child: Stack(
            children: [
              /// Thanh thời gian ----------------------------------
              _buildTimeLines(),

              /// Các sự kiện --------------------------------------
              ..._buildPositionedEvents(context),

              /// Thanh thời gian hiện tại màu đỏ -----------------
              Positioned(
                top: _currentTimeOffset(),
                left: WdgDailyCalendar.timeLabelWidth,
                right: 0,
                child: Container(
                  height: 1,
                  color: Colors.red,
                  child: Stack(
                    children: [
                      Positioned(
                        left: -5,
                        top: -4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///-  Đường kẻ ---------------------------------------------------------
  Widget _buildTimeLines() {
    return Column(
      children: List.generate(WdgDailyCalendar.totalHours, (hour) {
        return Container(
          height: WdgDailyCalendar.hourHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade800, width: 0.5),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: WdgDailyCalendar.timeLabelWidth,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: WdgDailyCalendar.hourHeight / 2 - 0.25,
                left: WdgDailyCalendar.timeLabelWidth,
                right: 0,
                child: CustomPaint(painter: DashedLinePainter()),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Build các sự kiện  ----------------------------------------------------
  List<Widget> _buildPositionedEvents(BuildContext context) {
    final double availableEventAreaWidth = MediaQuery.of(context).size.width - WdgDailyCalendar.timeLabelWidth - 8;

    //--- Tính toán layout
    final List<Map<String, dynamic>> eventLayouts = _calculateEventLayout(
      List.from(widget.events),
      availableEventAreaWidth,
    );

    return eventLayouts.map((layout) {
      final Calendar event = layout['event'];
      final double left = layout['left'];
      final double width = layout['width'];

      final double top = (event.startTime.hour * WdgDailyCalendar.hourHeight) + (event.startTime.minute / 60.0 * WdgDailyCalendar.hourHeight);
      final double height = (event.startTime.differenceInMinutes(event.endTime) / 60.0) * WdgDailyCalendar.hourHeight;

      //--- Độ mờ theo thời gian diễn ra
      double opacity = 1.0;
      DateTime today = DateTime.now();
      Time currentTime = Time.now();

      //->  Không cùng ngày
      if (today != today) {
        opacity = 0.7;
      } else {
        //-> Không cùng giờ
        if (event.endTime.isBefore(currentTime)) {
          opacity = 0.35;
        } else if (event.startTime.isAfter(currentTime)) {
          opacity = 0.35;
        }
        //-> Đang diễn ra
        else {
          opacity = 1.0;
        }
      }

      return Positioned(
        top: top,
        left: WdgDailyCalendar.timeLabelWidth + left + 4,
        width: width - 8,
        height: height,
        child: Opacity(
          opacity: opacity,
          child: _buildEventCard(event),
        ),
      );
    }).toList();
  }

  /// Build item sự kiện  -----------------------------------------------------------
  Widget _buildEventCard(Calendar event) {
    return Container(
      decoration: BoxDecoration(
        color: (event.valueColor != null ? Color(event.valueColor!) : primaryColor(context)).withAlpha(200),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: (event.valueColor != null ? Color(event.valueColor!) : Colors.deepPurple), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      alignment: Alignment.topLeft,
      child: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///-  Tiêu đề ----------------
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            ///-  Mô tả -------------------
            Text(
              _getDesc(event) ?? '',
              style: const TextStyle(fontSize: 10, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            ///-  Thời gian -----------------
            Text(
              '${event.startTime.formatHHMM} - ${event.endTime.formatHHMM}',
              style: const TextStyle(fontSize: 8, color: Colors.white),
            ),
          ],
        ),
      )
    );
  }

  String? _getDesc(Calendar calendar) {
    if(calendar is CalendarEvent) {
      return calendar.description;
    }

    if(calendar is CalendarSubject) {

    }
    return null;
  }

  //--- Tính toán thanh thời gian hiện tại  ------------------------------------
  double _currentTimeOffset() {
    return (_currentTime.hour * WdgDailyCalendar.hourHeight) +
        (_currentTime.minute / 60.0 * WdgDailyCalendar.hourHeight);
  }

  //--- Tính layout các sự kiện ------------------------------------------------
  List<Map<String, dynamic>> _calculateEventLayout(List<Calendar> events, double availableWidth) {
    if (events.isEmpty) return [];

    List<Map<String, dynamic>> layoutResults = [];
    final Set<String> processedEventIds = {};

    //->  Sắp xếp theo tgian bắt đầu
    events.sort((a, b) => a.startTime.compareTo(b.startTime));

    // --- DUYỆT SỰ KIỆN ---
    for (final event in events) {
      if (processedEventIds.contains(event.id)) {
        continue;
      }

      // --- GIAI ĐOẠN 1: TÌM NHÓM XUNG ĐỘT (CONFLICT GROUP) ---
      // Sử dụng thuật toán tương tự tìm kiếm theo chiều rộng (BFS) để tìm tất cả các sự kiện
      // chồng chéo với nhau một cách trực tiếp hoặc gián tiếp.
      final List<Calendar> conflictGroup = [];
      final List<Calendar> queue = [event];
      processedEventIds.add(event.id);

      //-> Tìm sự kiện trùng sự kiện hiện tại
      //-> Kết thúc khi không tìm được sự kiện trùng
      int head = 0;
      while(head < queue.length) {
        final currentEvent = queue[head++];
        conflictGroup.add(currentEvent);

        for (final otherEvent in events) {
          if (!processedEventIds.contains(otherEvent.id)) {
            if (currentEvent.intersects(otherEvent.startTime, otherEvent.endTime)) {
              processedEventIds.add(otherEvent.id);
              queue.add(otherEvent);
            }
          }
        }
      }

      // --- GIAI ĐOẠN 2: TÍNH TOÁN LAYOUT CHO NHÓM TÌM ĐƯỢC ---
      // Sắp xếp lần lượt theo cột, nếu không còn tạo cột mới
      // Mỗi 1 cột sẽ lưu giá trị endtime (bắt đầu thời gian rảnh)
      // Quy tắc 1: Ưu tiên sự kiện bắt đầu sớm.
      // Quy tắc 2: Nếu thời gian bắt đầu bằng nhau, ưu tiên sự kiện DÀI HƠN.
      conflictGroup.sort((a, b) {
        int comp = a.startTime.compareTo(b.startTime);
        if (comp == 0) {
          return b.endTime.compareTo(a.endTime);
        }
        return comp;
      });

      List<Time> columnEndTimes = [];
      Map<String, int> eventColumnMap = {};

      for (final groupEvent in conflictGroup) {
        //-> Gán là chưa tìm thấy
        int assignedColumn = -1;

        //->  Tìm cột trống đầu tiên từ trái sang phải.
        for (int i = 0; i < columnEndTimes.length; i++) {
          if (groupEvent.startTime.isAfter(columnEndTimes[i]) || groupEvent.startTime == columnEndTimes[i]) {
            assignedColumn = i;
            break;
          }
        }

        //->  Chưa tìm thấy
        if (assignedColumn == -1) {
          assignedColumn = columnEndTimes.length;
          columnEndTimes.add(const Time(hour: 0, minute: 0));
        }

        //-> Cập nhật thời gian rảnh và vị trí sự kiện
        columnEndTimes[assignedColumn] = groupEvent.endTime;
        eventColumnMap[groupEvent.id] = assignedColumn;
      }

      // --- GIAI ĐOẠN 3: TÍNH TOÁN VỊ TRÍ VÀ KÍCH THƯỚC CUỐI CÙNG ---

      //->  Tính độ rộng
      final int maxColumns = columnEndTimes.length;
      final double columnWidth = availableWidth / maxColumns;

      for (final groupEvent in conflictGroup) {
        final int columnIndex = eventColumnMap[groupEvent.id]!;
        layoutResults.add({
          'event': groupEvent,
          'left': columnIndex * columnWidth,
          'width': columnWidth,
        });
      }
    }

    return layoutResults;
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 4;
    const double dashSpace = 4;
    double x = 0;

    final paint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 0.5;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}