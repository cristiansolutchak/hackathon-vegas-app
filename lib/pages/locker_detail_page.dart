// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';
import 'package:hackathon_vegas/models/invoice_model.dart';
import 'package:hackathon_vegas/models/locker_model.dart';
import 'package:hackathon_vegas/services/api_services.dart';
import 'package:hackathon_vegas/services/local_storage.dart';
import 'package:hackathon_vegas/services/nfc_services.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_card.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_divider.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_gradient_button.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_loading_indicator.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_locker_icon.dart';
import 'package:hackathon_vegas/shared/widgets/qr_code_with_lightning.dart';

class LockerDetailPage extends StatefulWidget {
  final int lockerId;
  final LockerToken token;
  final ApiService apiService;
  final NfcService nfcService;

  const LockerDetailPage({
    super.key,
    required this.lockerId,
    required this.token,
    required this.apiService,
    required this.nfcService,
  });

  @override
  LockerDetailPageState createState() => LockerDetailPageState();
}

class LockerDetailPageState extends State<LockerDetailPage>
    with SingleTickerProviderStateMixin {
  bool _isOpening = false;
  bool _isFinishingUse = false;
  bool _isPaymentPending = false;
  bool _isNfcWriting = false;
  Invoice? _invoice;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: BitcoinLockerTheme.darkGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leadingWidth: 70,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: BitcoinLockerTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: BitcoinLockerTheme.textLight,
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    const BitcoinLockerIcon(state: 'available', size: 28),
                    const SizedBox(width: 12),
                    Text('Locker #${widget.lockerId}'),
                  ],
                ),
              ),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (_isNfcWriting)
            _buildNfcWritingUI()
          else if (_isPaymentPending && _invoice != null)
            _buildPaymentUI()
          else
            _buildLockerDetailsUI(),
        ]),
      ),
    );
  }

  Widget _buildLockerDetailsUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BitcoinCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BitcoinLockerTheme.primaryOrange.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock_open_rounded,
                      color: BitcoinLockerTheme.primaryOrange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Locker Reserved',
                          style: BitcoinLockerTheme.textTheme.titleLarge,
                        ),
                        Text(
                          'Your locker is ready to use',
                          style: BitcoinLockerTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const BitcoinDivider(),
              Text('Details', style: BitcoinLockerTheme.textTheme.titleMedium),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.numbers_rounded,
                title: 'Locker ID',
                value: '#${widget.lockerId}',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.access_time_rounded,
                title: 'Start time',
                value: _formatDateTime(
                  DateTime.fromMillisecondsSinceEpoch(
                    widget.token.startTime * 1000,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.monetization_on_rounded,
                title: 'Price',
                value: '100 sats/min',
                valueColor: BitcoinLockerTheme.primaryOrange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Actions', style: BitcoinLockerTheme.textTheme.titleLarge),
        const SizedBox(height: 16),
        BitcoinCard(
          child: Column(
            children: [
              _buildActionButton(
                onPressed: _isOpening ? null : _openLockerWithNfc,
                icon: Icons.contactless_rounded,
                title: 'Open locker with NFC',
                subtitle: 'Hold your phone close to the locker reader',
                isLoading: _isOpening,
              ),
              const BitcoinDivider(indent: 56, endIndent: 16),
              _buildActionButton(
                onPressed: _isFinishingUse ? null : _finishUse,
                icon: Icons.check_circle_outline_rounded,
                title: 'Finish use',
                subtitle: 'End usage and pay for the time used',
                isSuccess: true,
                isLoading: _isFinishingUse,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Payment will be calculated based on usage time.',
          style: BitcoinLockerTheme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: BitcoinLockerTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: BitcoinLockerTheme.textSecondary, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: BitcoinLockerTheme.textTheme.bodyMedium),
            Text(
              value,
              style: BitcoinLockerTheme.textTheme.titleMedium?.copyWith(
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String title,
    required String subtitle,
    bool isSuccess = false,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isSuccess
                          ? BitcoinLockerTheme.success
                          : BitcoinLockerTheme.primaryOrange)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    isLoading
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isSuccess
                                  ? BitcoinLockerTheme.success
                                  : BitcoinLockerTheme.primaryOrange,
                            ),
                          ),
                        )
                        : Icon(
                          icon,
                          color:
                              isSuccess
                                  ? BitcoinLockerTheme.success
                                  : BitcoinLockerTheme.primaryOrange,
                          size: 24,
                        ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: BitcoinLockerTheme.textTheme.titleMedium,
                    ),
                    Text(
                      subtitle,
                      style: BitcoinLockerTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: BitcoinLockerTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNfcWritingUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated circles
                  ...List.generate(3, (index) {
                    final delay = index * 0.3;
                    final Animation<double> animation = CurvedAnimation(
                      parent: _animController,
                      curve: Interval(
                        delay,
                        delay + 0.7,
                        curve: Curves.easeOut,
                      ),
                    );

                    return Positioned.fill(
                      child: ScaleTransition(
                        scale: Tween(begin: 0.5, end: 1.5).animate(animation),
                        child: Opacity(
                          opacity: (1.0 - animation.value).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: BitcoinLockerTheme.primaryOrange
                                    .withValues(alpha: 0.8),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Center icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: BitcoinLockerTheme.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.contactless_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        Text(
          'Hold your phone close',
          style: BitcoinLockerTheme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Place the back of your phone near the locker’s NFC reader',
          style: BitcoinLockerTheme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 48),
        BitcoinGradientButton(
          text: 'Cancel',
          onPressed: () {
            setState(() {
              _isNfcWriting = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        BitcoinCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BitcoinLockerTheme.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bolt_rounded,
                      color: BitcoinLockerTheme.warning,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Pending',
                          style: BitcoinLockerTheme.textTheme.titleLarge,
                        ),
                        Text(
                          'Scan the code to complete',
                          style: BitcoinLockerTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const BitcoinDivider(),
              QrCodeWithLightning(data: _invoice!.bolt11),
              const SizedBox(height: 24),
              Text(
                'Amount to pay',
                style: BitcoinLockerTheme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${_invoice!.amount} sats',
                style: BitcoinLockerTheme.textTheme.displaySmall?.copyWith(
                  color: BitcoinLockerTheme.primaryOrange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Scan the QR code above with a compatible Lightning wallet',
                style: BitcoinLockerTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              BitcoinGradientButton(
                text: 'Check Payment',
                icon: Icons.refresh_rounded,
                onPressed: _checkPaymentStatus,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Aqui poderíamos criar uma opção para copiar a invoice
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invoice copied to clipboard'),
                      backgroundColor: BitcoinLockerTheme.info,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: const Text('Copy Lightning invoice'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openLockerWithNfc() async {
    setState(() {
      _isOpening = true;
      _isNfcWriting = true;
    });

    try {
      await widget.nfcService.writeNfcTag(widget.token);
      setState(() {
        _isOpening = false;
        _isNfcWriting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Locker successfully unlocked!'),
            ],
          ),
          backgroundColor: BitcoinLockerTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      deleteLockerToken('1');
      // TODO: Pegar o token
    } catch (e) {
      setState(() {
        _isOpening = false;
        _isNfcWriting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error using NFC: $e'),
          backgroundColor: BitcoinLockerTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _finishUse() async {
    setState(() {
      _isFinishingUse = true;
    });

    try {
      final invoice = await widget.apiService.payForUsage(widget.lockerId);
      setState(() {
        _invoice = invoice;
        _isPaymentPending = true;
        _isFinishingUse = false;
      });
    } catch (e) {
      setState(() {
        _isFinishingUse = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error finishing usage: \$e'),
          backgroundColor: BitcoinLockerTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (_invoice == null) return;

    // Mostrar indicador de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: BitcoinLoadingIndicator(message: 'Checking payment...'),
          ),
    );

    try {
      final receipt = await widget.apiService.getPaymentReceipt(
        _invoice!.paymentHash,
      );

      // Fecha o diálogo de carregamento
      Navigator.of(context).pop();

      // Mostrar confirmação e opção para desbloquear
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: BitcoinCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: BitcoinLockerTheme.success.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          color: BitcoinLockerTheme.success,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Payment Confirmed!',
                        style: BitcoinLockerTheme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You can now open the locker to retrieve your belongings.',
                        style: BitcoinLockerTheme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),
                      BitcoinGradientButton(
                        text: 'Open Locker',
                        icon: Icons.contactless_rounded,
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _isPaymentPending = false;
                            _isNfcWriting = true;
                          });
                        widget.nfcService.writeNfcTag(receipt);
                        },
                      ),
                    ],
              ),
                ),
              ),
            ),
      );
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment not yet confirmed'),
          backgroundColor: BitcoinLockerTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
