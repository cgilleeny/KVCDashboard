import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_check_kidz_dashboard/widgets/popup_menu_button.dart';

import '../data/model/classification.dart';
import '../data/model/eye.dart';

class ClassificationView extends StatelessWidget {
  final Eye eye;
  final void Function(Classification classification) onUpdateHumanLabel;

  const ClassificationView(
    this.eye,
    this.onUpdateHumanLabel,
  {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClassificationPopupMenuButton(
            classification: eye.humanLabel,
            iconData: Icons.person,
            onSelected: (choice) {
              if (kDebugMode) {
                print(choice.name);
              }
              // widget.eye.humanLabel = choice.classification;
              onUpdateHumanLabel(choice.classification);
            }),
        ButtonView(
          icon: const Icon(Icons.settings),
          choice: settingChoices[eye.mlResult.index],
        ),
        Row(
          children: [
            Expanded(
              child: ButtonView(
                icon: const Icon(Icons.thumb_up),
                choice: Choice(
                  name: eye.mlConfidenceNormal != null
                      ? eye.mlConfidenceNormal!.toStringAsFixed(2)
                      : "?.???",
                  classification: Classification.ok,
                  color: settingChoices[0].color,
                ),
              ),
            ),
            Expanded(
              child: ButtonView(
                icon: const Icon(Icons.thumb_down),
                choice: Choice(
                  name: eye.mlConfidenceAbnormal != null
                      ? eye.mlConfidenceAbnormal!.toStringAsFixed(2)
                      : "?.???",
                  classification: Classification.refer,
                  color: settingChoices[1].color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}