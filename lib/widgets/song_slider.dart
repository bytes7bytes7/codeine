import 'package:flutter/material.dart';

class SongSlider extends StatelessWidget {
  SongSlider({
    Key key,
    @required this.horizontalPadding,
    @required this.firstColor,
    @required this.secondColor,
  }) : super(key: key);

  final double horizontalPadding;
  final Color firstColor;
  final Color secondColor;
  final ValueNotifier<double> progress = ValueNotifier(0.0);
  final double diameter = 10.0;

  void updateProgress(double x, BoxConstraints constraints) {
    // if (constraints.maxWidth - x < diameter) {
    //   x = constraints.maxWidth - diameter;
    // }
    progress.value = x / constraints.maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Listener(
              onPointerUp: (PointerEvent details) {
                updateProgress(details.localPosition.dx, constraints);
              },
              child: Container(
                alignment: Alignment.center,
                height: diameter * 2,
                width: constraints.maxWidth,
                color: Colors.transparent,
                child: Container(
                  height: 3,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, percent, child){
                return Positioned(
                  child: Listener(
                    onPointerUp: (PointerEvent details) {
                      updateProgress(details.localPosition.dx, constraints);
                    },
                    child: Container(
                      height: 3,
                      width: constraints.maxWidth * progress.value,
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
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, value, child) {
                return Positioned(
                  left: constraints.maxWidth * progress.value,
                  child: Listener(
                    onPointerUp: (PointerEvent details) {
                      updateProgress(
                          details.position.dx - horizontalPadding, constraints);
                    },
                    child: Draggable(
                      data: 0,
                      axis: Axis.horizontal,
                      childWhenDragging: SizedBox.shrink(),
                      child: Container(
                        height: diameter,
                        width: diameter,
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
                      feedback: Container(
                        height: diameter,
                        width: diameter,
                        decoration: BoxDecoration(
                          color: Theme.of(context).focusColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: secondColor,
                              spreadRadius: 5,
                              blurRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
