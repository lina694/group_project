import 'package:flutter/material.dart';
import '../models/car.dart';
import '../database/database_helper.dart';
import 'car_details_screen.dart';
import 'car_list_with_details_screen.dart';

/// The main screen for displaying the list of cars.
///
/// This widget handles responsive design by checking the screen width.
/// It renders [_PhoneCarListScreen] for smaller devices and
/// [CarListWithDetailsScreen] for tablets and desktops.
class CarListScreen extends StatelessWidget {
  /// Creates a [CarListScreen].
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    if (isLargeScreen) {
      // Desktop/Tablet: Side-by-side layout
      return const CarListWithDetailsScreen();
    } else {
      // Phone: Full screen layout
      return const _PhoneCarListScreen();
    }
  }
}

/// The phone version of the car list screen using full-screen navigation.
class _PhoneCarListScreen extends StatefulWidget {
  const _PhoneCarListScreen();

  @override
  State<_PhoneCarListScreen> createState() => _PhoneCarListScreenState();
}

class _PhoneCarListScreenState extends State<_PhoneCarListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Car> _cars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Cars For Sale'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  /// Fetches the list of cars from the database.
  Future<void> _loadCars() async {
    setState(() => _isLoading = true);
    final cars = await _dbHelper.getAllCars();
    setState(() {
      _cars = cars;
      _isLoading = false;
    });
  }

  /// Displays instructions on how to use the app.
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use Cars For Sale'),
        content: const SingleChildScrollView(
          child: Text(
            '1. Click "Add Car" to list a new car for sale\n\n'
                '2. Fill in all required fields.\n\n'
                '3. Click Submit to save the listing.\n\n'
                '4. Tap on a car from the list to view/edit details.\n\n'
                '5. Use Update to save changes or Delete to remove the listing.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Navigates to the details screen.
  Future<void> _navigateToDetails({Car? car}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailsScreen(car: car),
      ),
    );
    _loadCars(); // Refresh list when returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars For Sale'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
            tooltip: 'Instructions',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToDetails(),
                icon: const Icon(Icons.add),
                label: const Text('Add Car'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cars.isEmpty
                ? const Center(
              child: Text(
                'No cars listed yet.\nTap "Add Car" to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _cars.length,
              itemBuilder: (context, index) {
                final car = _cars[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.directions_car, size: 40),
                    title: Text(
                      car.toString(), // Ensure Car model has toString() or use properties
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\$${car.price.toStringAsFixed(2)} • ${car.kilometers} km',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToDetails(car: car),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}