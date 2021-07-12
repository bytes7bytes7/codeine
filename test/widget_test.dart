import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wave_widget.dart';
import 'config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        splashColor: const Color(0xFF167F67),
      ),
      home: ChangeRaisedButtonColor(),
    );
  }
}

class ChangeRaisedButtonColor extends StatefulWidget {
  @override
  ChangeRaisedButtonColorState createState() => ChangeRaisedButtonColorState();
}

class ChangeRaisedButtonColorState extends State<ChangeRaisedButtonColor>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _xTween;
  Animation<double> _yTween;
  Animation<double> _radiusTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _xTween = Tween<double>(begin: 1.0, end: 0).animate(_animationController);
    _yTween = Tween<double>(begin: -1.0, end: 0).animate(_animationController);
    _radiusTween = Tween<double>(begin: 2, end: 0.5).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _xTween,
        builder: (context, child) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFF13AD3),
                  Color(0x0063BAC4),
                ],
                center: Alignment(_xTween.value, _yTween.value),
                radius: _radiusTween.value,
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.color_lens_outlined),
              onPressed: () {
                if (_animationController.status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class WaveScreen extends StatefulWidget {
  static String tag = '/WaveScreen';

  @override
  WaveScreenState createState() => WaveScreenState();
}

class WaveScreenState extends State<WaveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wave Widget"),
      ),
      body: WaveWidget(
        config: CustomConfig(
          gradients: [
            [Color(0xFF34B0A9), Color(0xFF34B0A9)],
            [Color(0xFF34B0A9), Color(0xFF34B0A9)],
          ],
          durations: [15000, 11500],
          heightPercentages: [0.20, 0.22],
          blur: MaskFilter.blur(BlurStyle.solid, 10),
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
        waveAmplitude: 0,
        backgroundColor: Colors.white,
        size: Size(double.infinity, double.infinity),
      ),
    );
  }
}
