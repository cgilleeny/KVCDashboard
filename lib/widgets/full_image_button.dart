import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:go_check_kidz_dashboard/widgets/full_image.dart';

import '../UI/shared/basic_dialog.dart';
import '../data/model/eyepair.dart';
import '../enums/dialog_type.dart';

class FullImageButton extends StatefulWidget {
  final EyePair eyepair;

  const FullImageButton(
    this.eyepair, {
    Key? key,
  }) : super(key: key);

  @override
  State<FullImageButton> createState() => _FullImageButtonState();
}

class _FullImageButtonState extends State<FullImageButton> {
  
  void _displayFullImage(BuildContext context, EyePair eyepair) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return BasicDialog(BasicDialogType.portrait, FullImage(eyepair),
            buttonsDef: [
              DialogButton(
                'Done',
                true,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ]);
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: IconButton(
          onPressed: widget.eyepair.rowKey != 'Unknown RowKey'
              ? () async {
                  _displayFullImage(context, widget.eyepair);
                }
              : null,
          iconSize: 45.0,
          icon: const Icon(Icons.portrait)),
    );
  }
}










