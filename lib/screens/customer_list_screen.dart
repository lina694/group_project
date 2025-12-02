import 'package:flutter/material.dart';
import '../database/customer_database.dart';
import '../l10n/app_localizations.dart';
import '../models/customer.dart';

/// A screen that displays a list of all customers from the database.
class CustomerListScreen extends StatefulWidget {
  /// A callback function that is triggered when a customer is tapped.
  final ValueChanged<Customer> onCustomerSelected;

  /// The ID of the currently selected customer, used for highlighting in tablet mode.
  final int? selectedCustomerId;

  /// Creates a [CustomerListScreen] widget.
  const CustomerListScreen({
    super.key,
    required this.onCustomerSelected,
    this.selectedCustomerId,
  });

  @override
  State<CustomerListScreen> createState() => CustomerListScreenState();
}

/// The state for [CustomerListScreen].
class CustomerListScreenState extends State<CustomerListScreen> {
  /// A [Future] that holds the list of customers from the database.
  late Future<List<Customer>> _customers;

  @override
  void initState() {
    super.initState();
    refreshCustomers();
  }

  /// Refreshes the list of customers from the database.
  ///
  /// This method is public so it can be called from the parent
  /// [CustomerResponsiveLayout] using a [GlobalKey].
  void refreshCustomers() {
    setState(() {
      _customers = CustomerDatabase.instance.readAllCustomers();
    });
  }

  /// Shows the help [AlertDialog] as required by the project.
  void _showHelpDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.helpTitle),
        content: Text(l10n.helpContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customersTitle),
        actions: [
          // Help button
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
        future: _customers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(l10n.noCustomersFound));
          } else {
            final customers = snapshot.data!;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                // Check if this item is the one selected in tablet mode
                final isSelected = customer.id == widget.selectedCustomerId;

                return ListTile(
                  title: Text('${customer.firstName} ${customer.lastName}'),
                  subtitle: Text(customer.address),
                  selected: isSelected, // Apply highlight if selected
                  onTap: () {
                    widget.onCustomerSelected(customer);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}