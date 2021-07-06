import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wave_widget.dart';
import 'config.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Test',
      debugShowCheckedModeBanner: false,
      home: WaveScreen(),
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
