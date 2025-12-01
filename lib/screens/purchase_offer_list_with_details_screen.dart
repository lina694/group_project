
import 'package:flutter/material.dart';
import '../database/purchase_offer_database_helper.dart';
import '../models/purchase_offer.dart';
import 'purchase_offer_details_screen.dart';

class PurchaseOfferListWithDetailsScreen extends StatefulWidget {
  const PurchaseOfferListWithDetailsScreen({super.key});

  @override
  State<PurchaseOfferListWithDetailsScreen> createState() =>
      _PurchaseOfferListWithDetailsScreenState();
}

class _PurchaseOfferListWithDetailsScreenState
    extends State<PurchaseOfferListWithDetailsScreen> {
  final _dbHelper = PurchaseOfferDatabaseHelper();
  List<PurchaseOffer> _offers = [];
  bool _isLoading = true;
  PurchaseOffer? _selectedOffer;
  bool _isAddingNew = false;

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
    final offers = await _dbHelper.getAllOffers();
    setState(() {
      _offers = offers;
      _isLoading = false;

      if (_selectedOffer != null &&
          !_offers.any((o) => o.id == _selectedOffer!.id)) {
        _selectedOffer = null;
        _isAddingNew = false;
      }
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('How to Use Purchase Offers'),
        content: SingleChildScrollView(
          child: Text(
            'Left: list of offers.\n'
                'Right: details of selected offer.\n\n'
                'Use "Add Offer" to create a new one,\n'
                'click an existing offer to edit or delete it.',
          ),
        ),
      ),
    );
  }

  void _onOfferChanged() {
    _loadOffers();
    setState(() {
      _selectedOffer = null;
      _isAddingNew = false;
    });
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
      body: Row(
        children: [
          // Left panel: list
          SizedBox(
            width: 400,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedOffer = null;
                          _isAddingNew = true;
                        });
                      },
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
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No purchase offers yet.\nClick "Add Offer" to begin.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _offers.length,
                    itemBuilder: (context, index) {
                      final offer = _offers[index];
                      final isSelected =
                          _selectedOffer?.id == offer.id;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        color: isSelected
                            ? Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            : null,
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long),
                          title: Text(
                            'Customer #${offer.customerId} • ${offer.itemType.toUpperCase()} #${offer.itemId}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '\$${offer.price.toStringAsFixed(2)} • ${offer.status}',
                          ),
                          trailing:
                          const Icon(Icons.chevron_right),
                          onTap: () {
                            setState(() {
                              _selectedOffer = offer;
                              _isAddingNew = false;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const VerticalDivider(width: 1),

          // Right panel: details
          Expanded(
            child: _isAddingNew || _selectedOffer != null
                ? _DesktopPurchaseOfferDetails(
              offer: _selectedOffer,
              onOfferChanged: _onOfferChanged,
              key: ValueKey(_selectedOffer?.id ?? 'new'),
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 100,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select an offer to view details',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'or click "Add Offer" to create a new one',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopPurchaseOfferDetails extends StatelessWidget {
  final PurchaseOffer? offer;
  final VoidCallback onOfferChanged;

  const _DesktopPurchaseOfferDetails({
    super.key,
    this.offer,
    required this.onOfferChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PurchaseOfferDetailsScreen(
      offer: offer,
      isEmbedded: true,
      onSaved: onOfferChanged,
    );
  }
}
