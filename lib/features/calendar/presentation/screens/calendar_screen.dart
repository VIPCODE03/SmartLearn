import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/presentation/widgets/calendar_daily_widget.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/ui/widgets/divider_widget.dart';

import 'calendar_editor_screen.dart';

class SCRCalendar extends StatefulWidget {
  const SCRCalendar({super.key});

  @override
  State<SCRCalendar> createState() => _SCRCalendarState();
}

class _SCRCalendarState extends State<SCRCalendar> with AppRouterMixin {
  late PageController _pageController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //------- Các hành động ---------------------------------------------------------------------
  void _selectToDay() {
    setState(() {
      _selectedDate = DateTime.now();
      _pageController.animateToPage(
        1000,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDate = day;
    });
  }

  void _pushEditorScreen(BuildContext context, {ENTCalendar? calendar}) {
    pushSlideLeft(context, SCRCalendarEditor(calendar: calendar));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    ///-  Thông tin ngày đang chọn  -------------------------------------------
                    Expanded(
                      child: Text(
                          DateFormat('EEEE, dd MMMM yyyy', 'vi_VN').format(_selectedDate),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor(context))),
                    ),

                    WdgBounceButton(
                        child: const Icon(Icons.add),
                        onTap: () => _pushEditorScreen(context)
                    ),

                    ///-  Button quay lại ngày hôm nay  --------------------------------------
                    TextButton(
                      onPressed: _selectToDay,
                      child: Text(
                        'Hôm nay',
                        style: TextStyle(
                            color: primaryColor(context), fontSize: 16),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 8),

                  ///-  Danh sách các ngày trong tuần ---------------------------------------
                  SizedBox(
                    height: 50,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {});
                      },
                      itemBuilder: (context, pageIndex) {
                        int weeksOffset = pageIndex - 1000;
                        DateTime weekStartDate = _getMondayOfWeek(
                          DateTime.now().add(Duration(days: weeksOffset * 7)),
                        );
                        List<DateTime> daysInWeek = _getDaysInWeek(weekStartDate);

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: daysInWeek.length,
                          itemBuilder: (context, dayIndex) {
                            DateTime day = daysInWeek[dayIndex];
                            bool isSelected = _isSameDay(day, _selectedDate);
                            bool isToday = _isSameDay(day, DateTime.now());

                            return GestureDetector(
                              onTap: () => _selectDay(day),
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 7.7,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor(context)
                                        : isToday
                                        ? primaryColor(context).withAlpha(60)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: isToday && !isSelected
                                        ? Border.all(
                                        color: primaryColor(context).withAlpha(150),
                                        width: 1)
                                        : null,
                                  ),
                                  child: FittedBox(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ///-  Thứ  ----------------------------------
                                        Text(
                                          DateFormat('EEE', 'vi_VN').format(day),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                        ///-  Ngày  -------------------------------------
                                        Text(
                                          day.day.toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ///-  Tháng --------------------------------------
                                        Text(
                                          'T${day.month}',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const WdgDivider(height: 1),
            const SizedBox(height: 8),

            ///-  Hiển thị lịch ---------------------------------------------------------
            Expanded(child: WdgDailyCalendar(date: _selectedDate)),
          ]),
        )
    );
  }

  ///-  Logic UI  --------------------------------------------------------------
  //--- Lấy ngày thứ 2 của tuần -----------------------------------------------
  DateTime _getMondayOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    if (dayOfWeek == DateTime.sunday) {
      return date.subtract(const Duration(days: 6));
    } else {
      return date.subtract(Duration(days: dayOfWeek - 1));
    }
  }

  //--- Lấy tất cả các ngày trong một tuần cụ thể ------------------------------
  List<DateTime> _getDaysInWeek(DateTime weekStartDate) {
    List<DateTime> days = [];
    for (int i = 0; i < 7; i++) {
      days.add(weekStartDate.add(Duration(days: i)));
    }
    return days;
  }

  //--- So sánh 2 ngày  --------------------------------------------------------
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

