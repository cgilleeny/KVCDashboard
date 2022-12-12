import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/cubit/eyepair_cubit.dart';
import '../data/model/classification.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/ml_classification_filter_selector.dart';
import '../widgets/hand_classification_filter_selector.dart';
import '../data/model/filter.dart';

class FilterPage extends StatefulWidget {

  const FilterPage({Key? key,
  }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Filter filter = Filter();

  @override
  void initState() {
    super.initState();
    // filter = widget.filter.copyWith();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EyepairCubit>(context).fetchFilter();
    });
  }

  void onChangeRange(DateTimeRange? newRange, DateFilter newDateFilter) {
    filter.byDate = newDateFilter;
    filter.range = newRange;
  }

  void onChangeHandLabeledClassification(
      HandClassificationCategory classification,
      Classification newClassification) {
    switch (classification) {
      case HandClassificationCategory.handLabelSymmetry:
        filter.byHandLabeledSymmetry = newClassification;
        break;
      case HandClassificationCategory.handLabelSingle:
        filter.byHandLabeledSingle = newClassification;
        break;
    }
  }

  void onChangeMLClassification(MLClassificationCategory classification,
      Classification newClassification) {
    switch (classification) {
      case MLClassificationCategory.mlSymmetry:
        filter.byMLSymmetry = newClassification;
        break;
      case MLClassificationCategory.mlSingle:
        filter.byMLSingle = newClassification;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<EyepairCubit, EyepairState>(
      listener: (context, state) {
        if (state is EyepairsFilter) {
          setState(() {
            filter = state.filter?.copyWith() ?? Filter();
          });
        }
      },
      child: BlocBuilder<EyepairCubit, EyepairState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Filters'),
              leading: IconButton(
                icon: const Icon(
                  Icons.cancel_presentation,
                ),
                onPressed: () => Navigator.pop(context, (state as EyepairsFilter).filter?.isDefault ?? true),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    if (filter != (state as EyepairsFilter).filter) {
final provider = BlocProvider.of<EyepairCubit>(context);
filter.isDefault
                        ? provider.fetchFirstPage()
                        : provider.fetchFirstPage(filter: filter);
                    }
                    Navigator.pop(context, filter.isDefault);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        8.0,
                        8.0,
                        8.0,
                        0.0,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            filter = Filter();
                          });
                        },
                        child: const Text('Clear All'),
                      ),
                    ),
                    FilterBox(
                      DateFilterSelector(
                        filter.byDate,
                        filter.range,
                        onChangeRange,
                      ),
                    ),
                    FilterBox(
                      MLClassificationFilterSelector(
                          filter, onChangeMLClassification),
                    ),
                    FilterBox(
                      HandClassificationFilterSelector(
                          filter, onChangeHandLabeledClassification),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FilterBox extends StatefulWidget {
  final Widget content;

  const FilterBox(this.content, {Key? key}) : super(key: key);

  @override
  State<FilterBox> createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  late Widget content;

  @override
  void initState() {
    super.initState();
    content = widget.content;
  }

  @override
  void didUpdateWidget(covariant FilterBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      content = widget.content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8.0,
        8.0,
        8.0,
        0.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColorLight,
            width: 4,
          ),
        ),
        child: content,
      ),
    );
  }
}
