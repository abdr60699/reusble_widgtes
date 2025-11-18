import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgendaItem {
  final DateTime start;
  final DateTime end;
  final String title;
  final String? description;
  AgendaItem({required this.start, required this.end, required this.title, this.description});
}

class ReusableAgenda extends StatelessWidget {
  final List<AgendaItem> items;

  const ReusableAgenda({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<AgendaItem>>{};
    for (var it in items) {
      final key = DateFormat.yMMMMd().format(it.start);
      grouped.putIfAbsent(key, ()=>[]).add(it);
    }
    final keys = grouped.keys.toList()..sort((a,b)=>a.compareTo(b));
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, idx) {
        final day = keys[idx];
        final list = grouped[day]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical:8,horizontal:12), child: Text(day, style: TextStyle(fontWeight: FontWeight.bold))),
            ...list.map((it)=>ListTile(
              title: Text(it.title),
              subtitle: Text('${DateFormat.Hm().format(it.start)} - ${DateFormat.Hm().format(it.end)}\n${it.description ?? ''}'),
            ))
          ],
        );
      },
    );
  }
}
