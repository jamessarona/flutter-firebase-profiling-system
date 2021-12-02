import 'package:flutter/material.dart';
import 'package:tanod_apprehension/shared/constants.dart';

class MyReportCard extends StatelessWidget {
  const MyReportCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url =
        "https://scontent.fceb1-2.fna.fbcdn.net/v/t1.15752-9/262501487_600481991261895_6657576791388492822_n.jpg?_nc_cat=108&ccb=1-5&_nc_sid=ae9488&_nc_eui2=AeGLfAgYOwjWSU7I7PdN6aLRUlGyQAFmrtBSUbJAAWau0AwTNgCcxivLG0-lO7U4kysSpa9XX2-gzrcBI3vLfTmx&_nc_ohc=KhiTtW4aTRwAX9HqEcL&_nc_ht=scontent.fceb1-2.fna&oh=08b9589cb4d89e045c8ec7e926d7ed32&oe=61CD9F94";

    Size screenSize = MediaQuery.of(context).size;
    return Card(
      child: Container(
        padding: EdgeInsets.only(
          top: 7,
        ),
        width: screenSize.width < 450 ? screenSize.width * .47 : 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 145,
              width: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    url,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 4,
              ),
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "15min ago",
                          style: tertiaryText.copyWith(fontSize: 14),
                        ),
                        Container(
                          width: 10,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        )
                      ],
                    ),
                  ),
                  Text(
                    "Silver Street San Rafael Davao City asd as dsad asd sa asd asd sad as",
                    style: tertiaryText.copyWith(fontSize: 13),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 10,
                  )
                ],
              ),
            ),
            Container(
              width: 170,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 85,
                    // child: MyButton(
                    //   name: 'Buy Now',
                    //   color: Colors.green,
                    //   onPressed: onPressedBuy,
                    // ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: screenSize.width * .01),
                    width: 70,
                    // child: MyButton(
                    //   name: 'Cart',
                    //   color: customColors[30],
                    //   onPressed: onPressedCart,
                    // ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
