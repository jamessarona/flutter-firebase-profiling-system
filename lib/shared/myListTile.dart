import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class MyDocumentationListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String location;
  final String date;
  final String fine;
  final bool isTagged;
  const MyDocumentationListTile({
    required this.onTap,
    required this.location,
    required this.date,
    required this.fine,
    required this.isTagged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        height: 25,
        width: 25,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Icon(
          isTagged
              ? FontAwesomeIcons.checkCircle
              : FontAwesomeIcons.timesCircle,
          size: 20,
          color: Colors.black,
        ),
      ),
      title: Text(
        location,
        style: tertiaryText.copyWith(
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        "${setDateTime(date, 'Time')} / ${setDateTime(date, 'Date')}",
        style: tertiaryText.copyWith(
          fontSize: 13,
          color: Colors.grey[700],
        ),
      ),
      trailing: Text('₱$fine'),
    );
  }
}
