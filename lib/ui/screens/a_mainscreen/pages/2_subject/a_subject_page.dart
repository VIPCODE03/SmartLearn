import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/performers/action_unit/subject_action/subject_action.dart';
import 'package:smart_learn/performers/performer/subject_page_conductor.dart';
import 'package:smart_learn/performers/data_state/data_state.dart';
import 'package:smart_learn/performers/data_state/subject_state.dart';
import 'package:smart_learn/data/models/subject/a_subject.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/screens/a_mainscreen/pages/2_subject/b_detail_subject_screen.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';
import 'package:smart_learn/ui/widgets/popup_menu_widget.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  State<StatefulWidget> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
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
    PerformerProvider.of<SubjectPageConductor>(_context).add(ProcessSubject(search: _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PerformerProvider<SubjectPageConductor>.create(
      create: (_) => SubjectPageConductor()..add(LoadAllSubject()),
      child: PerformerBuilder<SubjectPageConductor>(builder: (context, conductor) {
        _context = context;
        if (conductor.current.state == StateData.loading) {
          return const Center(
            child: WdgLoading(),
          );

        } else if (conductor.current.state == StateData.loaded) {
          return Column(
            children: [
              const SizedBox(height: 16),

              SizedBox(
                child: Row(children: [
                  ///-  Lọc --------------------------------------------------------
                  WdgPopupMenu(
                    items: [
                      MenuItem(globalLanguage.good, Icons.add, () {
                        conductor.add(ProcessSubject(filterBy: FilterSubjectBy.good));
                        _filter = globalLanguage.good;
                      }),
                      MenuItem(globalLanguage.quiteGood, Icons.add, () {
                        conductor.add(ProcessSubject(filterBy: FilterSubjectBy.quiteGood));
                        _filter = globalLanguage.quiteGood;
                      }),
                      MenuItem(globalLanguage.average, Icons.add, () {
                        conductor.add(ProcessSubject(filterBy: FilterSubjectBy.average));
                        _filter = globalLanguage.average;
                      }),
                      MenuItem(globalLanguage.poor, Icons.add, () {
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
                      MenuItem(globalLanguage.name, Icons.add, () {
                        conductor.add(ProcessSubject(sortType: SortType.byName));
                        _arannge = globalLanguage.name;
                      }),
                      MenuItem(globalLanguage.lastStudyDate, Icons.add, () {
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
          );

        } else if (conductor.current.state == StateData.error) {
          return const Center(
            child: Text('Error'),
          );
        }
        return const SizedBox.shrink();
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
                PerformerProvider.of<SubjectPageConductor>(context).add(ProcessSubject(filterBy: FilterSubjectBy.none));
              }
              else {
                _arannge = null;
                PerformerProvider.of<SubjectPageConductor>(context).add(ProcessSubject(sortType: SortType.none));
              }
            },
            child: const Icon(Icons.close),
          )
        ]
        )
    );
  }
}

class _SubjectItem extends StatelessWidget {
  final Subject subject;

  const _SubjectItem(this.subject);
  
  Map<String, dynamic> evaluate(double average) {
    if (average < 4) {
      return {'text': globalLanguage.poor, 'color': Colors.red};
    } else if (average >= 4 && average < 6.5) {
      return {'text': globalLanguage.average, 'color': Colors.deepOrange};
    } else if (average >= 6.5 && average < 8.2) {
      return {'text': globalLanguage.quiteGood, 'color': Colors.blue};
    } else {
      return {'text': globalLanguage.good, 'color': Colors.green};
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double average = subject.averageCore;
    return InkWell(
        onTap: () {
          navigateToNextScreen(context, DetailSubjectScreen(subject: subject));
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
                Text(evaluate(average)['text'],
                    style: TextStyle(fontWeight: FontWeight.bold, color: evaluate(average)['color'])),
              ],
            )
        )
    );
  }
}
