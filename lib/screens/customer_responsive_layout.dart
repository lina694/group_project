import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/customer.dart';
import 'customer_list_screen.dart';
import 'customer_details_screen.dart';

/// A widget that handles the responsive layout for the customer feature.
class CustomerResponsiveLayout extends StatefulWidget {
  const CustomerResponsiveLayout({super.key});

  @override
  State<CustomerResponsiveLayout> createState() =>
      _CustomerResponsiveLayoutState();
}

class _CustomerResponsiveLayoutState extends State<CustomerResponsiveLayout> {
  Customer? _selectedCustomer;
  bool _showAddForm = false;
  bool _copyData = false;
  final GlobalKey<CustomerListScreenState> _listKey =
  GlobalKey<CustomerListScreenState>();

  void _refreshList() {
    _listKey.currentState?.refreshCustomers();
    setState(() {
      _selectedCustomer = null;
      _showAddForm = false;
      _copyData = false;
    });
  }

  void _onCustomerSelected(Customer customer, bool isTablet) {
    if (isTablet) {
      setState(() {
        _selectedCustomer = customer;
        _showAddForm = false;
        _copyData = false;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerDetailsScreen(
            customer: customer,
            onDataChanged: _refreshList,
          ),
        ),
      );
    }
  }

  void _navigateToAddPage({required bool copy, required bool isTablet}) {
    if (isTablet) {
      setState(() {
        _selectedCustomer = null;
        _showAddForm = true;
        _copyData = copy;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerDetailsScreen(
            onDataChanged: _refreshList,
            copyData: copy,
          ),
        ),
      );
    }
  }

  void _showAddDialog({required bool isTablet}) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addCustomerTitle),
        content: Text(l10n.copyPrompt),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAddPage(copy: false, isTablet: isTablet);
            },
            child: Text(l10n.blank),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAddPage(copy: true, isTablet: isTablet);
            },
            child: Text(l10n.copyPrevious),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(isTablet: isTablet),
            child: const Icon(Icons.add),
          ),
          body: isTablet
              ? _buildTabletLayout(isTablet)
              : _buildPhoneLayout(isTablet),
        );
      },
    );
  }

  Widget _buildPhoneLayout(bool isTablet) {
    return CustomerListScreen(
      key: _listKey,
      onCustomerSelected: (customer) => _onCustomerSelected(customer, isTablet),
    );
  }

  Widget _buildTabletLayout(bool isTablet) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomerListScreen(
            key: _listKey,
            selectedCustomerId: _selectedCustomer?.id,
            onCustomerSelected: (customer) =>
                _onCustomerSelected(customer, isTablet),
          ),
        ),
        Expanded(
          flex: 2,
          child: _selectedCustomer != null
              ? CustomerDetailsScreen(
            key: ValueKey(_selectedCustomer!.id),
            customer: _selectedCustomer,
            onDataChanged: _refreshList,
            isTablet: true,
          )
              : _showAddForm
              ? CustomerDetailsScreen(
            key: const ValueKey('add_form'),
            onDataChanged: _refreshList,
            copyData: _copyData,
            isTablet: true,
          )
              : Center(
            child: Text(l10n.detailsPlaceholder),
          ),
        ),
      ],
    );
  }
}