import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/model/filter.dart';

class DateFilterSelector extends StatefulWidget {
  final DateFilter dateFilter;
  final DateTimeRange? range;
  final Function(DateTimeRange? newRange, DateFilter newDateFilter)
      onChange;

  const DateFilterSelector(this.dateFilter, this.range, this.onChange);

  @override
  State<DateFilterSelector> createState() => _DateFilterSelectorState();
}

class _DateFilterSelectorState extends State<DateFilterSelector> {
  late DateFilter dateFilter;
  DateTimeRange? range;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateFilter = widget.dateFilter;
    range = widget.range;
  }

  void _pickRange(BuildContext context) async {
    final newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now().add(const Duration(
          days: -(365 * 5),
        )),
        lastDate: DateTime.now(),
        initialDateRange: range,
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450.0,
                ),
                child: child,
              )
            ],
          );
        });
    if (newDateRange != null) {
      setState(() {
        range = newDateRange;
      });
      widget.onChange(newDateRange, DateFilter.custom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Filter By Date',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // ),
                ),
              
              Row(
            children: [
              dateFilter == DateFilter.custom
                  ? IconButton(
                      onPressed: () => _pickRange(context),
                      icon: const Icon(Icons.date_range_outlined),
                      iconSize: 40,
                    )
                  : null,
              range != null
                  ? Padding(
                      padding: const EdgeInsets.all(8,),
                      child: Text(
                          '${DateFormat("MM-dd-yyyy").format(range!.start)} - ${DateFormat("MM-dd-yyyy").format(range!.end)}'),
                    )
                  : null,
            ].whereType<Widget>().toList(),
          ),
          RadioListTile<DateFilter>(
            title: Text(DateFilter.today.title),
            value: DateFilter.today,
            groupValue: dateFilter,
            dense: true,
            onChanged: (DateFilter? value) {
              if (value == null) {
                return;
              }
              final now = DateTime.now();
    
              final newRange = DateTimeRange(
                end: now,
                start: DateTime(now.year, now.month, now.day),
              );
              setState(() {
                dateFilter = value;
                range = newRange;
              });
              widget.onChange(newRange, value);
            },
          ),
          RadioListTile<DateFilter>(
            title: Text(DateFilter.thisWeek.title),
            value: DateFilter.thisWeek,
            groupValue: dateFilter,
            dense: true,
            onChanged: (DateFilter? value) {
              if (value == null) {
                return;
              }
    
              final now = DateTime.now();
              int currentDay = now.weekday;
              final start = now.subtract(Duration(days: currentDay));
              final newRange = DateTimeRange(
                end: now,
                start: DateTime(start.year, start.month, start.day),
              );
              setState(() {
                dateFilter = value;
                range = newRange;
              });
              widget.onChange(newRange, value);
            },
          ),
          RadioListTile<DateFilter>(
            title: Text(DateFilter.thisMonth.title),
            value: DateFilter.thisMonth,
            groupValue: dateFilter,
            dense: true,
            onChanged: (DateFilter? value) {
              if (value == null) {
                return;
              }
              final now = DateTime.now();
              final newRange = DateTimeRange(
                end: now,
                start: DateTime(now.year, now.month, 1),
              );
              setState(() {
                dateFilter = value;
                range = newRange;
              });
              widget.onChange(newRange, value);
            },
          ),
          RadioListTile<DateFilter>(
            title: Text(DateFilter.thisYear.title),
            value: DateFilter.thisYear,
            groupValue: dateFilter,
            dense: true,
            onChanged: (DateFilter? value) {
              if (value == null) {
                return;
              }
              final now = DateTime.now();
              final newRange = DateTimeRange(
                end: now,
                start: DateTime(now.year, 1, 1),
              );
              setState(() {
                dateFilter = value;
                range = newRange;
              });
              widget.onChange(newRange, value);
            },
          ),
          RadioListTile<DateFilter>(
            title: Text(DateFilter.custom.title),
            value: DateFilter.custom,
            groupValue: dateFilter,
            dense: true,
            onChanged: (DateFilter? value) async {
              if (value == null) {
                return;
              }
              setState(() {
                dateFilter = value;
              });
              _pickRange(context);
            },
          ),
          RadioListTile<DateFilter>(
            title: Text(DateFilter.none.title),
            value: DateFilter.none,
            groupValue: dateFilter,
            dense: true,
            onChanged: (DateFilter? value) {
              if (value == null) {
                return;
              }
              setState(() {
                dateFilter = value;
                range = null;
              });
              widget.onChange(null, value);
            },
          ),
        ],
    );
  }
}
