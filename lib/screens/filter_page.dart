import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/classification.dart';
import '../widgets/date_filter_selector.dart';
import '../widgets/ml_classification_filter_selector.dart';
import '../widgets/hand_classification_filter_selector.dart';
import '../data/model/filter.dart';

class FilterPage extends StatefulWidget {
  final Filter filter;
  // ignore: use_key_in_widget_constructors
  const FilterPage(this.filter);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late Filter filter;

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
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
    final theme = Theme.of(context);
    print(
        'FilterPage filter: ${filter.byMLSymmetry}, widget.filter: ${widget.filter.byMLSymmetry}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        leading: IconButton(
          icon: const Icon(
            Icons.cancel_presentation,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.pop(context, filter);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                // width: 300,
                decoration: BoxDecoration(
                  // color: Colors.pink,
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                    width: 4,
                  ),
                ),
                child: DateFilterSelector(
                  widget.filter.byDate,
                  widget.filter.range,
                  onChangeRange,
                ),
              ),
            ),
            /*
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Container(
                // height: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  // color: Colors.lightGreen,
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                    width: 4,
                  ),
                ),
                child: ClassificationFilterSelector(
                    widget.filter, onChangeClassification),
              ),
            ),
            */
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              // child: Expanded(
              child: Container(
                // height: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  // color: Colors.lightGreen,
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                    width: 4,
                  ),
                ),
                child: MLClassificationFilterSelector(
                    widget.filter, onChangeMLClassification),
              ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              // child: Expanded(
              child: Container(
                // height: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  // color: Colors.lightGreen,
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                    width: 4,
                  ),
                ),
                child: HandClassificationFilterSelector(
                    widget.filter, onChangeHandLabeledClassification),
              ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
