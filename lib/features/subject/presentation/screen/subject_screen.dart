import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/textfeild_widget.dart';
import 'package:smart_learn/features/subject/constants/education_levels.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_add_usecase.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_update_usecase.dart';
import 'package:smart_learn/features/subject/presentation/screen/subject_detail_screen.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_action.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_performer.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_state.dart';
import 'package:smart_learn/app/ui/dialogs/app_bottom_sheet.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';
import 'package:smart_learn/app/ui/widgets/popup_menu_widget.dart';
import 'package:smart_learn/utils/datetime_util.dart';

class SCRSubject extends StatefulWidget {
  const SCRSubject({super.key});

  @override
  State<StatefulWidget> createState() => _SCRSubjectState();
}

class _SCRSubjectState extends State<SCRSubject> {
  String? _filter;
  String? _arannge;
  late BuildContext _context;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((call) {
      _searchController.addListener(_onSearchTextChanged);
    });
  }

  void _onSearchTextChanged() {
    PerformerProvider.of<SubjectPerformer>(_context).add(ProcessSubject(search: _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<SubjectPerformer>.create(
      create: (_) => SubjectPerformer()..add(LoadAllSubject()),
      child: PerformerBuilder<SubjectPerformer>(builder: (context, conductor) {
        _context = context;
        final currentState = conductor.current;
        if (currentState.state == StateData.loading || currentState.state == StateData.init) {
          return const Center(
            child: WdgLoading(),
          );

        } else if (currentState.state == StateData.error) {
          return const Center(
            child: Text('Error'),
          );

        } else {
          return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 16),

                SizedBox(
                  child: Row(children: [
                    ///-  Lọc --------------------------------------------------------
                    WdgPopupMenu(
                      items: [
                        MenuItem(globalLanguage.isHide, null, () {
                          conductor.add(ProcessSubject(filterBy: FilterSubjectBy.isHide));
                          _filter = globalLanguage.isHide;
                        }),
                      ],
                      child: const Icon(Icons.filter_alt),
                    ),

                    ///-Tìm kiếm  --------------------------------------------------
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(8),
                          height: 50,
                          child: TextField(
                            controller: _searchController,
                            cursorColor: context.style.color.primaryColor,
                            decoration: InputDecoration(
                              hintText: globalLanguage.search,
                              contentPadding: const EdgeInsets.all(16),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: context.style.color.primaryColor.withAlpha(50)),
                              ),
                              suffixIcon: _searchController.text.isNotEmpty ?
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              ) : null,

                            ),
                          )),
                    ),

                    ///-  Sắp xếp -------------------------------------------------------
                    WdgPopupMenu(
                      items: [
                        MenuItem(globalLanguage.name, null, () {
                          conductor.add(ProcessSubject(sortType: SortType.byName));
                          _arannge = globalLanguage.name;
                        }),
                        MenuItem(globalLanguage.lastStudyDate, null, () {
                          conductor.add(ProcessSubject(sortType: SortType.byLastStudyDate));
                          _arannge = globalLanguage.lastStudyDate;
                        }),
                      ],
                      child: const Icon(Icons.compare_arrows),
                    ),
                  ]),
                ),

                ///-  Các ô lọc, sắp xếp-----------------------------------------------
                Wrap(spacing: 8, runSpacing: 8, children: [
                  if (_filter != null)
                    _buildFilterArrange(context: context, type: 'filter'),
                  if (_arannge != null)
                    _buildFilterArrange(context: context, type: 'arrange')
                ]),

                const SizedBox(height: 20),

                ///-  Danh sách subject ------------------------------------------------
                Expanded(
                    child: SingleChildScrollView(child:
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(children: [
                        /// Cột 1-----------------------------------------------------
                        Expanded(
                          child: Column(
                            children: List.generate(conductor.current.subjectsFilted.length, (index) {
                              if (index.isEven) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Card(child: _SubjectItem(conductor.current.subjectsFilted[index])),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                          ),
                        ),

                        /// Cột 2-----------------------------------------------------
                        Expanded(
                          child: Column(
                            children: List.generate(conductor.current.subjectsFilted.length, (index) {
                              if (index.isOdd) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Card(child: _SubjectItem(conductor.current.subjectsFilted[index])),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                          ),
                        ),
                      ],
                      ),
                    ),
                    )
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showAddSubject(context, (name, level) {
                    conductor.add(AddSubject(SubjectAddParams(name: name, level: level)));
                  });
                },
              child: const Icon(Icons.add),
            ),
          );
        }
      }),
    );
  }

  ///-  BOTTOM SHEET THÊM MÔN HỌC ----------------------------------------------
  void _showAddSubject(BuildContext context, Function(String name, String level) onAdd) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    String? levelSelected;

    showAppConfirmBottomSheet(
      onConfirm: () {
        if (formKey.currentState!.validate()) {
          onAdd(nameController.text.trim(), levelSelected!);
          Navigator.pop(context);
        }
      },
      context: context,
      title: 'Thêm môn học',
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            TextFormField(
              controller: nameController,
              maxLines: 1,
              decoration: inputDecoration(context: context, hintText: 'Tên môn học'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên môn học';
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: inputDecoration(context: context, hintText: 'Chọn lớp'),
              items: educationLevels.map((level) {
                return DropdownMenuItem<String>(value: level, child: Text(level));
              }).toList(),
              onChanged: (level) {
                levelSelected = level;
              },
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn lớp';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterArrange({required BuildContext context, required String type}) {
    return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: context.style.color.primaryColor.withAlpha(25),
            border: Border.all(
                color: context.style.color.primaryColor.withAlpha(100)),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(type == 'filter'
              ? '${globalLanguage.filter}: $_filter'
              : '${globalLanguage.arrange}: $_arannge'),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              if(type == 'filter') {
                _filter = null;
                PerformerProvider.of<SubjectPerformer>(context).add(ProcessSubject(filterBy: FilterSubjectBy.none));
              }
              else {
                _arannge = null;
                PerformerProvider.of<SubjectPerformer>(context).add(ProcessSubject(sortType: SortType.none));
              }
            },
            child: const Icon(Icons.close),
          )
        ]
        )
    );
  }
}

class _SubjectItem extends StatelessWidget with AppRouterMixin {
  final ENTSubject subject;
  const _SubjectItem(this.subject);

  @override
  Widget build(BuildContext context) {
    return WdgBounceButton(
        onTap: () {
          final performer = PerformerProvider.of<SubjectPerformer>(context);
          pushSlideLeft(context, SCRSubjectDetail(subject: subject, performer: performer));
          performer.add(UpdateSubject(SubjectUpdateParams(subject, lastStudyDate: DateTime.now())));
        },
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2.3
            ),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: context.style.color.primaryColor.withAlpha(100),
                    width: 1.5
                ),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 4,
                      color: context.style.color.primaryColor.withAlpha(5),
                      offset: const Offset(0, 2)
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    subject.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                ),

                const SizedBox(height: 5),

                Text(
                    subject.level,
                ),

                const SizedBox(height: 15),

                Text('${globalLanguage.lastStudyDate}: ${UTIDateTime.getFormatyyyyMMddHHmm(subject.lastStudyDate)}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            )
        )
    );
  }
}
