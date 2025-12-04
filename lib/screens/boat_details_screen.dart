import 'package:flutter/material.dart';
import '../database/boat_database.dart';
import '../models/boat.dart';

/// Screen for adding new boats or editing existing ones.
class BoatDetailsScreen extends StatefulWidget {
  /// The boat object to edit. If null, creates a new boat.
  final Boat? boat;

  /// Callback to notify parent widget to refresh the list.
  final VoidCallback onDataChanged;

  /// Flag indicating if the screen is embedded in a tablet layout.
  final bool isTablet;

  /// Creates a [BoatDetailsScreen].
  const BoatDetailsScreen({
    super.key,
    this.boat,
    required this.onDataChanged,
    this.isTablet = false,
  });

  @override
  State<BoatDetailsScreen> createState() => _BoatDetailsScreenState();
}

class _BoatDetailsScreenState extends State<BoatDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lengthController;
  late TextEditingController _priceController;
  late TextEditingController _powerController;

  /// Checks if we are editing an existing boat.
  bool get _isEditing => widget.boat != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lengthController = TextEditingController();
    _priceController = TextEditingController();
    _powerController = TextEditingController();

    // Pre-fill fields if editing
    if (_isEditing) {
      _nameController.text = widget.boat!.name;
      _lengthController.text = widget.boat!.length.toString();
      _priceController.text = widget.boat!.price.toString();
      _powerController.text = widget.boat!.powerType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lengthController.dispose();
    _priceController.dispose();
    _powerController.dispose();
    super.dispose();
  }

  /// Validates and saves the boat to the database.
  Future<void> _saveBoat() async {
    if (!_formKey.currentState!.validate()) return;

    final boat = Boat(
      id: widget.boat?.id,
      name: _nameController.text,
      length: double.tryParse(_lengthController.text) ?? 0.0,
      price: double.tryParse(_priceController.text) ?? 0.0,
      powerType: _powerController.text,
    );

    if (_isEditing) {
      await BoatDatabase.instance.update(boat);
    } else {
      await BoatDatabase.instance.create(boat);
    }

    widget.onDataChanged();

    // Only pop if on phone
    if (Navigator.canPop(context) && !widget.isTablet) {
      Navigator.pop(context);
    }
  }

  /// Deletes the boat from the database.
  Future<void> _deleteBoat() async {
    if (widget.boat?.id != null) {
      await BoatDatabase.instance.delete(widget.boat!.id!);
      widget.onDataChanged();

      if (Navigator.canPop(context) && !widget.isTablet) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hide AppBar on tablet
      appBar: widget.isTablet ? null : AppBar(title: Text(_isEditing ? 'Edit Boat' : 'Add Boat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.isTablet)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                      _isEditing ? 'Edit Boat' : 'Add Boat',
                      style: Theme.of(context).textTheme.headlineSmall
                  ),
                ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name/Make', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lengthController,
                decoration: const InputDecoration(labelText: 'Length (ft)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _powerController,
                decoration: const InputDecoration(labelText: 'Power Type (Sail/Motor)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: _saveBoat,
                          child: const Text('Save')
                      )
                  ),
                  if (_isEditing) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        onPressed: _deleteBoat,
                        child: const Text('Delete'),
                      ),
                    ),
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