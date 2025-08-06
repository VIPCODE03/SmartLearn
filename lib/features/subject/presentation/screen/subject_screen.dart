import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/presentation/mappers/subject_mapper.dart';
import 'package:smart_learn/features/subject/presentation/screen/subject_detail_screen.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_action.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_performer.dart';
import 'package:smart_learn/features/subject/presentation/state_manages/subject_performer/subject_state.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:smart_learn/ui/widgets/popup_menu_widget.dart';

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
                        MenuItem(globalLanguage.good, null, () {
                          conductor.add(ProcessSubject(filterBy: FilterSubjectBy.good));
                          _filter = globalLanguage.good;
                        }),
                        MenuItem(globalLanguage.quiteGood, null, () {
                          conductor.add(ProcessSubject(filterBy: FilterSubjectBy.quiteGood));
                          _filter = globalLanguage.quiteGood;
                        }),
                        MenuItem(globalLanguage.average, null, () {
                          conductor.add(ProcessSubject(filterBy: FilterSubjectBy.average));
                          _filter = globalLanguage.average;
                        }),
                        MenuItem(globalLanguage.poor, null, () {
                          conductor.add(ProcessSubject(filterBy: FilterSubjectBy.poor));
                          _filter = globalLanguage.poor;
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
                            cursorColor: primaryColor(context),
                            decoration: InputDecoration(
                              hintText: globalLanguage.search,
                              contentPadding: const EdgeInsets.all(16),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: primaryColor(context).withAlpha(50)),
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
                  conductor.add(AddSubject('name', 1));
                }
            ),
          );
        }
      }),
    );
  }

  Widget _buildFilterArrange({required BuildContext context, required String type}) {
    return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: primaryColor(context).withAlpha(25),
            border: Border.all(
                color: primaryColor(context).withAlpha(100)),
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
    return GestureDetector(
        onTap: () {
          pushSlideLeft(context, SCRSubjectDetail(subject: subject));
        },
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2.3
            ),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: primaryColor(context).withAlpha(100),
                    width: 1.5
                ),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 4,
                      color: primaryColor(context).withAlpha(5),
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

                const SizedBox(height: 15),

                Text('${globalLanguage.lastStudyDate}: ${subject.lastStudyDate}',
                    style: const TextStyle(color: Colors.grey)),

                Text(subject.evaluateName,
                    style: TextStyle(fontWeight: FontWeight.bold, color: subject.evaluateColor)
                ),
              ],
            )
        )
    );
  }
}
