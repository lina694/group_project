import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/boat.dart';
import '../widgets/boat_tile.dart';
import 'boat_form_page.dart';
import 'package:group_project/l10n/app_localizations.dart';

/// Main page showing list of boats
class BoatListPage extends StatefulWidget {
  const BoatListPage({super.key});

  @override
  State<BoatListPage> createState() => _BoatListPageState();
}

class _BoatListPageState extends State<BoatListPage> {
  List<Boat> boats = [];

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
          )
        ],
      ),

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
              loadBoats();
            },
            child: BoatTile(boat: boat),
          );
        },
      ),

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
