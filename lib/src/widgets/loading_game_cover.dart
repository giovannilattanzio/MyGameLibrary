import 'package:flutter/material.dart';

class LoadingGameCover extends StatelessWidget {
  final double width;
  final double height;

  LoadingGameCover({
    this.width = 50.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
    );
  }
}
