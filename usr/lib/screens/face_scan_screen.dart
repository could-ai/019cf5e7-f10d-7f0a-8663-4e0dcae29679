import 'package:flutter/material.dart';
import 'dart:async';

class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    // Setup the scanning line animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Simulate the time it takes to process a face scan (3.5 seconds)
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        // Navigate to success screen after a brief pause
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/success');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background for camera view
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Face Recognition', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Mock Camera Viewport
                Container(
                  width: 280,
                  height: 380,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: _isScanning ? Colors.blueAccent : Colors.greenAccent, 
                      width: 3
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: (_isScanning ? Colors.blueAccent : Colors.greenAccent).withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ]
                  ),
                  child: Icon(
                    Icons.face,
                    size: 180,
                    color: _isScanning ? Colors.white38 : Colors.greenAccent.withOpacity(0.8),
                  ),
                ),
                
                // Scanning Animation Line
                if (_isScanning)
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: 20 + (_animationController.value * 340),
                        child: Container(
                          width: 260,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.8),
                                blurRadius: 12,
                                spreadRadius: 3,
                              )
                            ]
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Status Text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _isScanning ? 'Position your face within the frame...' : 'Face recognized successfully!',
                style: TextStyle(
                  color: _isScanning ? Colors.white : Colors.greenAccent, 
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
