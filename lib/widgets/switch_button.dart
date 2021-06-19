import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  SwitchButton({
    Key key,
    @required this.notifier,
  }) : super(key: key);

  final ValueNotifier<bool> notifier;

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;
  final double width = 32;
  final double radius = 19;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: width - radius)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              if (_controller.isCompleted) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
              widget.notifier.value = !widget.notifier.value;
            },
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: 38,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width,
                      height: 13,
                      decoration: BoxDecoration(
                        color: (widget.notifier.value)
                            ? Theme.of(context).accentColor
                            : Theme.of(context).focusColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: _animation.value,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: radius,
                      width: radius,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: radius,
                          width: radius,
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
