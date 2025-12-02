// import 'package:flutter/material.dart';
// import '../models/car.dart';
// import '../database/database_helper.dart';
// import 'car_details_screen.dart';
//
// /// Combined screen for tablet/desktop layout (Requirement 4).
// /// Shows car list on left and details on right side-by-side.
// class CarListWithDetailsScreen extends StatefulWidget {
//   const CarListWithDetailsScreen({super.key});
//
//   @override
//   State<CarListWithDetailsScreen> createState() => _CarListWithDetailsScreenState();
// }
//
// class _CarListWithDetailsScreenState extends State<CarListWithDetailsScreen> {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   List<Car> _cars = [];
//   bool _isLoading = true;
//   Car? _selectedCar;
//   bool _isAddingNew = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCars();
//
//     // Show welcome Snackbar
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
//   /// Loads all cars from the database.
//   Future<void> _loadCars() async {
//     setState(() => _isLoading = true);
//     final cars = await _dbHelper.getAllCars();
//     setState(() {
//       _cars = cars;
//       _isLoading = false;
//       // Clear selection if car was deleted
//       if (_selectedCar != null && !_cars.any((c) => c.id == _selectedCar!.id)) {
//         _selectedCar = null;
//         _isAddingNew = false;
//       }
//     });
//   }
//
//   /// Shows the help dialog with instructions.
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
//                 '4. Click on a car from the list to view/edit details\n\n'
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
//   /// Callback when car is saved or deleted.
//   void _onCarChanged() {
//     _loadCars();
//     setState(() {
//       _selectedCar = null;
//       _isAddingNew = false;
//     });
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
//       body: Row(
//         children: [
//           // Left side: Car List
//           SizedBox(
//             width: 400,
//             child: Column(
//               children: [
//                 // Add Car Button
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _selectedCar = null;
//                           _isAddingNew = true;
//                         });
//                       },
//                       icon: const Icon(Icons.add),
//                       label: const Text('Add Car'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//                         foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Car List
//                 Expanded(
//                   child: _isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : _cars.isEmpty
//                       ? const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Text(
//                         'No cars listed yet.\nTap "Add Car" to get started!',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   )
//                       : ListView.builder(
//                     itemCount: _cars.length,
//                     itemBuilder: (context, index) {
//                       final car = _cars[index];
//                       final isSelected = _selectedCar?.id == car.id;
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 4,
//                         ),
//                         color: isSelected
//                             ? Theme.of(context).colorScheme.primaryContainer
//                             : null,
//                         child: ListTile(
//                           leading: const Icon(Icons.directions_car, size: 32),
//                           title: Text(
//                             car.toString(),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text(
//                             '\$${car.price.toStringAsFixed(2)} • ${car.kilometers} km',
//                           ),
//                           trailing: const Icon(Icons.chevron_right),
//                           onTap: () {
//                             setState(() {
//                               _selectedCar = car;
//                               _isAddingNew = false;
//                             });
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Divider
//           const VerticalDivider(width: 1),
//
//           // Right side: Details
//           Expanded(
//             child: _isAddingNew || _selectedCar != null
//                 ? _DesktopCarDetails(
//               car: _selectedCar,
//               onCarChanged: _onCarChanged,
//               key: ValueKey(_selectedCar?.id ?? 'new'),
//             )
//                 : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.directions_car_outlined,
//                     size: 100,
//                     color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Select a car to view details',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'or click "Add Car" to create a new listing',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Desktop version of car details embedded in the side panel.
// class _DesktopCarDetails extends StatelessWidget {
//   final Car? car;
//   final VoidCallback onCarChanged;
//
//   const _DesktopCarDetails({
//     super.key,
//     this.car,
//     required this.onCarChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CarDetailsScreen(
//       car: car,
//       isEmbedded: true,
//       onSaved: onCarChanged,
//     );
//   }
// }