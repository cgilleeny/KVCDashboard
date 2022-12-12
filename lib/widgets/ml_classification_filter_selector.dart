import 'package:flutter/material.dart';

import '../data/model/classification.dart';
import '../data/model/filter.dart';
import './popup_menu_button.dart';

enum MLClassificationCategory {
  mlSymmetry,
  mlSingle,
}

class MLClassificationFilterSelector extends StatefulWidget {
  final Filter filter;
  final Function(MLClassificationCategory newMLClassificationCategory,
      Classification newClassification) onChange;

  const MLClassificationFilterSelector(this.filter, this.onChange, {Key? key}) : super(key: key);

  @override
  State<MLClassificationFilterSelector> createState() =>
      _MLClassificationFilterSelectorState();
}

class _MLClassificationFilterSelectorState
    extends State<MLClassificationFilterSelector> {
  // late Filter filter;
  late Classification mlSingle;
  late Classification mlSymmetry;

  @override
  void initState() {
    super.initState();
    // filter = widget.filter;
    mlSingle = widget.filter.byMLSingle;
    mlSymmetry = widget.filter.byMLSymmetry;
  }

  @override
  void didUpdateWidget(covariant MLClassificationFilterSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      mlSingle = widget.filter.byMLSingle;
      mlSymmetry = widget.filter.byMLSymmetry;
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
            'Filter By ML Classification',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Symmetry - ML'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ClassificationPopupMenuButton(
            classification: mlSymmetry,
            iconData: Icons.contrast,
            onSelected: (value) {
              setState(() {
                mlSymmetry = value.classification;
              });
              widget.onChange(
                  MLClassificationCategory.mlSymmetry, value.classification);
            },
            choices: const [
              ...settingChoices,
              ...[anyClassification]
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Single Detection - ML'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ClassificationPopupMenuButton(
            classification: mlSingle,
            iconData: Icons.visibility,
            onSelected: (value) {
              setState(() {
                mlSingle = value.classification;
              });
              widget.onChange(
                  MLClassificationCategory.mlSingle, value.classification);
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
