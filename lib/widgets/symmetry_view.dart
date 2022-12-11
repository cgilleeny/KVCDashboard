import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/widgets/popup_menu_button.dart';

import '../UI/shared/basic_dialog.dart';
import '../cubit/eyepair_cubit.dart';
import '../data/model/classification.dart';
import '../data/model/eyepair.dart';
import '../enums/dialog_type.dart';

class SymmetryView extends StatelessWidget {
  final EyePair eyepair;
  final void Function(Classification classification) onUpdateHumanLabel;

  const SymmetryView(this.eyepair, this.onUpdateHumanLabel, {Key? key})
      : super(key: key);

  void _showErrorDiaog(BuildContext context, String errorMessage) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return BasicDialog(
              BasicDialogType.error,
              Text(
                'Updating hand labeled symmetry value failed: $errorMessage',
              ),
              buttonsDef: [DialogButton('Continue', true)]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EyepairCubit, EyepairState>(
      listener: (listenerContext, state) async {
        if (state is EyepairUpdated) {
          eyepair.symmetryHumanLabel = toClassification(state.classification);
        }
        if (state is EyepairUpdateError) {
          _showErrorDiaog(context, state.errorDescription);
        }
      },
      child: BlocBuilder<EyepairCubit, EyepairState>(builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Symmetry',
                    textAlign: TextAlign.center,
                  ),
                ),
                ClassificationPopupMenuButton(
                  classification: eyepair.symmetryHumanLabel,
                  iconData: Icons.person,
                  onSelected: (choice) {
                    if (eyepair.symmetryHumanLabel != choice.classification) {
                      Map<String, dynamic> map = {
                        "right_human_label":
                            fromClassification(choice.classification)
                      };
                      BlocProvider.of<EyepairCubit>(context)
                          .updateEyepair(eyepair.rowKey, map);
                    }
                  },
                ),
                ButtonView(
                  icon: const Icon(Icons.contrast),
                  choice: settingChoices[eyepair.statusSymmetry.index],
                ),
              ],
            ),
            if (state is EyepairUpdating)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }
}