import 'package:flutter/material.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/parameters/calendar_params.dart';
import 'package:smart_learn/features/calendar/domain/parameters/cycle_params.dart';
import 'package:smart_learn/features/calendar/presentation/state_manages/editor_viewmodel.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/ui/widgets/divider_widget.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:smart_learn/utils/datetime_util.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  int? _valueColor;

  @override
  void initState() {
    super.initState();
    _viewModel = VMLCalendarEditor(getIt(), getIt(), getIt());

    if(widget.calendar != null) {
      _loadCalendar(widget.calendar!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.design_services),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: Text(widget.title ?? 'Trình chỉnh sửa Lịch'),

        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          WdgBounceButton(
            onTap: _onSave,
            child: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              SizedBox(height: 60, child: _buildSelectType()),
              Expanded(child: SingleChildScrollView(
                  child: _buildSetup(context)
              )),
            ],
        ),
      )
    );
  }

  //- Tải dữ liệu calendar -----------------------------------------------------
  void _loadCalendar(ENTCalendar calendar) {
    if(calendar is ENTCalendarEvent) {
      _selectedType = 0;
    }
    else if(calendar is ENTCalendarSubject) {
      _selectedType = 1;
    }
    _titleController.text = calendar.title;
    _start = calendar.start;
    _end = calendar.end;
    _cycle = calendar.cycle?.type.name;
    _selectedWeekdays.addAll(calendar.cycle?.daysOfWeek ?? {});
    _valueColor = calendar.valueColor;
  }

  //- Tạo chu kỳ  --------------------------------------------------------------
  PARCycle? _createCycleParams() {
    switch(_cycle) {
      case 'none':
        return PARCycleNone();
      case 'daily':
        return PARCycleDaily();
      case 'weekly':
        return PARCycleWeekly(_selectedWeekdays);
      default:
        return null;
    }
  }

  //- Hành động lưu ------------------------------------------------------------
  void _onSave() {
    final check = _viewModel.checkDuplicate(params: PARCalendarCheckDuplicate(
        id: widget.calendar?.id,
        start: _start!,
        end: _end!,
        cycle: _createCycleParams()
    ));
    _showDialogConfirm(context, check, (ok) {
      if (ok) {
        if(widget.calendar == null) {
          final params = _selectedType == 0
              ? PARCalendarEventAdd(title: _titleController.text, start: _start!, end: _end!, valueColor: _valueColor, desc: 'abc')
              : PARCalendarSubjectAdd(title: _titleController.text, start: _start!, end: _end!, valueColor: _valueColor, subjectId: 'abc');
          _viewModel.add(params: params);
        }
        else {
          final PARCalendarUpdate params = _selectedType == 0
              ? PARCalendarEventUpdate(widget.calendar as ENTCalendarEvent,
              title: _titleController.text, start: _start!, end: _end!,cycle: _createCycleParams(), valueColor: _valueColor,
              desc: 'abc')
              : PARCalendarSubjectUpdate(widget.calendar as ENTCalendarSubject,
              title: _titleController.text, start: _start!, end: _end!, cycle: _createCycleParams(), valueColor: _valueColor,
              subjectId: 'abc');
          _viewModel.update(params: params);
        }
        Navigator.of(context).pop();
      }
    });
  }

  ///-  ITEMS CHỌN LOẠI  -------------------------------------------------------
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

  ///-  SETUP LỊCH -------------------------------------------------------------
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
          value: _cycle ?? 'none',
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
        ],

        ///-  CHỌN MÀU  --------------------------------------------------------
        _buildColorPicker(context, (color) => setState(() {
          _valueColor = color.toARGB32();
        }))
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
      final isSelected = _selectedWeekdays.contains(index + 1);
      return FilterChip(
        label: Text(day['label']!),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedWeekdays.add(index + 1);
            } else {
              _selectedWeekdays.remove(index + 1);
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

  Widget _buildColorPicker(BuildContext context, Function(Color color) onSelect) {
    return ListTile(
      leading: Icon(Icons.color_lens, color: _valueColor != null ? Color(_valueColor!) : Colors.grey),
      title: const Text(
        'Chọn màu',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return WdgScaleDialog(
              child: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: Color(_valueColor ?? primaryColor(context).toARGB32()),
                  onColorChanged: (Color color) {
                    onSelect(color);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        );
      },
    );
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
        child: Padding(
          padding: const EdgeInsets.all(10),
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

                    const Text('Thời gian bắt đầu phải trước thời gian kết thúc'),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: WdgBounceButton(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text('OK', style: TextStyle(color: primaryColor(context)),),
                      ),
                    )
                  ],
                );
              }

              if (snapshot.hasData) {
                final bool hasConflict = snapshot.data!;
                statusText = hasConflict
                    ? 'Có lịch bị trùng!'
                    : 'Không có lịch trùng.';

                action = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WdgBounceButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 32),

                    WdgBounceButton(
                      onTap: () {
                        Navigator.of(context).pop();
                        onSave(true);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: primaryColor(context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        snapshot.hasData && snapshot.data!
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_rounded,
                        color: snapshot.hasData && snapshot.data! ? Colors.amber : Colors.green,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: snapshot.hasData && snapshot.data! ? Colors.amber : Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  if (action != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: action,
                    )
                ],
              );
            },
          ),
        )
      );
    },
  );
}
