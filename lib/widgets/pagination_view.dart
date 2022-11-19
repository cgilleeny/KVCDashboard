import 'package:flutter/material.dart';
import 'package:go_check_kidz_dashboard/data/model/page.dart';
import 'package:go_check_kidz_dashboard/widgets/rows_dec_inc.dart';

class PaginationView extends StatefulWidget {
  final List<EyepairPage> pages;
  final int pageIndex;
  final int rowsPerPage;
  final Function(int pageIndex) onChangePage;
  final Function(int rowsPerPage) onChangeRowsPerPage;
  const PaginationView(
      {required this.pages,
      required this.pageIndex,
      required this.rowsPerPage,
      required this.onChangePage,
      required this.onChangeRowsPerPage,
      Key? key})
      : super(key: key);

  @override
  State<PaginationView> createState() => _PaginationViewState();
}

class _PaginationViewState extends State<PaginationView> {
  bool hasNextPage() {
    if (widget.pageIndex + 1 < widget.pages.length) {
      return true;
    }
    if (widget.pages[widget.pageIndex].nextPartitionKey == null ||
        widget.pages[widget.pageIndex].nextRowKey == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('widget.rowsPerPage: ${widget.rowsPerPage}');
    return
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child:
        Container(
      // color: Colors.amber,
      width: double.infinity,
      // height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: RowsDecInc(
                widget.rowsPerPage,
                widget.onChangeRowsPerPage,
                label: 'Rows Per Page',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: IconButton(
              onPressed: widget.pageIndex == 0
                  ? null
                  : () {
                      widget.onChangePage(widget.pageIndex - 1);
                    },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: IconButton(
              onPressed: !hasNextPage()
                  ? null
                  : () {
                      widget.onChangePage(widget.pageIndex + 1);
                    },
              icon: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
    // );
  }
}
