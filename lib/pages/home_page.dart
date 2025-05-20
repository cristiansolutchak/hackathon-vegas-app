// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';
import 'package:hackathon_vegas/models/locker_model.dart';
import 'package:hackathon_vegas/models/locker_token.dart';
import 'package:hackathon_vegas/pages/locker_detail_page.dart';
import 'package:hackathon_vegas/services/api_services.dart';
import 'package:hackathon_vegas/services/local_storage.dart';
import 'package:hackathon_vegas/services/nfc_services.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_card.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_gradient_button.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_loading_indicator.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_locker_icon.dart';
import 'package:hackathon_vegas/shared/widgets/bitcoin_status_badge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final NfcService _nfcService = NfcService();
  final storage = const FlutterSecureStorage();

  List<Locker> _lockers = [];
  bool _isLoading = true;
  bool _isNfcAvailable = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLockers();
    _checkNfcAvailability();
  }

  Future<void> _loadLockers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final lockers = await _apiService.getLockers();
      setState(() {
        _lockers = lockers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Falha ao carregar armários: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkNfcAvailability() async {
    bool isAvailable = await _nfcService.checkAvailability();
    setState(() {
      _isNfcAvailable = isAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: BitcoinLockerTheme.darkGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(slivers: [_buildAppBar(), _buildBody()]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadLockers,
        backgroundColor: BitcoinLockerTheme.primaryOrange,
        child: const Icon(Icons.refresh_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                BitcoinLockerTheme.primaryOrange.withValues(alpha: 0.7),
                BitcoinLockerTheme.darkBackground.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/bitlocker_icon.svg',
                    width: 70,
                    height: 70,
                  ),
                  // const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bitcoin Lockers',
                        style: BitcoinLockerTheme.textTheme.headlineMedium,
                      ),
                      Text(
                        'Decentralized security',
                        style: BitcoinLockerTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      _isNfcAvailable
                          ? BitcoinLockerTheme.success.withValues(alpha: 0.2)
                          : BitcoinLockerTheme.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isNfcAvailable ? Icons.nfc_rounded : Icons.error_rounded,
                      size: 16,
                      color:
                          _isNfcAvailable
                              ? BitcoinLockerTheme.success
                              : BitcoinLockerTheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isNfcAvailable ? 'NFC Available' : 'NFC Unavailable',
                      style: BitcoinLockerTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            _isNfcAvailable
                                ? BitcoinLockerTheme.success
                                : BitcoinLockerTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: BitcoinLoadingIndicator(message: 'Loading lockers...'),
        ),
      );
    }

    if (_errorMessage != null) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: BitcoinLockerTheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading',
                style: BitcoinLockerTheme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: BitcoinLockerTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              BitcoinGradientButton(
                text: 'Try again',
                icon: Icons.refresh_rounded,
                onPressed: _loadLockers,
              ),
            ],
          ),
        ),
      );
    }

    if (_lockers.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 64,
                color: BitcoinLockerTheme.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No lockers available',
                style: BitcoinLockerTheme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'There are no lockers registered in the system.',
                style: BitcoinLockerTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 4),
            child: Text(
              'Available lockers (2)',
              style: BitcoinLockerTheme.textTheme.titleLarge,
            ),
          ),
          ...List.generate(_lockers.length, (index) {
            final locker = _lockers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildLockerCard(locker),
            );
          }),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _buildLockerCard(Locker locker) {
    return GestureDetector(
      onTap: () {
        // if (locker.state == 'available') {
        _showReservationDialog(context, locker);
        // }
      },
      child: BitcoinCard(
        padding: EdgeInsets.zero,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient:
                locker.state == 'available'
                    ? LinearGradient(
                      colors: [
                        BitcoinLockerTheme.surfaceColor,
                        BitcoinLockerTheme.surfaceColor,
                        BitcoinLockerTheme.primaryOrange.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                decoration: BoxDecoration(
                  color:
                      locker.state == 'available'
                          ? BitcoinLockerTheme.success
                          : BitcoinLockerTheme.error,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              BitcoinLockerIcon(state: locker.state, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Locker #${locker.id}',
                          style: BitcoinLockerTheme.textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        BitcoinStatusBadge(status: locker.state),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      locker.state == 'available'
                          ? 'Tap to use this locker'
                          : 'This locker is in use',
                      style: BitcoinLockerTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (locker.state == 'available')
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BitcoinLockerTheme.primaryOrange.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: BitcoinLockerTheme.primaryOrange,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

void _showReservationDialog(BuildContext context, Locker locker) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm Reservation"),
      content: Text(
        "Do you really want to reserve locker #${locker.id}?",
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _useLocker(locker);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: BitcoinLockerTheme.primaryOrange,
          ),
          child: const Text("Reserve"),
        ),
      ],
    ),
  );
}


  Future<void> _useLocker(Locker locker) async {
    if (locker.state != 'available') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Este armário não está disponível'),
          backgroundColor: BitcoinLockerTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: BitcoinLoadingIndicator(message: 'Reservando armário...'),
          ),
    );

    try {
      final LockerToken token = await _apiService.useLocker(locker.id);

      LockerToken(lockerId: 1,startTime: 1747780667, signature: 'B1BBDDD7CC1E714B47B4D272B74B0B57FDC7D6C2C0C2E8CA03FA09619DF85F02F865A3E8ACBE5C4A5EDA220BFD0E8858C3CC8B6FE7730BA735A7BCB8B5A6F788');

      print('token: ${token.lockerId}');
      print('token: ${token.startTime}');
      print('token: ${token.signature}');

      saveLockerToken(token);
      print(getLockerToken(token.lockerId.toString()));

      // Fecha o diálogo de carregamento
      Navigator.of(context).pop();

      // Navega para a página do armário
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => LockerDetailPage(
                lockerId: locker.id,
                token: token,
                apiService: _apiService,
                nfcService: _nfcService,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ).then((_) => _loadLockers());
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao reservar armário: $e'),
          backgroundColor: BitcoinLockerTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}