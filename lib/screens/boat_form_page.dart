import 'package:flutter/material.dart';
import '../models/boat.dart';
import '../database/db_helper.dart';
import '../services/secure_prefs.dart';
import 'package:group_project/l10n/app_localizations.dart';

/// Add / Edit boat form page
class BoatFormPage extends StatefulWidget {
  final Boat? boat;

  const BoatFormPage({super.key, this.boat});

  @override
  State<BoatFormPage> createState() => _BoatFormPageState();
}

class _BoatFormPageState extends State<BoatFormPage> {
  final year = TextEditingController();
  final length = TextEditingController();
  final price = TextEditingController();
  final address = TextEditingController();

  String powerType = "sail";

  bool get editing => widget.boat != null;

  @override
  void initState() {
    super.initState();

    if (editing) {
      final b = widget.boat!;
      year.text = b.year;
      length.text = b.length;
      price.text = b.price;
      address.text = b.address;
      powerType = b.powerType;
    } else {
      askCopyPrevious(); // safe 호출됨 (post-frame 내부에서 Localization 호출)
    }
  }

  /// Ask user if they want to copy previous boat information
  void askCopyPrevious() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final t = AppLocalizations.of(context)!;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(t.copyPrevious),
          content: Text(t.copyPreviousContent),
          actions: [
            TextButton(
              onPressed: () async {
                final data = await SecurePrefs.loadLastBoat();
                year.text = data["year"] ?? "";
                length.text = data["length"] ?? "";
                powerType = data["powerType"] ?? "sail";
                price.text = data["price"] ?? "";
                address.text = data["address"] ?? "";
                setState(() {});
                Navigator.pop(context);
              },
              child: Text(t.yes),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.no),
            ),
          ],
        ),
      );
    });
  }

  bool validate() {
    if (year.text.isEmpty ||
        length.text.isEmpty ||
        price.text.isEmpty ||
        address.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return false;
    }
    return true;
  }

  void saveToPrefs() {
    SecurePrefs.saveLastBoat({
      "year": year.text,
      "length": length.text,
      "powerType": powerType,
      "price": price.text,
      "address": address.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? t.editBoat : t.addBoat),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: year,
              decoration: InputDecoration(labelText: t.yearBuilt),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: length,
              decoration: InputDecoration(labelText: t.length),
              keyboardType: TextInputType.text,
            ),

            DropdownButtonFormField(
              value: powerType,
              items: [
                DropdownMenuItem(
                  value: "sail",
                  child: Text("${t.powerType} (sail)"),
                ),
                DropdownMenuItem(
                  value: "motor",
                  child: Text("${t.powerType} (motor)"),
                ),
              ],
              onChanged: (v) => setState(() => powerType = v!),
            ),

            TextField(
              controller: price,
              decoration: InputDecoration(labelText: t.price),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: address,
              decoration: InputDecoration(labelText: t.address),
            ),

            const SizedBox(height: 20),

            if (!editing)
              ElevatedButton(
                child: Text(t.submit),
                onPressed: () async {
                  if (!validate()) return;

                  final boat = Boat(
                    year: year.text,
                    length: length.text,
                    powerType: powerType,
                    price: price.text,
                    address: address.text,
                  );

                  await DBHelper.insertBoat(boat);
                  saveToPrefs();
                  Navigator.pop(context);
                },
              ),

            if (editing) ...[
              ElevatedButton(
                child: Text(t.update),
                onPressed: () async {
                  if (!validate()) return;

                  final boat = widget.boat!;
                  boat.year = year.text;
                  boat.length = length.text;
                  boat.powerType = powerType;
                  boat.price = price.text;
                  boat.address = address.text;

                  await DBHelper.updateBoat(boat);
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red),
                child: Text(t.delete),
                onPressed: () async {
                  await DBHelper.deleteBoat(widget.boat!.id!);
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
