import 'package:flutter/material.dart';

class ReusableReviewCard extends StatelessWidget {
  final String reviewer;
  final String date;
  final String review;
  final int rating; // 1..5

  const ReusableReviewCard({Key? key, required this.reviewer, required this.date, required this.review, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(reviewer, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: TextStyle(color: Colors.grey, fontSize:12)),
        ]),
        SizedBox(height:8),
        Row(children: List.generate(5, (i) => Icon(i<rating? Icons.star : Icons.star_border, size:16, color: Colors.amber))),
        SizedBox(height:8),
        Text(review)
      ])),
    );
  }
}
