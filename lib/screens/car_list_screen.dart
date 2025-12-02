// import 'package:flutter/material.dart';
// import '../models/car.dart';
// import '../database/database_helper.dart';
// import 'car_details_screen.dart';
// import 'car_list_with_details_screen.dart';
//
// /// Screen displaying the list of all cars for sale.
// /// Automatically switches between phone and desktop/tablet layouts.
// class CarListScreen extends StatelessWidget {
//   const CarListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Check screen width (Requirement 4: Responsive layout)
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth > 600;
//
//     if (isLargeScreen) {
//       // Desktop/Tablet: Side-by-side layout
//       return const CarListWithDetailsScreen();
//     } else {
//       // Phone: Full screen layout
//       return const _PhoneCarListScreen();
//     }
//   }
// }
//
// /// Phone version of car list screen (full screen navigation).
// class _PhoneCarListScreen extends StatefulWidget {
//   const _PhoneCarListScreen();
//
//   @override
//   State<_PhoneCarListScreen> createState() => _PhoneCarListScreenState();
// }
//
// class _PhoneCarListScreenState extends State<_PhoneCarListScreen> {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   List<Car> _cars = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCars();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Welcome to Cars For Sale'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     });
//   }
//
//   Future<void> _loadCars() async {
//     setState(() => _isLoading = true);
//     final cars = await _dbHelper.getAllCars();
//     setState(() {
//       _cars = cars;
//       _isLoading = false;
//     });
//   }
//
//   void _showHelpDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('How to Use Cars For Sale'),
//         content: const SingleChildScrollView(
//           child: Text(
//             '1. Click "Add Car" to list a new car for sale\n\n'
//                 '2. Fill in all required fields:\n'
//                 '   • Year of Manufacture\n'
//                 '   • Make (e.g., Toyota, Tesla)\n'
//                 '   • Model (e.g., Corolla, Model 3)\n'
//                 '   • Price\n'
//                 '   • Kilometers Driven\n\n'
//                 '3. Click Submit to save the listing\n\n'
//                 '4. Tap on a car from the list to view/edit details\n\n'
//                 '5. Use Update to save changes or Delete to remove the listing',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _navigateToDetails({Car? car}) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CarDetailsScreen(car: car),
//       ),
//     );
//     _loadCars();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cars For Sale'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.help_outline),
//             onPressed: _showHelpDialog,
//             tooltip: 'Instructions',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => _navigateToDetails(),
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add Car'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//                   foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _cars.isEmpty
//                 ? const Center(
//               child: Text(
//                 'No cars listed yet.\nTap "Add Car" to get started!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             )
//                 : ListView.builder(
//               itemCount: _cars.length,
//               itemBuilder: (context, index) {
//                 final car = _cars[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: ListTile(
//                     leading: const Icon(Icons.directions_car, size: 40),
//                     title: Text(
//                       car.toString(),
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       '\$${car.price.toStringAsFixed(2)} • ${car.kilometers} km',
//                     ),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () => _navigateToDetails(car: car),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
