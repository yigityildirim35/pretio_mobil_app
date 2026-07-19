import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/main_scaffold.dart';
import '../../providers/theme_provider.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  String _status = 'Hazırlanıyor...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startCriticalInitialization();
  }

  Future<void> _startCriticalInitialization() async {
    try {
      // Step 1: Fast Local Storage Read
      setState(() {
        _progress = 0.2;
        _status = 'Tema yükleniyor...';
      });

      await Provider.of<ThemeProvider>(context, listen: false).loadTheme();

      setState(() {
        _progress = 0.5;
        _status = 'Veritabanı kontrol ediliyor...';
      });

      // Step 2: Placeholder for fast DB init or essential local files
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _progress = 0.8;
        _status = 'Uygulama başlatılıyor...';
      });

      // Step 3: Remote Config / Async Checks with Timeout
      await _fetchRemoteConfigWithTimeout();

      setState(() => _progress = 1.0);

      // Step 4: Navigate to Main App
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScaffold(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _status = 'Çevrimdışı modda başlatılıyor...');
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScaffold()),
        );
      }
    }
  }

  Future<void> _fetchRemoteConfigWithTimeout() async {
    try {
      // Simulate checking remote toggles or critical auth state.
      // If it takes more than 3 seconds, we abort and just launch the app.
      await Future.delayed(
        const Duration(milliseconds: 400),
      ).timeout(const Duration(seconds: 3));
    } on TimeoutException {
      debugPrint('Remote config timed out. Continuing offline.');
    } catch (e) {
      debugPrint('Remote config failed: $e. Continuing offline.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match white background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ogol.png',
              width: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            Text(
              _status,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFFEBF4DD), // Light green loading bar
                  minHeight: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
