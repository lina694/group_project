import 'package:flutter/material.dart';
import '../database/purchase_database.dart';
import '../models/purchase_offer.dart';

/// Screen for creating and updating purchase offers.
class PurchaseOfferDetailsScreen extends StatefulWidget {
  final PurchaseOffer? offer;
  final VoidCallback onDataChanged;
  final bool isTablet;

  const PurchaseOfferDetailsScreen({
    super.key,
    this.offer,
    required this.onDataChanged,
    this.isTablet = false,
  });

  @override
  State<PurchaseOfferDetailsScreen> createState() => _PurchaseOfferDetailsScreenState();
}

class _PurchaseOfferDetailsScreenState extends State<PurchaseOfferDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _statusController;

  bool get _isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.offer?.buyerName ?? '');
    _amountController = TextEditingController(text: widget.offer?.amount.toString() ?? '');
    _dateController = TextEditingController(text: widget.offer?.date ?? '');
    _statusController = TextEditingController(text: widget.offer?.status ?? 'Pending');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _saveOffer() async {
    if (!_formKey.currentState!.validate()) return;

    final offer = PurchaseOffer(
      id: widget.offer?.id,
      buyerName: _nameController.text,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      date: _dateController.text,
      status: _statusController.text,
    );

    if (_isEditing) {
      await PurchaseDatabase.instance.update(offer);
    } else {
      await PurchaseDatabase.instance.create(offer);
    }

    widget.onDataChanged();
    if (Navigator.canPop(context) && !widget.isTablet) {
      Navigator.pop(context);
    }
  }

  Future<void> _deleteOffer() async {
    if (widget.offer?.id != null) {
      await PurchaseDatabase.instance.delete(widget.offer!.id!);
      widget.onDataChanged();
      if (Navigator.canPop(context) && !widget.isTablet) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isTablet ? null : AppBar(title: Text(_isEditing ? 'Edit Offer' : 'New Offer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.isTablet)
                Text(_isEditing ? 'Edit Offer' : 'New Offer', style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Buyer Name')),
              TextFormField(controller: _amountController, decoration: const InputDecoration(labelText: 'Amount')),
              TextFormField(controller: _dateController, decoration: const InputDecoration(labelText: 'Date')),
              TextFormField(controller: _statusController, decoration: const InputDecoration(labelText: 'Status')),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: _saveOffer, child: const Text('Save'))),
                  if (_isEditing) ...[
                    const SizedBox(width: 10),
                    Expanded(child: ElevatedButton(onPressed: _deleteOffer, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete'))),
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}