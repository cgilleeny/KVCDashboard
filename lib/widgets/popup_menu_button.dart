import 'package:flutter/material.dart';

import '../data/model/classification.dart';



const List<Choice> settingChoices = <Choice>[
  Choice(
      name: 'Pass',
      classification: Classification.ok,
      color: Color.fromRGBO(112, 222, 61, 0.75)),
  Choice(
      name: 'Refer',
      classification: Classification.refer,
      color: Color.fromRGBO(242, 30, 30, 0.75)),
  Choice(
      name: 'Error',
      classification: Classification.error,
      color: Color.fromRGBO(223, 121, 5, 0.75)),
  Choice(
    name: 'Unprocessed',
    classification: Classification.unprocessed,
    color: Color.fromRGBO(249, 232, 79, 0.75),
  ),
];

const anyClassification = Choice(
  name: 'All',
  classification: Classification.any,
  color: Colors.white,
);

class Choice {
  final String name;
  final Classification classification;
  final Color color;

  const Choice({required this.name, required this.classification, required this.color});
}

class CustomPopupMenuButton extends StatefulWidget {
  final Classification classification;
  // final Choice choice;
  final IconData iconData;
  final List<Choice> choices;
  final void Function(Choice) onSelected;

  const CustomPopupMenuButton(
      {required this.classification,
      // required this.choices,
      required this.iconData,
      required this.onSelected,
      this.choices = settingChoices});

  @override
  State<CustomPopupMenuButton> createState() => _CustomPopupMenuButtonState();
}

class _CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  // late Choice _selectedOption;

  @override
  Widget build(BuildContext context) {
    return
        // ignore: dead_code

        PopupMenuButton<Choice>(
            elevation: 20,
            color: Colors.transparent,
            onSelected: (value) {
              // setState(() {
              //   _selectedOption = value;
              // });
              widget.onSelected(value);
            },
            itemBuilder: (BuildContext context) {
              return widget.choices.skip(0).map((Choice choice) {
                return CustomPopupMenuItem<Choice>(
                  key: const Key('key'),
                  value: choice,
                  color: choice.color,
                  child: Text(
                    choice.name,
                    style: TextStyle(fontSize: 12.0)
                  ),
                );
              }).toList();
            },
            child: ButtonView(
              icon: Icon(
                widget.iconData,
              ),
              choice: widget.choices[widget.classification.index],
            ));
  }
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final Color color;

  const CustomPopupMenuItem({
    required Key key,
    required T value,
    bool enabled = true,
    required Widget child,
    required this.color,
  }) : super(
          key: key,
          value: value,
          enabled: enabled,
          child: child,
        );

  @override
  _CustomPopupMenuItemState<T> createState() => _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        color: widget.color,
        child: super.build(context),
      ),
    );
  }
}

class ButtonView extends StatelessWidget {
  final Icon icon;
  final Choice choice;
  double width;
  // final String title;
  // final Color color;
  ButtonView({required this.icon, required this.choice, this.width = 170});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: choice.color,
      width: width,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: icon,
          ),
          Text(
            choice.name,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12.0)
          ),
        ],
      ),
    );
  }
}