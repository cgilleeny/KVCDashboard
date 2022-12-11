import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import '../data/model/eyepair.dart';

class PopoverButton extends StatelessWidget {
  final EyePair eyePair;

  const PopoverButton(this.eyePair, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String rowKey = eyePair.rowKey ?? 'unknown';

    return ActionChip(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
      labelPadding:
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
      avatar: const CircleAvatar(
        backgroundColor: Colors.white70,
        child: Icon(Icons.question_mark_rounded),
      ),
      label: const Text(
        'ID',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
      onPressed: () {
        showPopover(
          context: context,
          transitionDuration: const Duration(milliseconds: 150),
          bodyBuilder: (context) => Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(eyePair.rowKey, style: const TextStyle(fontSize: 12.0)),
            ),
          ),
          direction: PopoverDirection.bottom,
          width: 340,
          height: 45,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
    );
  }
}
