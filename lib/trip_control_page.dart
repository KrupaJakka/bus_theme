import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TripControlPage extends StatefulWidget {
  const TripControlPage({super.key});
  @override
  State<TripControlPage> createState() => _TripControlPageState();
}

class _TripControlPageState extends State<TripControlPage> {
  bool _tripOn = false;

  void _toggleTrip() {
    setState(() => _tripOn = !_tripOn);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _tripOn
              ? 'Trip started – students can now track you.'
              : 'Trip ended.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: call backend to start / stop streaming location
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Control')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Illustrative SVG
            SvgPicture.asset(
              _tripOn
                  ? 'assets/svg/route_active.svg'
                  : 'assets/svg/route_idle.svg',
              height: 180,
            ),
            const SizedBox(height: 32),
            // Status Card
            Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _tripOn ? Icons.play_circle : Icons.stop_circle,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _tripOn ? 'Trip In Progress' : 'Trip Stopped',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _tripOn
                          ? 'Students & parents can see your live location.'
                          : 'Press START when you begin the route.',
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _tripOn ? cs.error : cs.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _toggleTrip,
              icon: Icon(_tripOn ? Icons.stop : Icons.play_arrow),
              label: Text(_tripOn ? 'End Trip' : 'Start Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
