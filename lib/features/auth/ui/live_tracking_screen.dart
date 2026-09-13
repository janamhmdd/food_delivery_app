import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../domain/entities/order_record.dart';
import '../logic/orders_cubit.dart';
import 'order_delivered_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  final OrderRecord order;
  const LiveTrackingScreen({super.key, required this.order});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  double _progress = 0.0;
  Timer? _timer;
  final DateTime _pickupTime = DateTime.now();

  @override
  void initState() {
    super.initState();
      _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() => _progress = (_progress + 0.04).clamp(0.0, 1.0));
      if (_progress >= 1.0) {
        timer.cancel();
        _onDelivered();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onDelivered() {
    context.read<OrdersCubit>().markCompleted(widget.order.id);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderDeliveredScreen(order: widget.order)),
    );
  }

  void _showUnavailable(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$action isn't available in this demo.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deliveredTime = _pickupTime.add(const Duration(minutes: 45));
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                  Expanded(
                    child: Text('Live Tracking', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _MapPlaceholder(progress: _progress),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _TrackingActionButton(
                              icon: Icons.call,
                              label: 'Call the delivery boy',
                              onTap: () => _showUnavailable('Calling'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _TrackingActionButton(
                              icon: Icons.message,
                              label: 'Message the delivery boy',
                              onTap: () => _showUnavailable('Messaging'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _ProgressTrack(progress: _progress),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery goes your way', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontSize: 11)),
                          Text('Pick up your delivery', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatShortDate(_pickupTime), style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                          Text(_formatShortDate(deliveredTime), style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final double progress;
  const _MapPlaceholder({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.peachCircle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_2.png', 
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment(-1 + progress * 2, 0),
            child: const Icon(Icons.delivery_dining, color: Colors.black87, size: 32),
          ),
        ],
      ),
    );
  }
}

class _TrackingActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _TrackingActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  final double progress;
  const _ProgressTrack({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: const LinearGradient(colors: [Colors.red, Colors.orange, Colors.green]),
          ),
        ),
        Align(
          alignment: Alignment(-1 + progress * 2, 0),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatShortDate(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${dt.day} ${months[dt.month - 1]} ${dt.year.toString().substring(2)}';
}