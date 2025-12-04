import 'package:flutter/material.dart';
import '../database/purchase_database.dart';
import '../models/purchase_offer.dart';

/// Displays a list of all purchase offers.
class PurchaseOfferListScreen extends StatefulWidget {
  final ValueChanged<PurchaseOffer> onOfferSelected;
  final int? selectedOfferId;

  const PurchaseOfferListScreen({
    super.key,
    required this.onOfferSelected,
    this.selectedOfferId,
  });

  @override
  State<PurchaseOfferListScreen> createState() => PurchaseOfferListScreenState();
}

class PurchaseOfferListScreenState extends State<PurchaseOfferListScreen> {
  late Future<List<PurchaseOffer>> _offers;

  @override
  void initState() {
    super.initState();
    refreshOffers();
  }

  void refreshOffers() {
    setState(() {
      _offers = PurchaseDatabase.instance.readAllOffers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Offers'),
        actions: [
          IconButton(icon: const Icon(Icons.help), onPressed: (){
            showDialog(context: context, builder: (c) => const AlertDialog(title: Text("Help"), content: Text("View and edit purchase offers.")));
          })
        ],
      ),
      body: FutureBuilder<List<PurchaseOffer>>(
        future: _offers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No offers found.'));
          } else {
            final offers = snapshot.data!;
            return ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                final isSelected = offer.id == widget.selectedOfferId;

                return ListTile(
                  leading: const Icon(Icons.local_offer),
                  title: Text(offer.buyerName),
                  subtitle: Text('\$${offer.amount}'),
                  selected: isSelected,
                  onTap: () => widget.onOfferSelected(offer),
                );
              },
            );
          }
        },
      ),
    );
  }
}