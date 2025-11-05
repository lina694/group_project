import 'package:flutter/material.dart';
import 'car_list_screen.dart';

/// Main menu screen that displays navigation buttons for all team members' modules.
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
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

              // Cars For Sale Button
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

              // Member 2 Module Button
              _buildMenuButton(
                context,
                'Member 2 Module',
                Icons.person,
                    () {
                  // TODO: Navigate to Member 2's screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Member 2 Module - Coming Soon')),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Member 3 Module Button
              _buildMenuButton(
                context,
                'Member 3 Module',
                Icons.person,
                    () {
                  // TODO: Navigate to Member 3's screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Member 3 Module - Coming Soon')),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Member 4 Module Button
              _buildMenuButton(
                context,
                'Member 4 Module',
                Icons.person,
                    () {
                  // TODO: Navigate to Member 4's screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Member 4 Module - Coming Soon')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a menu button with consistent styling.
  ///
  /// [context] - BuildContext for navigation
  /// [label] - Button text label
  /// [icon] - Icon to display on button
  /// [onPressed] - Callback function when button is pressed
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