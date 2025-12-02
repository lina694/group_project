import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/boat.dart';
import '../widgets/boat_tile.dart';
import 'boat_form_page.dart';
import 'package:group_project/l10n/app_localizations.dart';

/// Displays a scrollable list of all boats saved in the database.
/// This is the main page of the Boats module.
class BoatListPage extends StatefulWidget {
  const BoatListPage({super.key});

  @override
  State<BoatListPage> createState() => _BoatListPageState();
}

class _BoatListPageState extends State<BoatListPage> {
  /// A list containing all boats retrieved from the database.
  List<Boat> boats = [];

  /// Loads all boats from the database and refreshes the UI.
  Future<void> loadBoats() async {
    final data = await DBHelper.getBoats();
    setState(() => boats = data);
  }

  @override
  void initState() {
    super.initState();
    loadBoats();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),

        /// ActionBar info button requirement.
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(t.appTitle),
                  content: Text(t.instructions),
                ),
              );
            },
          ),
        ],
      ),

      /// List of boats
      body: ListView.builder(
        itemCount: boats.length,
        itemBuilder: (_, index) {
          final boat = boats[index];
          return InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BoatFormPage(boat: boat),
                ),
              );

              /// Refresh list after returning
              loadBoats();
            },
            child: BoatTile(boat: boat),
          );
        },
      ),

      /// Floating button to add a new boat
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BoatFormPage(),
            ),
          );
          loadBoats();
        },
      ),
    );
  }
}
