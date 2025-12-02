
import 'package:flutter/material.dart';

import '../database/purchase_offer_database_helper.dart';
import '../models/purchase_offer.dart';
import 'purchase_offer_details_screen.dart';

class PurchaseOfferListScreen extends StatefulWidget {
  const PurchaseOfferListScreen({super.key});

  @override
  State<PurchaseOfferListScreen> createState() =>
      _PurchaseOfferPhoneListScreenState();
}

class _PurchaseOfferPhoneListScreenState
    extends State<PurchaseOfferListScreen> {
  final _dbHelper = PurchaseOfferDatabaseHelper();
  List<PurchaseOffer> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Purchase Offers'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  Future<void> _loadOffers() async {
    setState(() => _isLoading = true);

    try {
      final offers = await _dbHelper.getAllOffers();
      setState(() {
        _offers = offers;
        _isLoading = false;
      });
    } catch (e, stack) {
      debugPrint('Error loading offers: $e');
      debugPrint('$stack');
      setState(() {
        _offers = [];
        _isLoading = false;
      });
    }
  }


  Future<void> _navigateToDetails({PurchaseOffer? offer}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseOfferDetailsScreen(offer: offer),
      ),
    );
    _loadOffers();
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('How to Use Purchase Offers'),
        content: SingleChildScrollView(
          child: Text(
            '1. Tap "Add Offer" to create a new purchase offer.\n'
                '2. Fill in all required fields.\n'
                '3. Tap an offer to view or edit it.\n'
                '4. Use Update or Delete in the details screen.',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToDetails(),
                icon: const Icon(Icons.add),
                label: const Text('Add Offer'),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _offers.isEmpty
                ? const Center(
              child: Text(
                'No purchase offers yet.\nTap "Add Offer" to start.',
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                final offer = _offers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, size: 32),
                    title: Text(
                      'Customer #${offer.customerId} • ${offer.itemType.toUpperCase()} #${offer.itemId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '\$${offer.price.toStringAsFixed(2)} • ${offer.status}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToDetails(offer: offer),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
