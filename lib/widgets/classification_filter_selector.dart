/*
import 'package:flutter/material.dart';

import '../data/model/classification.dart';
import '../data/model/filter.dart';
import './popup_menu_button.dart';

enum ClassificationCategory {
  mlSymmetry,
  handLabelSymmetry,
  mlSingle,
  handLabelSingle
}

class ClassificationFilterSelector extends StatefulWidget {
  final Filter filter;
  final Function(ClassificationCategory newClassificationCategory,
      Classification newClassification) onChange;

  const ClassificationFilterSelector(this.filter, this.onChange);

  @override
  State<ClassificationFilterSelector> createState() =>
      _ClassificationFilterSelectorState();
}

class _ClassificationFilterSelectorState
    extends State<ClassificationFilterSelector> {
  late Filter filter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filter = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Filter By Classification',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ML Symmetry'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomPopupMenuButton(
                    classification: filter.byMLSymmetry,
                    iconData: Icons.contrast,
                    onSelected: (value) {
                      setState(() {
                        filter.byMLSymmetry = value.classification;
                      });
                      widget.onChange(ClassificationCategory.mlSymmetry,
                          value.classification);
                    },
                    choices: const [
                      ...settingChoices,
                      ...[anyClassification]
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Symmetry Hand Labeled'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomPopupMenuButton(
                    classification: filter.byHandLabeledSymmetry,
                    iconData: Icons.person,
                    onSelected: (value) {
                      setState(() {
                        filter.byHandLabeledSymmetry = value.classification;
                      });
                      widget.onChange(ClassificationCategory.handLabelSymmetry,
                          value.classification);
                    },
                    choices: const [
                      ...settingChoices,
                      ...[anyClassification]
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Single ML'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomPopupMenuButton(
                    classification: filter.byMLSingle,
                    iconData: Icons.settings,
                    onSelected: (value) {
                      setState(() {
                        filter.byMLSingle = value.classification;
                      });
                      widget.onChange(ClassificationCategory.mlSingle,
                          value.classification);
                    },
                    choices: const [
                      ...settingChoices,
                      ...[anyClassification]
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Single Hand Labeled'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomPopupMenuButton(
                    classification: filter.byHandLabeledSingle,
                    iconData: Icons.person,
                    onSelected: (value) {
                      setState(() {
                        filter.byHandLabeledSingle = value.classification;
                      });
                      widget.onChange(ClassificationCategory.handLabelSingle,
                          value.classification);
                    },
                    choices: const [
                      ...settingChoices,
                      ...[anyClassification]
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
*/
