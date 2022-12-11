import 'package:flutter/material.dart';
import '../../enums/dialog_type.dart';

class DialogButton {
  final String title;
  final bool returnValue;
  void Function()? onPressed;

  DialogButton(this.title, this.returnValue, {this.onPressed});
}

class BasicDialog extends StatefulWidget {
  final BasicDialogType type;
  final Widget content;
  final List<DialogButton> buttonsDef;

  const BasicDialog(this.type, this.content,
      {this.buttonsDef = const [], Key? key})
      : super(key: key);

  @override
  State<BasicDialog> createState() => _BasicDialogState();
}

class _BasicDialogState extends State<BasicDialog> {
  late List<Widget> buttonWidgets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonWidgets = List.generate(
      widget.buttonsDef.length,
      (index) => TextButton(
        onPressed: widget.buttonsDef[index].onPressed ??
            () =>
                Navigator.of(context).pop(widget.buttonsDef[index].returnValue),
        child: Text(widget.buttonsDef[index].title, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
              insetPadding: const EdgeInsets.all(24),
              backgroundColor: Colors.transparent,
              child: _BasicDialogContent(
                widget.type,
                widget.content,
                buttonWidgets,
              ),
            );
  }
}

class _BasicDialogContent extends StatelessWidget {
  final BasicDialogType type;
  final Widget content;
  final List<Widget> buttonWidgets;

  const _BasicDialogContent(this.type, this.content, this.buttonWidgets,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 0.04 * screenSize.width,
          ),
          padding: const EdgeInsets.only(
            top: 32,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              24,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 20,
                ),
                Text(type.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(
                  width: double.infinity,
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: content,
                    // child: Container(constraints: BoxConstraints(maxHeight: screenSize.height - 100), child: content),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: buttonWidgets,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: -28,
            child: CircleAvatar(
              minRadius: 16,
              maxRadius: 28,
              backgroundColor: type.color,
              child: Icon(
                type.icon,
                size: 28,
                color: Colors.white,
              ),
            ))
      ],
    );
  }
}
