import 'package:flutter/material.dart';
import '../models/purchase_offer.dart';
import 'purchase_offer_list_screen.dart';
import 'purchase_offer_details_screen.dart';

/// Manages the responsive master-detail layout for Purchase Offers.
class PurchaseOfferResponsiveLayout extends StatefulWidget {
  const PurchaseOfferResponsiveLayout({super.key});

  @override
  State<PurchaseOfferResponsiveLayout> createState() => _PurchaseOfferResponsiveLayoutState();
}

class _PurchaseOfferResponsiveLayoutState extends State<PurchaseOfferResponsiveLayout> {
  PurchaseOffer? _selectedOffer;
  bool _showAddForm = false;
  final GlobalKey<PurchaseOfferListScreenState> _listKey = GlobalKey<PurchaseOfferListScreenState>();

  void _refreshList() {
    _listKey.currentState?.refreshOffers();
    setState(() {
      _selectedOffer = null;
      _showAddForm = false;
    });
  }

  void _onOfferSelected(PurchaseOffer offer, bool isTablet) {
    if (isTablet) {
      setState(() {
        _selectedOffer = offer;
        _showAddForm = false;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseOfferDetailsScreen(
            offer: offer,
            onDataChanged: _refreshList,
          ),
        ),
      );
    }
  }

  void _navigateToAddPage({required bool isTablet}) {
    if (isTablet) {
      setState(() {
        _selectedOffer = null;
        _showAddForm = true;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseOfferDetailsScreen(
            onDataChanged: _refreshList,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToAddPage(isTablet: isTablet),
            child: const Icon(Icons.add),
          ),
          body: isTablet ? _buildTabletLayout(isTablet) : _buildPhoneLayout(isTablet),
        );
      },
    );
  }

  Widget _buildPhoneLayout(bool isTablet) {
    return PurchaseOfferListScreen(
      key: _listKey,
      onOfferSelected: (offer) => _onOfferSelected(offer, isTablet),
    );
  }

  Widget _buildTabletLayout(bool isTablet) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: PurchaseOfferListScreen(
            key: _listKey,
            selectedOfferId: _selectedOffer?.id,
            onOfferSelected: (offer) => _onOfferSelected(offer, isTablet),
          ),
        ),
        Expanded(
          flex: 2,
          child: _selectedOffer != null
              ? PurchaseOfferDetailsScreen(
            key: ValueKey(_selectedOffer!.id),
            offer: _selectedOffer,
            onDataChanged: _refreshList,
            isTablet: true,
          )
              : _showAddForm
              ? PurchaseOfferDetailsScreen(
            key: const ValueKey('add_form'),
            onDataChanged: _refreshList,
            isTablet: true,
          )
              : const Center(child: Text('Select an offer or press + to add.')),
        ),
      ],
    );
  }
}