import 'package:flutter/material.dart';

class LeaderboardEntry {
  final String name;
  final int score;
  LeaderboardEntry(this.name, this.score);
}

class ReusableLeaderboard extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final int topN;

  const ReusableLeaderboard({Key? key, required this.entries, this.topN = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sorted = List<LeaderboardEntry>.from(entries)..sort((a,b)=>b.score.compareTo(a.score));
    final showing = sorted.take(topN).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: List.generate(showing.length, (i) {
            final e = showing[i];
            return ListTile(
              leading: CircleAvatar(child: Text('${i+1}')),
              title: Text(e.name),
              trailing: Text(e.score.toString()),
            );
          }),
        ),
      ),
    );
  }
}
