import 'package:flutter/material.dart';

import '../data/model/classification.dart';
import '../data/model/filter.dart';
import './popup_menu_button.dart';

enum HandClassificationCategory {
  handLabelSymmetry,
  handLabelSingle,
}

class HandClassificationFilterSelector extends StatefulWidget {
  final Filter filter;
  final Function(HandClassificationCategory newHandClassificationCategory,
      Classification newClassification) onChange;

  const HandClassificationFilterSelector(this.filter, this.onChange);

  @override
  State<HandClassificationFilterSelector> createState() =>
      _HandClassificationFilterSelectorState();
}

class _HandClassificationFilterSelectorState
    extends State<HandClassificationFilterSelector> {
  // late Filter filter;
  late Classification handLabeledSingle;
  late Classification handLabeledSymmetry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // filter = widget.filter;
    handLabeledSingle = widget.filter.byHandLabeledSingle;
    handLabeledSymmetry = widget.filter.byHandLabeledSymmetry;
  }

  @override
  void didUpdateWidget(covariant HandClassificationFilterSelector oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      handLabeledSingle = widget.filter.byHandLabeledSingle;
      handLabeledSymmetry = widget.filter.byHandLabeledSymmetry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Filter By Labeled Classification',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Symmetry - Hand Labeled'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ClassificationPopupMenuButton(
            classification: handLabeledSymmetry,
            iconData: Icons.contrast,
            onSelected: (value) {
              setState(() {
                handLabeledSymmetry = value.classification;
              });
              widget.onChange(HandClassificationCategory.handLabelSymmetry,
                  value.classification);
            },
            choices: const [
              ...settingChoices,
              ...[anyClassification]
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Single Detection - Hand Labeled'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ClassificationPopupMenuButton(
            classification: handLabeledSingle,
            iconData: Icons.visibility,
            onSelected: (value) {
              setState(() {
                handLabeledSingle = value.classification;
              });
              widget.onChange(HandClassificationCategory.handLabelSingle,
                  value.classification);
            },
            choices: const [
              ...settingChoices,
              ...[anyClassification]
            ],
          ),
        ),
      ],
    );
  }
}
