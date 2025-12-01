import 'package:flutter/material.dart';
import '../models/boat.dart';
import '../database/db_helper.dart';
import '../services/secure_prefs.dart';
import 'package:group_project/l10n/app_localizations.dart';

/// A form page used to add a new boat or edit an existing boat.
///
/// This page fulfills the following Final Project requirements:
/// - TextFields for inserting data (Requirement #2)
/// - Insert, update, and delete functionality using SQLite (Req #1, #3)
/// - Shows a Snackbar when validation fails (Req #5)
/// - Shows an AlertDialog for "copy previous boat" (Req #5)
/// - Saves last-entered values in EncryptedSharedPreferences (Req #6)
/// - Supports multi-language localization (Req #8)
/// - Displays a full-screen detail page on phones (Req #4)
class BoatFormPage extends StatefulWidget {
  /// The boat being edited.
  /// If null, the page is in "Add Mode".
  final Boat? boat;

  const BoatFormPage({super.key, this.boat});

  @override
  State<BoatFormPage> createState() => _BoatFormPageState();
}

class _BoatFormPageState extends State<BoatFormPage> {
  /// Controls the text input for the boat year.
  final year = TextEditingController();

  /// Controls the text input for the boat length.
  final length = TextEditingController();

  /// Controls the text input for the boat price.
  final price = TextEditingController();

  /// Controls the text input for the address.
  final address = TextEditingController();

  /// The selected power type ('sail' or 'motor').
  String powerType = "sail";

  /// Indicates whether the page is editing an existing boat.
  bool get editing => widget.boat != null;

  @override
  void initState() {
    super.initState();

    if (editing) {
      // Pre-fill the form with existing boat data
      final b = widget.boat!;
      year.text = b.year;
      length.text = b.length;
      price.text = b.price;
      address.text = b.address;
      powerType = b.powerType;
    } else {
      // Ask whether user wants to copy previous boat information
      askCopyPrevious();
    }
  }

  /// Prompts the user to copy previously saved data using secure storage.
  ///
  /// Localization requires the context to be fully ready, so we use
  /// addPostFrameCallback.
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

  /// Validates that all required fields have been filled.
  ///
  /// Shows a snackbar if validation fails.
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

  /// Saves the last entered boat information into secure preferences.
  ///
  /// This fulfills Requirement #6: using EncryptedSharedPreferences.
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
            /// Year field
            TextField(
              controller: year,
              decoration: InputDecoration(labelText: t.yearBuilt),
              keyboardType: TextInputType.number,
            ),

            /// Length field
            TextField(
              controller: length,
              decoration: InputDecoration(labelText: t.length),
              keyboardType: TextInputType.text,
            ),

            /// Power type dropdown
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

            /// Price field
            TextField(
              controller: price,
              decoration: InputDecoration(labelText: t.price),
              keyboardType: TextInputType.number,
            ),

            /// Address
            TextField(
              controller: address,
              decoration: InputDecoration(labelText: t.address),
            ),

            const SizedBox(height: 20),

            /// Add Mode
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

            /// Edit Mode
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
