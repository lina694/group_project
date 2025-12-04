import 'package:flutter/material.dart';
import '../database/boat_database.dart';
import '../models/boat.dart';

/// A screen that displays a list of all boats stored in the database.
class BoatListScreen extends StatefulWidget {
  /// Callback triggered when a boat is tapped.
  final ValueChanged<Boat> onBoatSelected;

  /// The ID of the currently selected boat (for highlighting in tablet mode).
  final int? selectedBoatId;

  /// Creates a [BoatListScreen].
  const BoatListScreen({
    super.key,
    required this.onBoatSelected,
    this.selectedBoatId,
  });

  @override
  State<BoatListScreen> createState() => BoatListScreenState();
}

class BoatListScreenState extends State<BoatListScreen> {
  /// Future holding the list of boats from the database.
  late Future<List<Boat>> _boats;

  @override
  void initState() {
    super.initState();
    refreshBoats();
  }

  /// Reloads the list of boats from the database.
  void refreshBoats() {
    setState(() {
      _boats = BoatDatabase.instance.readAllBoats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boats For Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const AlertDialog(
                    title: Text("Help"),
                    content: Text("Tap a boat to view details or edit.\nPress + to add a new boat.")
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Boat>>(
        future: _boats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No boats found.'));
          } else {
            final boats = snapshot.data!;
            return ListView.builder(
              itemCount: boats.length,
              itemBuilder: (context, index) {
                final boat = boats[index];
                final isSelected = boat.id == widget.selectedBoatId;

                return ListTile(
                  leading: const Icon(Icons.sailing),
                  title: Text(boat.name),
                  subtitle: Text('\$${boat.price}'),
                  selected: isSelected,
                  onTap: () {
                    widget.onBoatSelected(boat);
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