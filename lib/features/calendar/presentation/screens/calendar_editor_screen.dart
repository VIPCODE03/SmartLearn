import 'package:flutter/material.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/presentation/state_manages/editor_viewmodel.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/ui/widgets/divider_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:smart_learn/utils/datetime_util.dart';

import '../../../../global.dart';

class SCRCalendarEditor extends StatefulWidget {
  final ENTCalendar? calendar;
  final String? title;

  const SCRCalendarEditor({super.key, this.calendar, this.title});

  @override
  State<SCRCalendarEditor> createState() => _SCRCalendarEditorState();
}

class _SCRCalendarEditorState extends State<SCRCalendarEditor> {
  late final VMLCalendarEditor _viewModel;

  int _selectedType = 0;
  final TextEditingController _titleController = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  String? _cycle;
  final Set<int> _selectedWeekdays = {};

  BuidCalendarParams buildCalendar() {
    return BuidCalendarParams(
      type: _selectedType,
      id: widget.calendar?.id,
      title: _titleController.text,
      start: _start!,
      end: _end!,
      cycle: _cycle,
      weekdays: _selectedWeekdays,
    );
  }

  @override
  void initState() {
    super.initState();
    _viewModel = VMLCalendarEditor(
        useCaseUpdate: getIt(),
        useCaseCheckDuplicate: getIt()
    );

    if(widget.calendar != null) {
      _titleController.text = widget.calendar!.title;
      _start = widget.calendar!.start;
      _end = widget.calendar!.end;
      _cycle = widget.calendar!.cycle?.type.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(start: 72.0, bottom: 16.0),
                centerTitle: false,
                title: Text(
                  widget.title ?? 'Trình chỉnh sửa Lịch',
                ),
                collapseMode: CollapseMode.pin,
              ),
              actions: [
                IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      final check = _viewModel.checkDuplicate(params: buildCalendar());
                      _showDialogConfirm(context, check, (ok) {
                        if(ok) {
                          _viewModel.addOrUpdate(params: buildCalendar());
                          Navigator.of(context).pop();
                        }
                      });
                    })
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegate(
                minHeight: 60.0,
                maxHeight: 60.0,
                child: _buildSelectType(),
              ),
            ),

            SliverToBoxAdapter(
              child: _buildSetup(context)
            ),
          ],
        ),
      )
    );
  }

  ///-  Items chọn kiểu  --------------------------------------------------------
  Widget _buildSelectType() {
    return SizedBox(
      height: 60.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildItemType('Sự kiện', Icons.event, 0),
          _buildItemType('Môn học', Icons.subject, 1),
        ],
      ),
    );
  }

  ///-  Item chọn kiểu  --------------------------------------------------------
  Widget _buildItemType(String name, IconData icon, int index) {
    final isSelected = _selectedType == index;
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: WdgBounceButton(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? primaryColor(context) : Colors.grey,),

              Text(name, style: TextStyle(color: isSelected ? primaryColor(context) : Colors.grey)),
            ],
          ),
          onTap: () {
            setState(() {
              _selectedType = index;
            });
          }
      )
    );
  }

  ///-  Phần setup lịch --------------------------------------------------------
  ///---------------------------------------------------------------------------
  Widget _buildSetup(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        const WdgDivider(width: 300, height: 1.5),

        /// --- Nhập tiêu đề ------------------------------------------------
        TextField(
            controller: _titleController,
            decoration: inputDecoration(context: context, hintText: 'Tiêu đề')
        ),
        const SizedBox(height: 16),

        ///--- Chọn thời gian bắt đầu ----------------------------------------
        _buildDateTimePicker(
          context: context,
          label: 'Thời gian bắt đầu',
          dateTime: _start,
          onPicked: (picked) {
            setState(() {
              _start = picked;
            });
          },
        ),
        const SizedBox(height: 16),

        /// --- Chọn thời gian kết thúc --------------------------------------
        _buildDateTimePicker(
          context: context,
          label: 'Thời gian kết thúc',
          dateTime: _end,
          onPicked: (picked) {
            setState(() {
              _end = picked;
            });
          },
        ),
        const SizedBox(height: 16),

        /// --- Chọn chu kỳ --------------------------------------------------
        DropdownButtonFormField<String>(
          decoration: inputDecoration(context: context, hintText: 'Chu kỳ'),
          value: _cycle,
          items: const [
            DropdownMenuItem(value: 'none', child: Text('Không lặp')),
            DropdownMenuItem(value: 'daily', child: Text('Lặp hàng ngày')),
            DropdownMenuItem(value: 'weekly', child: Text('Lặp hàng tuần')),
          ],
          onChanged: (value) {
            setState(() {
              _cycle = value;
            });
          },
        ),

        if (_cycle == 'weekly') ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            children: _buildWeekdayChips(),
          )
        ]
      ],
    );
  }

  List<Widget> _buildWeekdayChips() {
    final days = [
      {'label': 'T2', 'value': 'mon'},
      {'label': 'T3', 'value': 'tue'},
      {'label': 'T4', 'value': 'wed'},
      {'label': 'T5', 'value': 'thu'},
      {'label': 'T6', 'value': 'fri'},
      {'label': 'T7', 'value': 'sat'},
      {'label': 'CN', 'value': 'sun'},
    ];

    return days.map((day) {
      final index = days.indexOf(day);
      final isSelected = _selectedWeekdays.contains(index);
      return FilterChip(
        label: Text(day['label']!),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedWeekdays.add(index);
            } else {
              _selectedWeekdays.remove(index);
            }
          });
        },
      );
    }).toList();
  }

  Widget _buildDateTimePicker({
    required BuildContext context,
    required String label,
    required DateTime? dateTime,
    required ValueChanged<DateTime> onPicked,
  }) {
    final now = DateTime.now();
    return InkWell(
      onTap: () async {

        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: dateTime ?? now,
          firstDate: DateTime(now.year),
          lastDate: DateTime(now.year + 5),
        );

        if (pickedDate != null && context.mounted) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: dateTime != null
                ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
                : TimeOfDay.fromDateTime(now),
          );

          if (pickedTime != null) {
            final combined = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            onPicked(combined);
          }
        }
      },
      child: InputDecorator(
        decoration: inputDecoration(context: context, hintText: label),
        child: Text(
          dateTime != null
              ? '${dateTime.day}/${dateTime.month}/${dateTime.year} ${UTIDateTime.getFormatHHmm(dateTime)}'
              : '${now.day}/${now.month}/${now.year} ${UTIDateTime.getFormatHHmm(now)}',
          style: TextStyle(
            color: dateTime != null ? null : Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

///-  Header chọn kiểu  --------------------------------------------------------
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

///-  Dialog xác nhận ----------------------------------------------------------
void _showDialogConfirm(
    BuildContext context,
    Future<bool> check,
    Function(bool) onSave,
    ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WdgScaleDialog(
        border: true,
        shadow: true,
        barrierDismissible: false,
        child: FutureBuilder<bool>(
          future: check,
          builder: (context, snapshot) {
            String statusText = 'Đang kiểm tra lịch...';
            Widget? action;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const WdgLoading(),
                  const SizedBox(height: 16),
                  Text(statusText),
                ],
              );
            }

            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Đã xảy ra lỗi: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đóng'),
                  ),
                ],
              );
            }

            if (snapshot.hasData) {
              final bool hasConflict = snapshot.data!;
              statusText = hasConflict ? 'Có lịch bị trùng!' : 'Không có lịch trùng.';

              action = WdgBounceButton(
                onTap: () {
                  Navigator.of(context).pop();
                  onSave(true);
                },
                child: Text(hasConflict ? 'Vẫn thêm' : 'OK',
                    style: TextStyle(color: primaryColor(context), fontWeight: FontWeight.w700)
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: snapshot.hasData && snapshot.data! ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                if (action != null) action
              ],
            );
          },
        ),
      );
    },
  );
}
