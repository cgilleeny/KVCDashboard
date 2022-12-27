import 'package:flutter/material.dart';

class RowsDecInc extends StatefulWidget {
  int numberOfRows;
  final String label;
  final Function(int rowsPerPage) onChangeRows;

  RowsDecInc(this.numberOfRows, this.onChangeRows, {this.label = ''});

  @override
  State<RowsDecInc> createState() => _RowsDecIncState();
}

class _RowsDecIncState extends State<RowsDecInc> {
  late TextEditingController controller;
  // double? iconHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController(text: widget.numberOfRows.toString());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   iconHeight = context.size != null ? context.size!.height / 2 : 58 / 2;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print('widget.numberOfRows: ${widget.numberOfRows}');
    return
        // Container(
        // child:
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.label.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(widget.label),
              )
            : null,
        SizedBox(
          width: 70,
          height: 50,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            onSubmitted: (text) {
              widget.onChangeRows(int.parse(text));
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: theme.primaryColor,
                ), //<-- SEE HERE
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: theme.primaryColor, width: 2),
                right: BorderSide(color: theme.primaryColor, width: 2),
                bottom: BorderSide(color: theme.primaryColor, width: 1),
              )),
              height: 25,
              width: 25,
              child: IconButton(
                onPressed: () {
                  widget.onChangeRows(widget.numberOfRows + 1);
                  setState(() {
                    controller.text = (widget.numberOfRows + 1).toString();
                  });
                },
                icon: const Icon(
                  Icons.add,
                  size: 10,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.primaryColor, width: 1),
                  right: BorderSide(color: theme.primaryColor, width: 2),
                  bottom: BorderSide(color: theme.primaryColor, width: 2),
                ),
              ),
              height: 25,
              width: 25,
              child: IconButton(
                onPressed: () {
                  widget.onChangeRows(widget.numberOfRows - 1);
                                    setState(() {
                    controller.text = (widget.numberOfRows + 1).toString();
                  });
                },
                icon: const Icon(
                  Icons.remove,
                  size: 10,
                ),
              ),
            )
          ],
        ),
        // )
      ].whereType<Widget>().toList(),
    );
    // );
  }
}
