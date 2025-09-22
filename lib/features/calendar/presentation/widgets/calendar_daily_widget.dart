import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/presentation/screens/calendar_editor_screen.dart';
import 'package:smart_learn/features/calendar/presentation/state_manages/daily_viewmodel.dart';
import 'dart:async';
import 'package:smart_learn/utils/datetime_util.dart';

class WdgDailyCalendar extends StatefulWidget {
  final DateTime date;
  const WdgDailyCalendar({super.key, required this.date});

  @override
  State<WdgDailyCalendar> createState() => _WdgDailyCalendarState();
}

class _WdgDailyCalendarState extends State<WdgDailyCalendar> with AppRouterMixin {
  static const double hourHeight = 60.0;
  static const double timeLabelWidth = 60.0;
  static const int totalHours = 24;

  late bool _isToday;
  late DateTime _currentTime;
  Timer? _timer;
  late final VMLDaily _viewModel;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.date;
    _isToday = UTIDateTime.isToday(_currentTime);
    _viewModel = VMLDaily(current: _currentTime, getCalendar: getIt());
    _viewModel.current = _currentTime;
    _startTimer();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WdgDailyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!isSameDate(oldWidget.date, widget.date)) {
      _currentTime = widget.date;
      _isToday = UTIDateTime.isToday(_currentTime);
      _viewModel.current = _currentTime;
      setState(() {});
    }
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _startTimer() {
    if(!_isToday) return;

    _currentTime = DateTime.now();
    final int secondsToNextMinute = 60 - _currentTime.second;
    _timer = Timer.periodic(
      Duration(seconds: secondsToNextMinute == 0 ? 60 : secondsToNextMinute), (Timer timer) {
        setState(() {
          _currentTime = DateTime.now();
        });
        if (secondsToNextMinute != 60) {
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(minutes: 1), (t) {
            setState(() {
              _currentTime.add(const Duration(minutes: 1));
            });
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VMLDaily>.value(
      value: _viewModel,
      child: Consumer<VMLDaily>(builder: (context, vm, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: totalHours * hourHeight,
              child: Stack(
                children: [
                  /// Thanh thời gian ----------------------------------
                  _buildTimeLines(),

                  /// Các sự kiện --------------------------------------
                  ..._buildPositionedEvents(context),

                  /// Thanh thời gian hiện tại màu đỏ -----------------
                  if(_isToday)
                    Positioned(
                      top: _currentTimeOffset(),
                      left: timeLabelWidth,
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
      })
    );
  }

  ///-  Đường kẻ ---------------------------------------------------------
  Widget _buildTimeLines() {
    return Column(
      children: List.generate(totalHours, (hour) {
        return Container(
          height: hourHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.withAlpha(120), width: 0.5),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: timeLabelWidth,
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
                top: hourHeight / 2 - 0.25,
                left: timeLabelWidth,
                right: 0,
                child: CustomPaint(painter: _TimeLine()),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Build các sự kiện  ----------------------------------------------------
  List<Widget> _buildPositionedEvents(BuildContext context) {
    final double availableEventAreaWidth = MediaQuery.of(context).size.width - timeLabelWidth - 8;
    final currentTime = _currentTime.hour * 60 + _currentTime.minute;

    //--- Tính toán layout
    final List<Map<String, dynamic>> eventLayouts = _calculateEventLayout(
      List.from(_viewModel.events),
      availableEventAreaWidth,
    );

    final List<Widget> eventWidgets = [];
    for(final layout in eventLayouts) {
      final ENTCalendar event = layout['event'];
      final double left = layout['left'];
      final double width = layout['width'];

      final times = event.getTimeByDate(_viewModel.current);
      for (final time in times) {
        final int startTime = time['startTime'] ?? 0;
        final int endTime = time['endTime'] ?? 0;
        final double top = startTime / 60 * hourHeight;
        final double height = (endTime - startTime) / 60 * hourHeight;

        var opacity = 1.0;
        if(startTime > currentTime || endTime < currentTime || !_isToday) {
          opacity = 0.3;
        }

        eventWidgets.add(_buildEventCard(
            left: left,
            top: top,
            height: height,
            width: width - 8,
            time: '${UTIDateTime.getFormatHHmm(event.start)} - ${UTIDateTime.getFormatHHmm(event.end)}',
            opacity: opacity,
            calendar: event
        ));
      }
    }
    return eventWidgets;
  }

  /// Build item sự kiện  -----------------------------------------------------------
  Widget _buildEventCard({
    required double left,
    required double top,
    required double height,
    required double width,
    required String time,
    required double opacity,
    required ENTCalendar calendar
  }) {
    return Positioned(
      top: top,
      left: timeLabelWidth + left + 4,
      width: width - 8,
      height: height,
      child: WdgBounceButton(
        onTap: () => pushFade(context, SCRCalendarEditor(title: 'Chỉnh sửa', calendar: calendar, onSave: () {
          _viewModel.dataChanged();
        },)),
        scaleFactor: 0.9,
        child: Opacity(
        opacity: opacity,
        child: Container(
            decoration: BoxDecoration(
              color: (calendar.valueColor != null
                  ? Color(calendar.valueColor!)
                  : context.style.color.primaryColor).withAlpha(200),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: (calendar.valueColor != null ? Color(calendar.valueColor!) : Colors.deepPurple), width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            alignment: Alignment.topLeft,
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///-  Tiêu đề ----------------
                  Text(
                        calendar.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      ///-  Mô tả -------------------
                      const Text(
                        '',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      ///-  Thời gian -----------------
                      Text(
                        time,
                        style:
                            const TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ],
                  ),
            ))
        ),
      ),
    );
  }

  //--- Tính toán thanh thời gian hiện tại  ------------------------------------
  double _currentTimeOffset() {
    return (_currentTime.hour * hourHeight) +
        (_currentTime.minute / 60.0 * hourHeight);
  }

  //--- Tính layout các sự kiện ------------------------------------------------
  List<Map<String, dynamic>> _calculateEventLayout(List<ENTCalendar> events, double availableWidth) {
    if (events.isEmpty) return [];

    List<Map<String, dynamic>> layoutResults = [];
    final Set<String> processedEventIds = {};

    //->  Sắp xếp theo tgian bắt đầu
    events.sort((a, b) => a.start.compareTo(b.start));

    // --- DUYỆT SỰ KIỆN ---
    for (final event in events) {
      if (processedEventIds.contains(event.id)) {
        continue;
      }

      // --- GIAI ĐOẠN 1: TÌM NHÓM XUNG ĐỘT (CONFLICT GROUP) ---
      // Sử dụng thuật toán tương tự tìm kiếm theo chiều rộng (BFS) để tìm tất cả các sự kiện
      // chồng chéo với nhau một cách trực tiếp hoặc gián tiếp.
      final List<ENTCalendar> conflictGroup = [];
      final List<ENTCalendar> queue = [event];
      processedEventIds.add(event.id);

      //-> Tìm sự kiện trùng sự kiện hiện tại
      //-> Kết thúc khi không tìm được sự kiện trùng
      int head = 0;
      while(head < queue.length) {
        final currentEvent = queue[head++];
        conflictGroup.add(currentEvent);

        for (final otherEvent in events) {
          if (!processedEventIds.contains(otherEvent.id)) {
            if (currentEvent.checkDuplicateOnDate(otherEvent, _viewModel.current)) {
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
        int comp = a.start.compareTo(b.start);
        if (comp == 0) {
          return b.end.compareTo(a.end);
        }
        return comp;
      });

      List<DateTime> columnEndTimes = [];
      Map<String, int> eventColumnMap = {};

      for (final groupEvent in conflictGroup) {
        //-> Gán là chưa tìm thấy
        int assignedColumn = -1;

        //->  Tìm cột trống đầu tiên từ trái sang phải.
        for (int i = 0; i < columnEndTimes.length; i++) {
          if (groupEvent.start.isAfter(columnEndTimes[i]) || groupEvent.start == columnEndTimes[i]) {
            assignedColumn = i;
            break;
          }
        }

        //->  Chưa tìm thấy
        if (assignedColumn == -1) {
          assignedColumn = columnEndTimes.length;
          columnEndTimes.add(DateTime(0));
        }

        //-> Cập nhật thời gian rảnh và vị trí sự kiện
        columnEndTimes[assignedColumn] = groupEvent.end;
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

///-  ĐƯỜNG NÉT ĐỨT GIỮA CÁC GIỜ  ----------------------------------------------
class _TimeLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 4;
    const double dashSpace = 4;
    double x = 0;

    final paint = Paint()
      ..color = Colors.grey.withAlpha(100)
      ..strokeWidth = 0.5;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}