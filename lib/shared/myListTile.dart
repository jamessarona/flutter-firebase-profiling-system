import 'package:flutter/material.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class MyReportAvailabilityTile extends StatelessWidget {
  final Color color;
  final String title;
  final int count;
  const MyReportAvailabilityTile(
      {required this.color, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: screenSize.width / 20),
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: color,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: tertiaryText.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 14,
              ),
            ),
            Container(
              height: 3,
            ),
            Text(
              '$count reports available',
              style: tertiaryText.copyWith(
                color: Colors.grey,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )
      ],
    );
  }
}
