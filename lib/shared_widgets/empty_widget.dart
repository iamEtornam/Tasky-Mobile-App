import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final String imageAsset;

  const EmptyWidget({Key key,@required this.message,@required this.imageAsset}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/$imageAsset',
            width: size.width / 2,
            height: size.width / 2,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
