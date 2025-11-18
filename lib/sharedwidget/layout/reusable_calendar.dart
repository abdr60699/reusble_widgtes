import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReusableCalendar extends StatelessWidget {
  final DateTime month;
  final void Function(DateTime)? onDayTap;

  ReusableCalendar({Key? key, DateTime? month, this.onDayTap}) : month = month ??  DateTime.now(), super(key: key);

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month+1, 0).day;
    final weekdayOffset = first.weekday % 7; // make Sunday=0
    final totalCells = weekdayOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final days = List<DateTime?>.generate(rows*7, (i) {
      final dayIndex = i - weekdayOffset + 1;
      if (dayIndex < 1 || dayIndex > daysInMonth) return null;
      return DateTime(month.year, month.month, dayIndex);
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical:8.0),
          child: Text(DateFormat.yMMMM().format(month), style: Theme.of(context).textTheme.titleMedium),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:7, childAspectRatio:1.2),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            if (day == null) return SizedBox.shrink();
            final isToday = DateTime.now().day==day.day && DateTime.now().month==day.month && DateTime.now().year==day.year;
            return InkWell(
              onTap: ()=> onDayTap?.call(day),
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(color: isToday? Colors.blue[100] : null, borderRadius: BorderRadius.circular(6)),
                child: Center(child: Text('${day.day}')),
              ),
            );
          },
        )
      ],
    );
  }
}
