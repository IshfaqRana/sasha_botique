import 'package:flutter/material.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/auth/presentation/pages/signup.dart';

import '../../../../shared/widgets/custom_app_button.dart';
import '../../../splash/presentation/widgets/splash_logo.dart';
import 'login.dart';


class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned(
          //   top: -100,
          //   left: -50,
          //   child: CustomPaint(
          //     size: Size(200, 200),
          //     painter: TopCurvePainter(),
          //   ),
          // ),
          // Positioned(
          //   bottom: -100,
          //   right: -50,
          //   child: CustomPaint(
          //     size: Size(200, 200),
          //     painter: BottomCurvePainter(),
          //   ),
          // ),
          // Main content
          SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(image: DecorationImage(
                image: AssetImage('assets/images/welcome.png'),
                fit: BoxFit.cover,
                colorFilter:
                ColorFilter.mode(Colors.black.withOpacity(0.1),
                    BlendMode.dstATop),

              ),
              // color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 120),
                    Text(
                      "SASHA'S",
                      style: context.headlineLarge?.copyWith(fontSize: 40),
                    ),
                    SizedBox(height: 130),
              
                    Text(
                      'Create your fashion\nin your own way',
                      textAlign: TextAlign.center,
                      style: context.headlineLarge?.copyWith(fontSize: 24),
              
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Each women has their own style. We help you to\ncreate your unique style.',
                      textAlign: TextAlign.center,
                      style: context.titleSmall?.copyWith(fontSize: 14),
              
                    ),
                    SizedBox(height: 48),
                    CustomButton(
                      width: 200,
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
                      },
                      text: 'LOG IN',
                        foregroundColor: Colors.black, backgroundColor: Colors.white,
                      textStyle: context.headlineLarge?.copyWith(fontSize: 12),
              
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 110.0),
                      child:  Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR',style: context.headlineMedium?.copyWith(fontSize: 14),),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      width: 200,
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>  SignupScreen()));
                      },
                      text: 'REGISTER',
              
                        foregroundColor: Colors.white, backgroundColor: Colors.black,
                      textStyle: context.headlineLarge?.copyWith(fontSize: 12,color:  Colors.white),
              
              
              
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for top curve
class TopCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width,
      size.height * 0.25,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for bottom curve
class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      0,
      size.height * 0.75,
    );
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}