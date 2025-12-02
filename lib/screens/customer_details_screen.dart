import 'package:flutter/material.dart';
import '../database/customer_database.dart';
import '../l10n/app_localizations.dart';
import '../models/customer.dart';
import '../services/customer_prefs.dart';

/// A screen for adding, viewing, and editing customer details.
class CustomerDetailsScreen extends StatefulWidget {
  /// The customer to edit. If null, the screen is in "add" mode.
  final Customer? customer;

  /// A callback function to notify the parent widget that data has changed.
  final VoidCallback onDataChanged;

  /// If true, the form will pre-fill with data from [CustomerPrefs].
  final bool copyData;

  /// Flag to indicate if the layout is for a tablet (true) or phone (false).
  final bool isTablet;

  const CustomerDetailsScreen({
    super.key,
    this.customer,
    required this.onDataChanged,
    this.copyData = false,
    this.isTablet = false,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prefs = CustomerPrefs();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;
  late TextEditingController _licenseController;

  bool get _isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _addressController = TextEditingController();
    _dobController = TextEditingController();
    _licenseController = TextEditingController();

    if (widget.copyData) {
      _loadLastCustomer();
    } else if (_isEditing) {
      _loadCustomerData();
    }
  }

  @override
  void didUpdateWidget(covariant CustomerDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customer != oldWidget.customer) {
      if (_isEditing) {
        _loadCustomerData();
      } else {
        _clearForm();
      }
    }
  }

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _addressController.clear();
    _dobController.clear();
    _licenseController.clear();
  }

  void _loadCustomerData() {
    if (widget.customer != null) {
      _firstNameController.text = widget.customer!.firstName;
      _lastNameController.text = widget.customer!.lastName;
      _addressController.text = widget.customer!.address;
      _dobController.text = widget.customer!.dob;
      _licenseController.text = widget.customer!.licenseNumber;
    }
  }

  Future<void> _loadLastCustomer() async {
    Customer? lastCustomer = await _prefs.getLastCustomer();
    if (lastCustomer != null) {
      _firstNameController.text = lastCustomer.firstName;
      _lastNameController.text = lastCustomer.lastName;
      _addressController.text = lastCustomer.address;
      _dobController.text = lastCustomer.dob;
      _licenseController.text = lastCustomer.licenseNumber;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _licenseController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _saveCustomer() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_validateFields()) {
      _showSnackBar(l10n.allFieldsRequired, isError: true);
      return;
    }

    final customer = Customer(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: _addressController.text,
      dob: _dobController.text,
      licenseNumber: _licenseController.text,
    );

    await CustomerDatabase.instance.create(customer);
    await _prefs.saveLastCustomer(customer);

    _showSnackBar(l10n.customerCreated);
    widget.onDataChanged();
    if (Navigator.canPop(context) && !widget.isTablet) {
      Navigator.pop(context);
    }
  }

  Future<void> _updateCustomer() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_validateFields()) {
      _showSnackBar(l10n.allFieldsRequired, isError: true);
      return;
    }
    if (widget.customer == null) return;

    final updatedCustomer = widget.customer!.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: _addressController.text,
      dob: _dobController.text,
      licenseNumber: _licenseController.text,
    );

    await CustomerDatabase.instance.update(updatedCustomer);
    await _prefs.saveLastCustomer(updatedCustomer);

    _showSnackBar(l10n.customerUpdated);
    widget.onDataChanged();
    if (Navigator.canPop(context) && !widget.isTablet) {
      Navigator.pop(context);
    }
  }

  void _showDeleteDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteDialogTitle),
        content: Text(l10n.deleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (widget.customer?.id == null) return;

              await CustomerDatabase.instance.delete(widget.customer!.id!);

              _showSnackBar(l10n.customerDeleted);
              Navigator.pop(context);
              widget.onDataChanged();

              if (Navigator.canPop(context) && !widget.isTablet) {
                Navigator.pop(context);
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: widget.isTablet
          ? null
          : AppBar(
        title: Text(_isEditing ? l10n.editCustomer : l10n.addCustomer),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.isTablet)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    _isEditing ? l10n.editCustomer : l10n.addCustomer,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: l10n.firstName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: l10n.lastName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: l10n.address,
                  prefixIcon: const Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: l10n.dob,
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _licenseController,
                decoration: InputDecoration(
                  labelText: l10n.license,
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 24),
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updateCustomer,
                        child: Text(l10n.update),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showDeleteDialog,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.error,
                            foregroundColor:
                            Theme.of(context).colorScheme.onError),
                        child: Text(l10n.delete),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveCustomer,
                    child: Text(l10n.submit),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}