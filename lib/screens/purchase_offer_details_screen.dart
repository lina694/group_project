
import 'package:flutter/material.dart';

import '../database/purchase_offer_database_helper.dart';
import '../models/purchase_offer.dart';


class PurchaseOfferDetailsScreen extends StatefulWidget {
  final PurchaseOffer? offer;       // null = new offer
  final bool isEmbedded;            // like CarDetailsScreen
  final VoidCallback? onSaved;      // called after insert/update/delete

  const PurchaseOfferDetailsScreen({
    super.key,
    this.offer,
    this.isEmbedded = false,
    this.onSaved,
  });
  //
  @override
  State<PurchaseOfferDetailsScreen> createState() =>
      _PurchaseOfferDetailsScreenState();
}

class _PurchaseOfferDetailsScreenState
    extends State<PurchaseOfferDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = PurchaseOfferDatabaseHelper();

  late TextEditingController _customerIdController;
  late TextEditingController _itemIdController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;

  // itemType: car / boat
  String _itemType = 'car';
  final List<String> _itemTypeOptions = ['car', 'boat'];

  // status: ACCEPTED / REJECTED
  String _status = 'ACCEPTED';
  final List<String> _statusOptions = ['ACCEPTED', 'REJECTED'];

  bool get _isNewOffer => widget.offer == null;

  @override
  void initState() {
    super.initState();

    _customerIdController = TextEditingController(
      text: widget.offer?.customerId.toString() ?? '',
    );
    _itemIdController = TextEditingController(
      text: widget.offer?.itemId.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.offer?.price.toString() ?? '',
    );
    _dateController = TextEditingController(
      text: widget.offer?.offerDate ?? '',
    );
    _itemType = widget.offer?.itemType ?? 'car';
    _status = widget.offer?.status ?? 'ACCEPTED';

    // If you want to copy last offer from secure storage, you can
    // trigger a dialog here for new offers (similar to CarDetailsScreen).
    // WidgetsBinding.instance.addPostFrameCallback((_) => _askToCopyPrevious());
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    _itemIdController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _saveOffer() async {
    if (!_formKey.currentState!.validate()) return;

    final offer = PurchaseOffer(
      id: widget.offer?.id,
      customerId: int.parse(_customerIdController.text.trim()),
      itemId: int.parse(_itemIdController.text.trim()),
      itemType: _itemType,
      price: double.parse(_priceController.text.trim()),
      offerDate: _dateController.text.trim(),
      status: _status,
    );

    if (_isNewOffer) {
      await _dbHelper.insertOffer(offer);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase offer added successfully')),
        );
      }
      // TODO: save last offer to secure storage if needed
    } else {
      await _dbHelper.updateOffer(offer);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase offer updated successfully')),
        );
      }
    }

    if (!mounted) return;

    if (widget.isEmbedded) {
      widget.onSaved?.call();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _deleteOffer() async {
    if (widget.offer == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Purchase Offer'),
        content: const Text(
          'Are you sure you want to delete this purchase offer?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbHelper.deleteOffer(widget.offer!.id!);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase offer deleted successfully')),
      );

      if (widget.isEmbedded) {
        widget.onSaved?.call();
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('How to Use Purchase Offer Details'),
        content: SingleChildScrollView(
          child: Text(
            'Fill in all fields:\n\n'
                '• Customer ID: ID of the customer making the offer\n'
                '• Item Type: Car or Boat\n'
                '• Item ID: ID of the selected car/boat\n'
                '• Price: Offered price\n'
                '• Date: Date of the offer (YYYY-MM-DD)\n'
                '• Status: ACCEPTED or REJECTED\n\n'
                'Click Submit/Update to save changes, or Delete to remove the offer.',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Customer ID
          TextFormField(
            controller: _customerIdController,
            decoration: const InputDecoration(
              labelText: 'Customer ID',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the customer ID';
              }
              final id = int.tryParse(value.trim());
              if (id == null || id <= 0) {
                return 'Please enter a valid customer ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Item type (car / boat)
          DropdownButtonFormField<String>(
            value: _itemType,
            decoration: const InputDecoration(
              labelText: 'Item Type',
              border: OutlineInputBorder(),
            ),
            items: _itemTypeOptions
                .map(
                  (t) => DropdownMenuItem(
                value: t,
                child: Text(t.toUpperCase()),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _itemType = value);
            },
          ),
          const SizedBox(height: 16),

          // Item ID (car / boat id)
          TextFormField(
            controller: _itemIdController,
            decoration: const InputDecoration(
              labelText: 'Car/Boat ID',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.directions_boat_filled),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the item ID';
              }
              final id = int.tryParse(value.trim());
              if (id == null || id <= 0) {
                return 'Please enter a valid ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Price
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Price offered',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the price';
              }
              final price = double.tryParse(value.trim());
              if (price == null || price <= 0) {
                return 'Please enter a valid price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Date
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Date of offer',
              hintText: 'YYYY-MM-DD',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the date';
              }
              // You can add stronger validation later
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Status
          DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: _statusOptions
                .map(
                  (s) => DropdownMenuItem(
                value: s,
                child: Text(s),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _status = value);
            },
          ),
          const SizedBox(height: 24),

          // Buttons
          if (_isNewOffer)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveOffer,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveOffer,
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _deleteOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: widget.isEmbedded
          ? null
          : AppBar(
        title: Text(_isNewOffer ? 'Add Purchase Offer' : 'Edit Offer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: body,
    );
  }
}
