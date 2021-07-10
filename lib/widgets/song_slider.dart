import 'package:flutter/material.dart';

class SongSlider extends StatelessWidget {
  const SongSlider({
    Key key,
    @required this.firstColor,
    @required this.secondColor,
  }) : super(key: key);

  final Color firstColor;
  final Color secondColor;

  @override
  Widget build(BuildContext context) {
    double progress = 0.3;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: Stack(
            children: [
              Container(
                height: 10,
              ),
              Positioned(
                top: 3.5,
                child: Container(
                  width: constraints.maxWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Positioned(
                top: 3.5,
                child: Container(
                  width: constraints.maxWidth * progress,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      colors: [
                        firstColor,
                        secondColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * progress,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: secondColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
