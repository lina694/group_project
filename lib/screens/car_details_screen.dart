import 'package:flutter/material.dart';
import '../utils/localization_helper.dart';
import '../models/car.dart';
import '../database/database_helper.dart';
import '../utils/secure_storage.dart';

/// Screen for adding new cars or editing existing car listings.
/// Supports copying information from the previously added car.
class CarDetailsScreen extends StatefulWidget {
  final Car? car;
  final bool isEmbedded; // NEW: Whether this is embedded in desktop layout
  final VoidCallback? onSaved; // NEW: Callback when car is saved/deleted

  const CarDetailsScreen({
    super.key,
    this.car,
    this.isEmbedded = false, // NEW
    this.onSaved, // NEW
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late TextEditingController _yearController;
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _kilometersController;

  bool get _isNewCar => widget.car == null;

  @override
  void initState() {
    super.initState();

    _yearController = TextEditingController(
      text: widget.car?.year.toString() ?? '',
    );
    _makeController = TextEditingController(text: widget.car?.make ?? '');
    _modelController = TextEditingController(text: widget.car?.model ?? '');
    _priceController = TextEditingController(
      text: widget.car?.price.toString() ?? '',
    );
    _kilometersController = TextEditingController(
      text: widget.car?.kilometers.toString() ?? '',
    );

    // If adding new car, ask to copy previous
    if (_isNewCar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _askToCopyPrevious();
      });
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _kilometersController.dispose();
    super.dispose();
  }

  /// Asks user if they want to copy information from the previous car.
  Future<void> _askToCopyPrevious() async {
    final lastCar = await SecureStorageHelper.getLastCar();

    if (lastCar == null || !mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Copy from Previous Car?'),
        content: const Text(
          'Would you like to copy the information from the previous car listing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _copyFromPrevious(lastCar);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  /// Copies information from the previous car to the form fields.
  void _copyFromPrevious(Car car) {
    setState(() {
      _yearController.text = car.year.toString();
      _makeController.text = car.make;
      _modelController.text = car.model;
      _priceController.text = car.price.toString();
      _kilometersController.text = car.kilometers.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Information copied from previous car')),
    );
  }

  /// Validates and saves the car (insert or update).
  Future<void> _saveCar() async {
    if (!_formKey.currentState!.validate()) return;

    final car = Car(
      id: widget.car?.id,
      year: int.parse(_yearController.text),
      make: _makeController.text,
      model: _modelController.text,
      price: double.parse(_priceController.text),
      kilometers: int.parse(_kilometersController.text),
    );

    if (_isNewCar) {
      await _dbHelper.insertCar(car);
      await SecureStorageHelper.saveLastCar(car);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car listing added successfully')),
        );
      }
    } else {
      await _dbHelper.updateCar(car);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car listing updated successfully')),
        );
      }
    }

    // Handle navigation based on mode
    if (mounted) {
      if (widget.isEmbedded) {
        // Call callback for desktop layout
        widget.onSaved?.call();
      } else {
        // Pop for phone layout
        Navigator.pop(context);
      }
    }
  }

  /// Shows confirmation dialog and deletes the car.
  Future<void> _deleteCar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Car Listing'),
        content: const Text(
          'Are you sure you want to delete this car listing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.car != null) {
      await _dbHelper.deleteCar(widget.car!.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car listing deleted successfully')),
        );

        if (widget.isEmbedded) {
          widget.onSaved?.call();
        } else {
          Navigator.pop(context);
        }
      }
    }
  }

  /// Shows the help dialog with instructions.
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use Car Details'),
        content: const SingleChildScrollView(
          child: Text(
            'Fill in all the required fields:\n\n'
                '• Year: The year the car was manufactured\n'
                '• Make: The car manufacturer (e.g., Toyota, Tesla, Volkswagen)\n'
                '• Model: The specific model (e.g., Corolla, Model 3, Jetta)\n'
                '• Price: The selling price in dollars\n'
                '• Kilometers: Total distance driven\n\n'
                'Click Submit to save the car listing or Update to save changes.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Only show AppBar if not embedded
        appBar: widget.isEmbedded ? null : AppBar(
          title: Text(_isNewCar ? 'Add New Car' : 'Edit Car'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _showHelpDialog,
              tooltip: 'Instructions',
            ),
          ],
        ),

        body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
              // Year Field
              TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Year of Manufacture',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the year';
                }
                final year = int.tryParse(value);
                if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                  return 'Please enter a valid year';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Make Field
            TextFormField(
              controller: _makeController,
              decoration: const InputDecoration(
                labelText: 'Make',
                hintText: 'e.g., Toyota, Tesla, Volkswagen',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the make';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Model Field
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'e.g., Corolla, Model 3, Jetta',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_car),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the model';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'Sale price in dollars',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Kilometers Field
            TextFormField (
              controller: _kilometersController,
              decoration: InputDecoration(
                labelText: LocalizationHelper.kilometers,
                hintText: LocalizationHelper.kilometersHint,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.speed),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the kilometers';
                }
                final km = int.tryParse(value);
                if (km == null || km < 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),

                const SizedBox(height: 24),

                // Action Buttons
                if (_isNewCar)
                // Submit Button (for new car)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveCar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                else
                // Update and Delete Buttons (for existing car)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveCar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _deleteCar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
        ),
    );
  }
}