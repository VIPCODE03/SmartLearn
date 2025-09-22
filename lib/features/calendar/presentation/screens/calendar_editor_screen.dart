import 'package:flutter/material.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/dialogs/scale_dialog.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/divider_widget.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';
import 'package:smart_learn/app/ui/widgets/textfeild_widget.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/parameters/calendar_params.dart';
import 'package:smart_learn/features/calendar/domain/parameters/cycle_params.dart';
import 'package:smart_learn/features/calendar/presentation/state_manages/editor_viewmodel.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SCRCalendarEditor extends StatefulWidget {
  final ENTCalendar? calendar;
  final String? title;
  final VoidCallback? onSave;

  const SCRCalendarEditor({super.key, this.calendar, this.title, this.onSave});

  @override
  State<SCRCalendarEditor> createState() => _SCRCalendarEditorState();
}

class _SCRCalendarEditorState extends State<SCRCalendarEditor> {
  late final VMLCalendarEditor _viewModel;

  int _selectedType = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  String? _cycle;
  final Set<int> _selectedWeekdays = {};
  int? _valueColor;

  Color get _primaryColor => context.style.color.primaryColor;

  @override
  void initState() {
    super.initState();
    _viewModel = VMLCalendarEditor(getIt(), getIt(), getIt());

    if (widget.calendar != null) {
      _loadCalendar(widget.calendar!);
    } else {
      final now = DateTime.now();
      _start = now;
      _end = now.add(const Duration(minutes: 30));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
    _titleController.dispose();
    _descController.dispose();
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

        title: Text(widget.title ?? 'Lịch'),

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
    if(calendar is ENTCalendarEvent) {
      _descController.text = calendar.description ?? '';
    }
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
              ? PARCalendarEventAdd(title: _titleController.text, start: _start!, end: _end!, valueColor: _valueColor, desc: _descController.text)
              : PARCalendarSubjectAdd(title: _titleController.text, start: _start!, end: _end!, valueColor: _valueColor, subjectId: 'abc');
          _viewModel.add(params: params);
        }
        else {
          final PARCalendarUpdate params = _selectedType == 0
              ? PARCalendarEventUpdate(widget.calendar as ENTCalendarEvent, title: _titleController.text, start: _start!, end: _end!, cycle: _createCycleParams(), valueColor: _valueColor, desc: _descController.text)
              : PARCalendarSubjectUpdate(widget.calendar as ENTCalendarSubject, title: _titleController.text, start: _start!, end: _end!, cycle: _createCycleParams(), valueColor: _valueColor, subjectId: 'abc');
          _viewModel.update(params: params);
        }
        widget.onSave?.call();
        Navigator.of(context).pop();
      }
    });
  }

  ///-  ITEMS CHỌN LOẠI  -------------------------------------------------------
  Widget _buildSelectType() {
    return SizedBox(
      height: 60.0,
      child: Wrap(
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
              Icon(icon, color: isSelected ? _primaryColor : Colors.grey,),

              Text(name, style: TextStyle(color: isSelected ? _primaryColor : Colors.grey)),
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
        const WdgDivider(width: 300, height: 2),

        /// --- Nhập tiêu đề ------------------------------------------------
        const SizedBox(height: 16),
        TextField(
          controller: _titleController,
          decoration: inputDecoration(context: context, hintText: 'Tiêu đề'),
        ),

        const SizedBox(height: 16),
        if(_selectedType == 0)
          TextField(
            controller: _descController,
            decoration: inputDecoration(context: context, hintText: 'Ghi chú'),
          ),

        /// --- Row chọn ngày (bắt đầu/kết thúc) ------------------------------
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                context: context,
                label: 'Ngày bắt đầu',
                date: _start ?? DateTime.now(),
                onPicked: (d) => setState(() => _start = d),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDatePicker(
                context: context,
                label: 'Ngày kết thúc',
                date: _end ?? DateTime.now(),
                onPicked: (d) => setState(() => _end = d),
              ),
            ),
          ],
        ),

        /// --- Row chọn giờ (bắt đầu/kết thúc) --------------------------------
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTimePicker(
                context: context,
                label: 'Giờ bắt đầu',
                date: _start ?? DateTime.now(),
                onPicked: (d) => setState(() => _start = d),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimePicker(
                context: context,
                label: 'Giờ kết thúc',
                date: _end ?? DateTime.now(),
                onPicked: (d) => setState(() => _end = d),
              ),
            ),
          ],
        ),

        /// --- Chọn chu kỳ ----------------------------------------------------
        const SizedBox(height: 16),
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

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime date,
    required ValueChanged<DateTime> onPicked,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime(DateTime.now().year + 5),
        );
        if (picked != null) {
          // Giữ nguyên giờ cũ
          final updated = DateTime(
            picked.year,
            picked.month,
            picked.day,
            date.hour,
            date.minute,
          );
          onPicked(updated);
        }
      },
      child: InputDecorator(
        decoration: inputDecoration(context: context, hintText: label),
        child: Text("${date.day}/${date.month}/${date.year}"),
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required DateTime date,
    required ValueChanged<DateTime> onPicked,
  }) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
        );
        if (picked != null) {
          // Giữ nguyên ngày cũ
          final updated = DateTime(
            date.year,
            date.month,
            date.day,
            picked.hour,
            picked.minute,
          );
          onPicked(updated);
        }
      },
      child: InputDecorator(
        decoration: inputDecoration(context: context, hintText: label),
        child: Text("${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}"),
      ),
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
                  pickerColor: Color(_valueColor ?? _primaryColor.toARGB32()),
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
                        child: Text('OK', style: TextStyle(color: context.style.color.primaryColor),),
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
                          color: context.style.color.primaryColor,
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
