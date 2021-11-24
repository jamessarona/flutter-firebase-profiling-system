import 'package:flutter/material.dart';

class BuildDrawerMenuHeader extends StatelessWidget {
  final String image;
  final String name;
  final String email;
  final String contact;
  const BuildDrawerMenuHeader(
      {required this.image,
      required this.name,
      required this.email,
      required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(image),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                email,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                contact,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
          ),
          Spacer(),
          CircleAvatar(
            radius: 24,
            backgroundColor: Color.fromARGB(30, 60, 168, 1),
            child: Icon(
              Icons.add_comment_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class BuildDrawerMenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  const BuildDrawerMenuItem({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap: () {},
    );
  }
}
