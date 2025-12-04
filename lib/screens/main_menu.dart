// Import the entry points for all 4 modules
import '../l10n/app_localizations.dart';
import 'car_list_screen.dart';
import 'boat_responsive_layout.dart';
import 'customer_responsive_layout.dart';
import 'purchase_offer_responsive_layout.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Access localization
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Project Main Menu'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'CST2335 Group Project',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // 1. Cars For Sale
              _buildMenuButton(
                context,
                'Cars For Sale',
                Icons.directions_car,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarListScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // 2. Boats for Sale
              _buildMenuButton(
                context,
                'Boats For Sale',
                Icons.sailing,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Links to the new Master-Detail layout
                      builder: (context) => const BoatResponsiveLayout(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // 3. Customer List
              _buildMenuButton(
                context,
                l10n.customersTitle,
                Icons.person_outline,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerResponsiveLayout(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // 4. Purchase Offers
              _buildMenuButton(
                context,
                'Purchase Offers',
                Icons.local_offer,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Links to the new Master-Detail layout
                      builder: (context) => const PurchaseOfferResponsiveLayout(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget to build consistent menu buttons
  Widget _buildMenuButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}